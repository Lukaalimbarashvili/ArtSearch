//
//  LoadArtworkImageURLUseCase.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 23.03.26.
//

import Foundation

protocol LoadArtworkImageURLUseCaseProtocol {
    func execute(from visualItemURL: URL?) async throws -> URL?
}

struct LoadArtworkImageURLUseCase: LoadArtworkImageURLUseCaseProtocol {
    private let visualItemRepository: VisualItemRepositoryProtocol
    private let digitalObjectRepository: DigitalObjectRepositoryProtocol

    init(visualItemRepository: VisualItemRepositoryProtocol,
        digitalObjectRepository: DigitalObjectRepositoryProtocol) {
        self.visualItemRepository = visualItemRepository
        self.digitalObjectRepository = digitalObjectRepository
    }

    func execute(from visualItemURL: URL?) async throws -> URL? {
        guard let visualItemURL else { return nil }

        let visualItem = try await visualItemRepository.fetchVisualItem(id: visualItemURL)

        guard let digitalObjectURL = visualItem.digitalObjectURL else {
            return nil
        }

        let digitalObject = try await digitalObjectRepository.fetchDigitalObject(id: digitalObjectURL)
        return digitalObject.imageURL
    }
}
