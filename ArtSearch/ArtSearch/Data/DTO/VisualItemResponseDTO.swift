import Foundation

struct VisualItemResponseDTO: Decodable {
    let digitally_shown_by: [DigitalObjectReferenceDTO]?
}

struct DigitalObjectReferenceDTO: Decodable {
    let id: String
}

extension VisualItemResponseDTO {
    var digitalObjectURL: URL? {
        digitally_shown_by?
            .compactMap(\.id)
            .compactMap(URL.init(string:))
            .first
    }
}
