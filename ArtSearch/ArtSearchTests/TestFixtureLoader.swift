//
//  TestFixtureLoader.swift
//  ArtSearchTests
//
//  Created by Luka Alimbarashvili on 23.03.26.
//

import Foundation
import XCTest

func fixtureData(named name: String) throws -> Data {
    let bundle = Bundle(for: ArtSearchTests.self)
    let url = try XCTUnwrap(
        bundle.url(forResource: name, withExtension: "json"),
        "Missing fixture: \(name).json",
    )

    return try Data(contentsOf: url)
}
