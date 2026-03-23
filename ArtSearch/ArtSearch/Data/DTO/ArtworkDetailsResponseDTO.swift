//
//  ArtworkDetailsResponseDTO.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

struct ArtworkDetailsResponseDTO: Decodable {
    let identifiedBy: [IdentifiedByDTO]?
    let shows: [ShowDTO]?
    
    enum CodingKeys: String, CodingKey {
        case identifiedBy = "identified_by"
        case shows
    }
}

struct IdentifiedByDTO: Decodable {
    let type: String
    let content: String?
}

struct ShowDTO: Decodable {
    let id: String
}

extension ArtworkDetailsResponseDTO {
    func toDomain() -> ArtworkDetails {
        let title = identifiedBy?
            .first(where: { $0.type == "Name" })?
            .content

        let visualItemURL = shows?.compactMap { URL(string: $0.id) }.first

        return ArtworkDetails(
            title: title,
            visualItemURL: visualItemURL
        )
    }
}
