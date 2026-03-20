import Foundation

enum ArtworkPreviewUpdate {
    case pageMetadata(nextPageURL: URL?)
    case setPlaceholders([ArtworkItemViewData])
    case updateTitle(id: URL, title: String?)
    case updateImage(id: URL, imageURL: URL?)
}

protocol LoadArtworkPreviewsUseCaseProtocol {
    func execute(nextPageURL: URL?) -> AsyncThrowingStream<ArtworkPreviewUpdate, Error>
}

struct LoadArtworkPreviewsUseCase: LoadArtworkPreviewsUseCaseProtocol {
    private let collectionRepository: MuseumCollectionPageRepositoryProtocol
    private let networkManager: NetworkManaging

    init(
        collectionRepository: MuseumCollectionPageRepositoryProtocol,
        networkManager: NetworkManaging
    ) {
        self.collectionRepository = collectionRepository
        self.networkManager = networkManager
    }

    func execute(nextPageURL: URL?) -> AsyncThrowingStream<ArtworkPreviewUpdate, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let page = try await collectionRepository.fetchMuseumCollectionPage(nextPageURL: nextPageURL)
                    continuation.yield(.pageMetadata(nextPageURL: page.nextPageURL))

                    let placeholders = page.artworks.map {
                        ArtworkItemViewData(
                            id: $0.id,
                            type: $0.type,
                            title: nil,
                            imageURL: nil
                        )
                    }
                    continuation.yield(.setPlaceholders(placeholders))

                    for artwork in page.artworks {
                        let details = try await fetchArtworkDetails(id: artwork.id)
                        continuation.yield(.updateTitle(id: artwork.id, title: details.title))

                        let imageURL = try await fetchImageURL(from: details.visualItemURL)
                        continuation.yield(.updateImage(id: artwork.id, imageURL: imageURL))
                    }

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    private func fetchArtworkDetails(id: URL) async throws -> ArtworkDetailsResponseDTO {
        let request = RijksmuseumEndpoint.artworkDetailsRequest(id: id)
        return try await networkManager.request(request, as: ArtworkDetailsResponseDTO.self)
    }

    private func fetchImageURL(from visualItemURL: URL?) async throws -> URL? {
        guard let visualItemURL else { return nil }

        let visualItemRequest = RijksmuseumEndpoint.visualItemRequest(id: visualItemURL)
        let visualItem = try await networkManager.request(visualItemRequest, as: VisualItemResponseDTO.self)

        guard let digitalObjectURL = visualItem.digitalObjectURL else {
            return nil
        }

        let digitalObjectRequest = RijksmuseumEndpoint.digitalObjectRequest(id: digitalObjectURL)
        let digitalObject = try await networkManager.request(digitalObjectRequest, as: DigitalObjectResponseDTO.self)
        return digitalObject.imageURL
    }
}
