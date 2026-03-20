//
//  ArtworksViewController.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import UIKit

import UIKit

final class ArtworksViewController: UIViewController {
    private let viewModel: ArtworksViewModel

    init(viewModel: ArtworksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "ARtss"
        Task {
            do {
                try await viewModel.loadArtworks()
                for item in viewModel.artworks {
                    print(item.id)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
    }
}
