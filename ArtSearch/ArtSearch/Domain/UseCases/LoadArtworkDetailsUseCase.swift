//
//  LoadArtworkDetailsUseCase.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 23.03.26.
//

import Foundation

protocol LoadArtworkDetailsUseCaseProtocol {
    func execute(id: URL) async throws -> ArtworkDetailData
}

struct LoadArtworkDetailsUseCase: LoadArtworkDetailsUseCaseProtocol {
    private let artworkDetailsRepository: ArtworkDetailsRepositoryProtocol
    private let loadArtworkImageURLUseCase: LoadArtworkImageURLUseCaseProtocol

    init(artworkDetailsRepository: ArtworkDetailsRepositoryProtocol,
        loadArtworkImageURLUseCase: LoadArtworkImageURLUseCaseProtocol) {
        self.artworkDetailsRepository = artworkDetailsRepository
        self.loadArtworkImageURLUseCase = loadArtworkImageURLUseCase
    }

    func execute(id: URL) async throws -> ArtworkDetailData {
        let details = try await artworkDetailsRepository.fetchArtworkDetails(id: id)
        let imageURL = try await loadArtworkImageURLUseCase.execute(from: details.visualItemURL)

        return ArtworkDetailData(
            title: details.title,
            description: details.description,
            year: details.year,
            techniques: details.techniques,
            materials: details.materials,
            webURL: details.webURL,
            imageURL: imageURL
        )
    }
}
