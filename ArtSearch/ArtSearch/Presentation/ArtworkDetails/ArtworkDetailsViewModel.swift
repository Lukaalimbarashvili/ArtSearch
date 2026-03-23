//
//  ArtworkDetailsViewModel.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 23.03.26.
//

import Foundation

@MainActor
@Observable
final class ArtworkDetailsViewModel {
    private(set) var isLoading = false
    private(set) var detail: ArtworkDetailData?
    private(set) var errorMessage: String?

    private let artworkID: URL
    private let initialArtwork: ArtworkItemViewData
    private let loadArtworkDetailsUseCase: LoadArtworkDetailsUseCaseProtocol

    init(artworkID: URL,
        initialArtwork: ArtworkItemViewData,
        loadArtworkDetailsUseCase: LoadArtworkDetailsUseCaseProtocol) {
        self.artworkID = artworkID
        self.initialArtwork = initialArtwork
        self.loadArtworkDetailsUseCase = loadArtworkDetailsUseCase
    }

    var fallbackTitle: String {
        if let title = initialArtwork.title {
            return title
        }

        return initialArtwork.titleFailed ? "Title unavailable" : "Loading..."
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            detail = try await loadArtworkDetailsUseCase.execute(id: artworkID)
        } catch is CancellationError {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
