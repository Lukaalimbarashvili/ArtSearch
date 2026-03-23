//
//  DigitalObjectResponseDTO.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

struct DigitalObjectResponseDTO: Decodable {
    let accessPoint: [DigitalAccessPointDTO]?
    
    enum CodingKeys: String, CodingKey {
        case accessPoint = "access_point"
    }
}

struct DigitalAccessPointDTO: Decodable {
    let id: String
}

extension DigitalObjectResponseDTO {
    func toDomain() -> DigitalObject {
        let imageURL = accessPoint?.compactMap { URL(string: $0.id) }.first
        return DigitalObject(imageURL: imageURL)
    }
}
