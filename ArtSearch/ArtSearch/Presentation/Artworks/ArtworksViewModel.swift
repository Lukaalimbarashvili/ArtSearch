//
//  ArtworksViewModel.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

@MainActor
final class ArtworksViewModel {
    private enum Constants {
        static let nextPageTriggerThreshold = 8
    }

    enum ViewState {
        case reloadAll
        case insertItems([Int])
        case updateVisibleItem(Int)
        case showError
    }

    private let loadArtworkPreviewsUseCase: LoadArtworkPreviewsUseCaseProtocol

    var onStateChange: ((ViewState) -> Void)?

    private var artworks: [ArtworkItemViewData] = []
    private(set) var nextPageURL: URL?
    private var loadTask: Task<Void, Never>?
    private var isLoadingPage = false
    private var loadRequestID = UUID()

    var artworksCount: Int {
        artworks.count
    }
    
    init(loadArtworkPreviewsUseCase: LoadArtworkPreviewsUseCaseProtocol) {
        self.loadArtworkPreviewsUseCase = loadArtworkPreviewsUseCase
    }
    
    deinit {
        loadTask?.cancel()
    }

    func loadArtworks() {
        loadTask?.cancel()
        artworks = []
        nextPageURL = nil
        isLoadingPage = false
        onStateChange?(.reloadAll)
        loadPage(nextPageURL: nil)
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        guard currentIndex >= artworks.count - Constants.nextPageTriggerThreshold else { return }
        guard let nextPageURL, !isLoadingPage else { return }

        loadPage(nextPageURL: nextPageURL)
    }
    
    private func loadPage(nextPageURL: URL?) {
        guard !isLoadingPage else { return }
        
        isLoadingPage = true
        
        loadTask = Task {
            defer {
                isLoadingPage = false
                loadTask = nil
            }
            
            do {
                for try await update in loadArtworkPreviewsUseCase.execute(nextPageURL: nextPageURL) {
                    handle(update)
                }
            } catch is CancellationError {
                return
            } catch {
                if artworks.isEmpty {
                    onStateChange?(.showError)
                }
            }
        }
    }

    private func handle(_ update: ArtworkPreviewUpdate) {
        switch update {
        case let .pagination(nextPageURL):
            self.nextPageURL = nextPageURL

        case let .setPlaceholders(items):
            if artworks.isEmpty {
                artworks = items
                onStateChange?(.reloadAll)
            } else {
                let startIndex = artworks.count
                artworks.append(contentsOf: items)
                let insertedIndices = Array(startIndex ..< artworks.count)
                onStateChange?(.insertItems(insertedIndices))
            }
            
        case let .updateTitle(id, title):
            guard let index = artworks.firstIndex(where: { $0.id == id }) else { return }
            artworks[index].title = title
            artworks[index].titleFailed = false
            onStateChange?(.updateVisibleItem(index))

        case let .failTitle(id):
            guard let index = artworks.firstIndex(where: { $0.id == id }) else { return }
            artworks[index].titleFailed = true
            onStateChange?(.updateVisibleItem(index))

        case let .updateImage(id, imageURL):
            guard let index = artworks.firstIndex(where: { $0.id == id }) else { return }
            artworks[index].imageURL = imageURL
            artworks[index].imageFailed = false
            onStateChange?(.updateVisibleItem(index))

        case let .failImage(id):
            guard let index = artworks.firstIndex(where: { $0.id == id }) else { return }
            artworks[index].imageFailed = true
        }
    }

    func artwork(at index: Int) -> ArtworkItemViewData? {
        guard index < artworks.count else { return nil }
        return artworks[index]
    }
}
