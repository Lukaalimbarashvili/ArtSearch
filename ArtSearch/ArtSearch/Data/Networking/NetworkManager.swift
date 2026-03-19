//
//  NetworkManager.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

protocol NetworkManaging {
    func request<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T
}

final class NetworkManager: NetworkManaging {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T {
        let (data, response) = try await session.data(for: request)

        try validate(response)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200 ..< 300 ~= httpResponse.statusCode else {
            throw NetworkError.httpStatusCode(httpResponse.statusCode)
        }
    }
}
