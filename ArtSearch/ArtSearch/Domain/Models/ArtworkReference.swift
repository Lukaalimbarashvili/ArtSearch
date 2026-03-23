//
//  ArtworkReference.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 20.03.26.
//

import Foundation

struct ArtworkReference {
    let id: URL
    let type: String
}

struct ArtworkItemViewData {
    let id: URL
    let type: String
    var title: String?
    var imageURL: URL?
    var titleFailed: Bool
    var imageFailed: Bool
}

struct ArtworkDetails {
    let title: String?
    let visualItemURL: URL?
}

struct VisualItem {
    let digitalObjectURL: URL?
}

struct DigitalObject {
    let imageURL: URL?
}
