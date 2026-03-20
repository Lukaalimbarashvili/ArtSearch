//
//  MuseumCollectionPageRepository.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

final class MuseumCollectionPageRepository: MuseumCollectionPageRepositoryProtocol {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func fetchMuseumCollectionPage(nextPageURL: URL?) async throws -> MuseumCollectionPage {
        let request = try RijksmuseumEndpoint.searchRequest(nextPageURL: nextPageURL)
        let response = try await networkManager.request(request, as: MuseumCollectionPageResponseDTO.self)
        return response.toDomain()
    }
}
