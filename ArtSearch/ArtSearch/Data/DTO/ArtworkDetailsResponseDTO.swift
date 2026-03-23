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
    let referredToBy: [ReferencedTextDTO]?
    let producedBy: ProducedByDTO?
    let madeOf: [MaterialDTO]?
    let subjectOf: [SubjectOfDTO]?
    
    enum CodingKeys: String, CodingKey {
        case identifiedBy = "identified_by"
        case shows
        case referredToBy = "referred_to_by"
        case producedBy = "produced_by"
        case madeOf = "made_of"
        case subjectOf = "subject_of"
    }
}

struct IdentifiedByDTO: Decodable {
    let type: String
    let content: String?
}

struct ShowDTO: Decodable {
    let id: String
}

struct ReferencedTextDTO: Decodable {
    let content: String?
}

struct ProducedByDTO: Decodable {
    let technique: [TechniqueDTO]?
    let timespan: TimeSpanDTO?
}

struct TechniqueDTO: Decodable {
    let notation: [NotationDTO]?
}

struct MaterialDTO: Decodable {
    let notation: [NotationDTO]?
}

struct NotationDTO: Decodable {
    let languageCode: String?
    let value: String?

    enum CodingKeys: String, CodingKey {
        case languageCode = "@language"
        case value = "@value"
    }
}

struct TimeSpanDTO: Decodable {
    let beginOfTheBegin: String?

    enum CodingKeys: String, CodingKey {
        case beginOfTheBegin = "begin_of_the_begin"
    }
}

struct SubjectOfDTO: Decodable {
    let digitallyCarriedBy: [CarriedDigitalObjectDTO]?

    enum CodingKeys: String, CodingKey {
        case digitallyCarriedBy = "digitally_carried_by"
    }
}

struct CarriedDigitalObjectDTO: Decodable {
    let accessPoint: [DigitalAccessPointDTO]?

    enum CodingKeys: String, CodingKey {
        case accessPoint = "access_point"
    }
}

extension ArtworkDetailsResponseDTO {
    func toDomain() -> ArtworkDetails {
        let title = identifiedBy?
            .first(where: { $0.type == "Name" })?
            .content

        let description = referredToBy?
            .compactMap(\.content)
            .first(where: { $0.count > 40 })

        let year = producedBy?.timespan?.beginOfTheBegin.map { String($0.prefix(4)) }

        let techniques = producedBy?.technique?
            .compactMap { $0.notation?.preferredEnglishOrFirstValue }
            ?? []

        let materials = madeOf?
            .compactMap { $0.notation?.preferredEnglishOrFirstValue }
            ?? []

        let webURL = subjectOf?
            .compactMap { $0.digitallyCarriedBy?.first?.accessPoint?.first?.id }
            .compactMap(URL.init(string:))
            .first

        let visualItemURL = shows?.compactMap { URL(string: $0.id) }.first

        return ArtworkDetails(
            title: title,
            description: description,
            year: year,
            techniques: techniques,
            materials: materials,
            webURL: webURL,
            visualItemURL: visualItemURL
        )
    }
}

private extension Array where Element == NotationDTO {
    var preferredEnglishOrFirstValue: String? {
        if let englishValue = first(where: { $0.languageCode == "en" })?.value {
            return englishValue
        }

        return first?.value
    }
}
