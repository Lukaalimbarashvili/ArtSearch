//
//  NetworkError.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatusCode(Int)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case let .httpStatusCode(statusCode):
            return "The server returned an unexpected status code: \(statusCode)."
        case let .decodingFailed(error):
            return "Failed to decode the response: \(error.localizedDescription)"
        }
    }
}
