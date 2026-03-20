//
//  ArtworksViewModel.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

@MainActor
final class ArtworksViewModel {
    
    private let museumCollectionPageUseCase: MuseumCollectionPageUseCaseProtocol

    private(set) var artworks: [ArtworkReference] = []
    private(set) var nextPageURL: URL?

    init(museumCollectionPageUseCase: MuseumCollectionPageUseCaseProtocol) {
        self.museumCollectionPageUseCase = museumCollectionPageUseCase
    }

    func loadArtworks() async throws {
        var allArtworks: [ArtworkReference] = []
        var nextPageURL: URL?

//        repeat {
            let page = try await museumCollectionPageUseCase.execute(nextPageURL: nextPageURL)
            allArtworks.append(contentsOf: page.artworks)
            nextPageURL = page.nextPageURL
            print(nextPageURL)
//        } while nextPageURL != nil

        artworks = allArtworks
        self.nextPageURL = nextPageURL
    }
}
