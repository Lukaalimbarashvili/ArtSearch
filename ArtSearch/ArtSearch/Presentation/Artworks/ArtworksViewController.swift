//
//  ArtworksViewController.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import UIKit

final class ArtworksViewController: UIViewController {
    
    private let viewModel: ArtworksViewModel
    private let errorStateView = ErrorStateView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ArtworkCell.self, forCellWithReuseIdentifier: ArtworkCell.reuseIdentifier)
        return collectionView
    }()

    init(viewModel: ArtworksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Artworks"
        setupViews()
        bindViewModel()
        viewModel.loadArtworks()
    }

    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(errorStateView)

        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            errorStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            errorStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 16

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(240)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing / 2, bottom: 0, trailing: spacing / 2)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing / 2, bottom: spacing, trailing: spacing / 2)
        section.interGroupSpacing = spacing

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] change in
            guard let self else { return }

            switch change {
            case .reloadAll:
                self.hideErrorState()
                self.collectionView.reloadData()
            case let .updateVisibleItem(index):
                self.updateVisibleItem(index)
            case let .showError(message):
                self.showErrorState(message: message)
            }
        }
        
        errorStateView.onRetry = { [weak self] in
            self?.hideErrorState()
            self?.viewModel.loadArtworks()
        }
    }
    
    private func updateVisibleItem(_ index: Int) {
        guard let artwork = viewModel.artwork(at: index) else { return }

        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ArtworkCell else { return }

        cell.configure(title: displayTitle(for: artwork), imageURL: artwork.imageURL)
    }
    
    private func displayTitle(for artwork: ArtworkItemViewData) -> String {
        if let title = artwork.title {
            return title
        }

        return artwork.titleFailed ? "Title unavailable" : "Loading..."
    }

    private func showErrorState(message: String) {
        errorStateView.configure(message: message)
        errorStateView.isHidden = false
        collectionView.isHidden = true
    }

    private func hideErrorState() {
        errorStateView.isHidden = true
        collectionView.isHidden = false
    }
}

extension ArtworksViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.artworksCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtworkCell.reuseIdentifier,for: indexPath) as? ArtworkCell,
              let artwork = viewModel.artwork(at: indexPath.item) else {
            return UICollectionViewCell()
        }

        cell.configure(title: displayTitle(for: artwork), imageURL: artwork.imageURL)
        return cell
    }
}
