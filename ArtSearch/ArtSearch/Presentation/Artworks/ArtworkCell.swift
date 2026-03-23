//
//  ArtworkCell.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 20.03.26.
//

import UIKit
import NukeExtensions

final class ArtworkCell: UICollectionViewCell {
    static let reuseIdentifier = "ArtworkCell"
    
    private static let placeholderImage = UIImage(systemName: "photo")
    private static let imageLoadingOptions = ImageLoadingOptions(placeholder: placeholderImage, failureImage: placeholderImage)

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: placeholderImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NukeExtensions.cancelRequest(for: imageView)
        imageView.image = Self.placeholderImage
        titleLabel.text = nil
    }
    
    func configure(title: String?, imageURL: URL?) {
        titleLabel.text = title
        guard let imageURL else { return }
        NukeExtensions.loadImage(with: imageURL, options: Self.imageLoadingOptions, into: imageView)
    }

    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.separator.cgColor

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalToConstant: 180),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}
