//
//  ArtworkDetailView.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 23.03.26.
//

import UIKit

protocol ArtworksRouting: AnyObject {
    func showArtworkDetails(for artwork: ArtworkItemViewData)
}

final class ArtworksRouter: ArtworksRouting {
    weak var viewController: UIViewController?

    func showArtworkDetails(for artwork: ArtworkItemViewData) {
        let detailViewController = ArtworkDetailsScreenConfigurator.makeViewController(artwork: artwork)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
