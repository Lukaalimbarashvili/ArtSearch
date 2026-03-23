//
//  ArtworkDetailsScreenConfigurator.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 23.03.26.
//

import UIKit
import SwiftUI

enum ArtworkDetailsScreenConfigurator {
    static func makeViewController(artwork: ArtworkItemViewData) -> UIViewController {
        let networkManager = NetworkManager()
        let artworkDetailsRepository = ArtworkDetailsRepository(networkManager: networkManager)
        let visualItemRepository = VisualItemRepository(networkManager: networkManager)
        let digitalObjectRepository = DigitalObjectRepository(networkManager: networkManager)
        let loadArtworkImageURLUseCase = LoadArtworkImageURLUseCase(
            visualItemRepository: visualItemRepository,
            digitalObjectRepository: digitalObjectRepository
        )
        let useCase = LoadArtworkDetailsUseCase(
            artworkDetailsRepository: artworkDetailsRepository,
            loadArtworkImageURLUseCase: loadArtworkImageURLUseCase
        )
        let viewModel = ArtworkDetailsViewModel(
            artworkID: artwork.id,
            initialArtwork: artwork,
            loadArtworkDetailsUseCase: useCase
        )
        let detailView = ArtworkDetailView(viewModel: viewModel)
        return UIHostingController(rootView: detailView)
    }
}
