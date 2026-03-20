import Foundation

struct DigitalObjectResponseDTO: Decodable {
    let access_point: [DigitalAccessPointDTO]?
}

struct DigitalAccessPointDTO: Decodable {
    let id: String
}

extension DigitalObjectResponseDTO {
    var imageURL: URL? {
        access_point?
            .compactMap(\.id)
            .compactMap(URL.init(string:))
            .first
    }
}
