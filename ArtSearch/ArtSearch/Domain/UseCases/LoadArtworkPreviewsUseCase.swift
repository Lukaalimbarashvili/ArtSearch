import Foundation

enum ArtworkPreviewUpdate {
    case pagination(nextPageURL: URL?)
    case setPlaceholders([ArtworkItemViewData])
    case updateTitle(id: URL, title: String?)
    case failTitle(id: URL)
    case updateImage(id: URL, imageURL: URL?)
    case failImage(id: URL)
}

private enum ArtworkLoadResult {
    case title(id: URL, title: String?)
    case failTitle(id: URL)
    case image(id: URL, imageURL: URL?)
    case failImage(id: URL)
}

protocol LoadArtworkPreviewsUseCaseProtocol {
    func execute(nextPageURL: URL?) -> AsyncThrowingStream<ArtworkPreviewUpdate, Error>
}

struct LoadArtworkPreviewsUseCase: LoadArtworkPreviewsUseCaseProtocol {
    
    private enum Constants {
        static let maxConcurrentArtworkLoads = 28
    }

    private let collectionRepository: MuseumCollectionPageRepositoryProtocol
    private let artworkDetailsRepository: ArtworkDetailsRepositoryProtocol
    private let visualItemRepository: VisualItemRepositoryProtocol
    private let digitalObjectRepository: DigitalObjectRepositoryProtocol
    
    init(
        collectionRepository: MuseumCollectionPageRepositoryProtocol,
        artworkDetailsRepository: ArtworkDetailsRepositoryProtocol,
        visualItemRepository: VisualItemRepositoryProtocol,
        digitalObjectRepository: DigitalObjectRepositoryProtocol
    ) {
        self.collectionRepository = collectionRepository
        self.artworkDetailsRepository = artworkDetailsRepository
        self.visualItemRepository = visualItemRepository
        self.digitalObjectRepository = digitalObjectRepository
    }

    func execute(nextPageURL: URL?) -> AsyncThrowingStream<ArtworkPreviewUpdate, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    let page = try await collectionRepository.fetchMuseumCollectionPage(nextPageURL: nextPageURL)
                    continuation.yield(.pagination(nextPageURL: page.nextPageURL))
                    
                    let placeholders = page.artworks.map {
                        ArtworkItemViewData(
                            id: $0.id,
                            type: $0.type,
                            title: nil,
                            imageURL: nil,
                            titleFailed: false,
                            imageFailed: false
                        )
                    }
                    continuation.yield(.setPlaceholders(placeholders))

                    try await loadArtworkPreviews(
                        for: page.artworks,
                        continuation: continuation,
                        maxConcurrent: Constants.maxConcurrentArtworkLoads
                    )
                    
                    continuation.finish()
                } catch is CancellationError {
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }

    private func loadArtworkPreviews(
        for artworks: [ArtworkReference],
        continuation: AsyncThrowingStream<ArtworkPreviewUpdate, Error>.Continuation,
        maxConcurrent: Int
    ) async throws {
        guard !artworks.isEmpty else { return }

        var iterator = artworks.makeIterator()

        try await withThrowingTaskGroup { group in
            for _ in 0 ..< maxConcurrent {
                guard let artwork = iterator.next() else { break }
                group.addTask {
                    try await self.loadUpdates(for: artwork)
                }
            }

            for try await results in group {

                for result in results {
                    switch result {
                    case let .title(id, title):
                        continuation.yield(.updateTitle(id: id, title: title))

                    case let .failTitle(id):
                        continuation.yield(.failTitle(id: id))

                    case let .image(id, imageURL):
                        continuation.yield(.updateImage(id: id, imageURL: imageURL))

                    case let .failImage(id):
                        continuation.yield(.failImage(id: id))
                    }
                }

                if let nextArtwork = iterator.next() {
                    group.addTask {
                        try await self.loadUpdates(for: nextArtwork)
                    }
                }
            }
        }
    }
    
    private func fetchImageURL(from visualItemURL: URL?) async throws -> URL? {
        guard let visualItemURL else { return nil }
        
        let visualItem = try await visualItemRepository.fetchVisualItem(id: visualItemURL)
        
        guard let digitalObjectURL = visualItem.digitalObjectURL else {
            return nil
        }
        
        let digitalObject = try await digitalObjectRepository.fetchDigitalObject(id: digitalObjectURL)
        return digitalObject.imageURL
    }
    
    private func loadUpdates(for artwork: ArtworkReference) async throws -> [ArtworkLoadResult] {
        do {
            let details = try await artworkDetailsRepository.fetchArtworkDetails(id: artwork.id)
            
            var results: [ArtworkLoadResult] = []
            
            if let title = details.title {
                results.append(.title(id: artwork.id, title: title))
            } else {
                results.append(.failTitle(id: artwork.id))
            }
            
            let imageURL = try await fetchImageURL(from: details.visualItemURL)
            if let imageURL {
                results.append(.image(id: artwork.id, imageURL: imageURL))
            } else {
                results.append(.failImage(id: artwork.id))
            }
            
            return results
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            return [
                .failTitle(id: artwork.id),
                .failImage(id: artwork.id)
            ]
        }
    }
}
