//
//  DigitalObjectRepository.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

final class DigitalObjectRepository: DigitalObjectRepositoryProtocol {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func fetchDigitalObject(id: URL) async throws -> DigitalObject {
        let request = URLRequest(url: id)
        let response = try await networkManager.request(request, as: DigitalObjectResponseDTO.self)
        return response.toDomain()
    }
}
