//
//  ArtworksScreenConfigurator.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 20.03.26.
//

import UIKit

enum ArtworksScreenConfigurator {
    static func makeViewController() -> UIViewController {
        let networkManager = NetworkManager()
        let repository = MuseumCollectionPageRepository(networkManager: networkManager)
        let artworkDetailsRepository = ArtworkDetailsRepository(networkManager: networkManager)
        let visualItemRepository = VisualItemRepository(networkManager: networkManager)
        let digitalObjectRepository = DigitalObjectRepository(networkManager: networkManager)
        let useCase = LoadArtworkPreviewsUseCase(
            collectionRepository: repository,
            artworkDetailsRepository: artworkDetailsRepository,
            visualItemRepository: visualItemRepository,
            digitalObjectRepository: digitalObjectRepository
        )
        let viewModel = ArtworksViewModel(loadArtworkPreviewsUseCase: useCase)
        return ArtworksViewController(viewModel: viewModel)
    }
}
