//
//  MuseumCollectionPageUseCase.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

protocol MuseumCollectionPageUseCaseProtocol {
    func execute(nextPageURL: URL?) async throws -> MuseumCollectionPage
}

struct MuseumCollectionPageUseCase: MuseumCollectionPageUseCaseProtocol {
    private let repository: MuseumCollectionPageRepositoryProtocol

    init(repository: MuseumCollectionPageRepositoryProtocol) {
        self.repository = repository
    }

    func execute(nextPageURL: URL?) async throws -> MuseumCollectionPage {
        try await repository.fetchMuseumCollectionPage(nextPageURL: nextPageURL)
    }
}
