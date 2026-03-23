//
//  ArtSearchTests.swift
//  ArtSearchTests
//
//  Created by Luka Alimbarashvili on 23.03.26.
//

import XCTest
@testable import ArtSearch

@MainActor
final class ArtSearchTests: XCTestCase {
    
    func testMuseumCollectionPageResponseDTOMapsNextPageAndOrderedItems() throws {
        let data = try fixtureData(named: "museumCollectionPage")
        
        let dto = try JSONDecoder().decode(MuseumCollectionPageResponseDTO.self, from: data)
        let result = dto.toDomain()
        
        XCTAssertEqual(
            result.nextPageURL?.absoluteString,
            "https://data.rijksmuseum.nl/search/collection?pageToken=eyJ0b2tlbiI6ICJodHRwczovL2lkLnJpamtzbXVzZXVtLm5sLzIwMDEwNzg2MCJ9"
        )
        XCTAssertEqual(result.artworks.count, 2)
        XCTAssertEqual(result.artworks[0].id.absoluteString, "https://id.rijksmuseum.nl/200100988")
        XCTAssertEqual(result.artworks[0].type, "HumanMadeObject")
        XCTAssertEqual(result.artworks[1].id.absoluteString, "https://id.rijksmuseum.nl/200104600")
        XCTAssertEqual(result.artworks[1].type, "HumanMadeObject")
    }
    
    func testArtworkDetailsResponseDTOMapsExpectedFields() throws {
        let data = try fixtureData(named: "artworkDetails")
        
        let dto = try JSONDecoder().decode(ArtworkDetailsResponseDTO.self, from: data)
        let result = dto.toDomain()
        
        XCTAssertEqual(result.title, "Before, Behind, Between, Above, Below")
        XCTAssertEqual(result.year, "1973")
        XCTAssertEqual(result.techniques, ["etching", "aquatint", "drypoint"])
        XCTAssertEqual(result.materials, ["paper"])
        XCTAssertEqual(result.visualItemURL?.absoluteString, "https://id.rijksmuseum.nl/2021")
        XCTAssertEqual(
            result.webURL?.absoluteString,
            "https://www.rijksmuseum.nl/nl/collectie/object/RP-P-2010-222-3315--ba97e0d4396e589a312631ff4fbfd5fb"
        )
    }
    
    func testVisualItemResponseDTOMapsDigitalObjectURL() throws {
        let data = try fixtureData(named: "visualItem")
        
        let dto = try JSONDecoder().decode(VisualItemResponseDTO.self, from: data)
        let result = dto.toDomain()
        
        XCTAssertEqual(
            result.digitalObjectURL?.absoluteString,
            "https://id.rijksmuseum.nl/50012267104517610583105"
        )
    }
    
    func testDigitalObjectResponseDTOMapsImageURL() throws {
        let data = try fixtureData(named: "digitalObject")
        
        let dto = try JSONDecoder().decode(DigitalObjectResponseDTO.self, from: data)
        let result = dto.toDomain()
        
        XCTAssertEqual(
            result.imageURL?.absoluteString,
            "https://iiif.micr.io/KMFvF/full/max/0/default.jpg"
        )
    }
    
    func testMuseumCollectionPageWithNoNextPageReturnsNilURL() throws {
        let json = """
        {
          "type": "OrderedCollectionPage",
          "orderedItems": []
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))
        let result = try JSONDecoder().decode(MuseumCollectionPageResponseDTO.self, from: data).toDomain()
        
        XCTAssertNil(result.nextPageURL)
        XCTAssertEqual(result.artworks.count, 0)
    }
    
    func testArtworkDetailsWithMissingFieldsReturnsNils() throws {
        let json = """
        {
          "type": "HumanMadeObject",
          "id": "https://id.rijksmuseum.nl/1"
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))
        let result = try JSONDecoder().decode(ArtworkDetailsResponseDTO.self, from: data).toDomain()
        
        XCTAssertNil(result.title)
        XCTAssertNil(result.year)
        XCTAssertTrue(result.techniques.isEmpty)
        XCTAssertTrue(result.materials.isEmpty)
    }
}
