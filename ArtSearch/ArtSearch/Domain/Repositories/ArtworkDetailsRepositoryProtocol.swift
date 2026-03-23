//
//  ArtworkDetailsRepositoryProtocol.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 20.03.26.
//

import Foundation

protocol ArtworkDetailsRepositoryProtocol {
    func fetchArtworkDetails(id: URL) async throws -> ArtworkDetails
}
