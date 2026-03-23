//
//  ArtworkDetailsRepositoryProtocol.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 20.03.26.
//

import Foundation

protocol DigitalObjectRepositoryProtocol {
    func fetchDigitalObject(id: URL) async throws -> DigitalObject
}
