//
//  RijksmuseumEndpoint.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 20.03.26.
//

import Foundation

enum RijksmuseumEndpoint {
    static func searchRequest(nextPageURL: URL?) throws -> URLRequest {
        if let nextPageURL {
            return URLRequest(url: nextPageURL)
        }

        guard let url = URL(string: "https://data.rijksmuseum.nl/search/collection") else {
            throw NetworkError.invalidURL
        }

        return URLRequest(url: url)
    }
}
