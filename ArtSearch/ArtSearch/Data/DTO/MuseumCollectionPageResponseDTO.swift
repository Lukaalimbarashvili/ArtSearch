//
//  MuseumCollectionPageResponseDTO.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

struct MuseumCollectionPageResponseDTO: Decodable {
    let next: ResourceReferenceDTO?
    let orderedItems: [ResourceReferenceDTO]
}

struct ResourceReferenceDTO: Decodable {
    let id: String
    let type: String
}

extension MuseumCollectionPageResponseDTO {
    func toDomain() -> MuseumCollectionPage {
        MuseumCollectionPage(
            nextPageURL: next.flatMap { URL(string: $0.id) },
            artworks: orderedItems.compactMap { $0.toDomain() }
        )
    }
}

extension ResourceReferenceDTO {
    func toDomain() -> ArtworkReference? {
        guard let id = URL(string: id) else {
            return nil
        }

        return ArtworkReference(id: id, type: type)
    }
}
