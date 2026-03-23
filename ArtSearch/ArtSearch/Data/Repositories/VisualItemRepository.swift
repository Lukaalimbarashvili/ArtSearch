//
//  VisualItemRepository.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

final class VisualItemRepository: VisualItemRepositoryProtocol {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func fetchVisualItem(id: URL) async throws -> VisualItem {
        let request = URLRequest(url: id)
        let response = try await networkManager.request(request, as: VisualItemResponseDTO.self)
        return response.toDomain()
    }
}
