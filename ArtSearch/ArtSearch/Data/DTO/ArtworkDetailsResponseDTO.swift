import Foundation

struct ArtworkDetailsResponseDTO: Decodable {
    let identified_by: [IdentifiedByDTO]?
    let shows: [ShowDTO]?
}

struct IdentifiedByDTO: Decodable {
    let type: String
    let content: String?
}

struct ShowDTO: Decodable {
    let id: String
}

extension ArtworkDetailsResponseDTO {
    var title: String? {
        identified_by?
            .first(where: { $0.type == "Name" })?
            .content
    }

    var visualItemURL: URL? {
        shows?
            .compactMap(\.id)
            .compactMap(URL.init(string:))
            .first
    }
}
