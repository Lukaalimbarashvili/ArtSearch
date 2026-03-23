//
//  ArtworkDetailsRepository.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

final class ArtworkDetailsRepository: ArtworkDetailsRepositoryProtocol {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func fetchArtworkDetails(id: URL) async throws -> ArtworkDetails {
        let request = URLRequest(url: id)
        let response = try await networkManager.request(request, as: ArtworkDetailsResponseDTO.self)
        return response.toDomain()
    }
}
