//
//  VisualItemResponseDTO.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

struct VisualItemResponseDTO: Decodable {
    let digitallyShownBy: [DigitalObjectReferenceDTO]?
    
    enum CodingKeys: String, CodingKey {
        case digitallyShownBy = "digitally_shown_by"
    }
}

struct DigitalObjectReferenceDTO: Decodable {
    let id: String
}

extension VisualItemResponseDTO {
    func toDomain() -> VisualItem {
        let digitalObjectURL = digitallyShownBy?.compactMap { URL(string: $0.id) }.first
        return VisualItem(digitalObjectURL: digitalObjectURL)
    }
}
