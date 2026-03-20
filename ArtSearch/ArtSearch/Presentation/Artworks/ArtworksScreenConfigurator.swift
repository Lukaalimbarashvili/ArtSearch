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
        let useCase = MuseumCollectionPageUseCase(repository: repository)
        let viewModel = ArtworksViewModel(museumCollectionPageUseCase: useCase)
        return ArtworksViewController(viewModel: viewModel)
    }
}
