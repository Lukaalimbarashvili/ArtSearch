//
//  VisualItemRepositoryProtocol.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 20.03.26.
//

import Foundation

protocol VisualItemRepositoryProtocol {
    func fetchVisualItem(id: URL) async throws -> VisualItem
}
