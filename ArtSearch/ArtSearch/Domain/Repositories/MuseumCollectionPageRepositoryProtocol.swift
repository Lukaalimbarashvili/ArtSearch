//
//  CollectionPageRepositoryProtocol.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 19.03.26.
//

import Foundation

protocol MuseumCollectionPageRepositoryProtocol {
    func fetchMuseumCollectionPage(nextPageURL: URL?) async throws -> MuseumCollectionPage
}
