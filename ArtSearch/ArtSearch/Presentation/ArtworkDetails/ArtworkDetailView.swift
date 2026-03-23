//
//  ArtworkDetailView.swift
//  ArtSearch
//
//  Created by Luka Alimbarashvili on 23.03.26.
//

import SwiftUI
import NukeUI

struct ArtworkDetailView: View {
    var viewModel: ArtworkDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                imageSection

                VStack(alignment: .leading, spacing: 12) {
                    Text(detail?.title ?? viewModel.fallbackTitle)
                        .font(.title2.weight(.semibold))

                    if let year = detail?.year {
                        infoRow(title: "Year", value: year)
                    }

                    if let description = detail?.description {
                        infoRow(title: "Description", value: description)
                    }

                    if !techniquesText.isEmpty {
                        infoRow(title: "Techniques", value: techniquesText)
                    }

                    if !materialsText.isEmpty {
                        infoRow(title: "Materials", value: materialsText)
                    }

                    if let webURL = detail?.webURL {
                        Link(destination: webURL) {
                            Text("Open Rijksmuseum Page")
                                .font(.headline)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if viewModel.isLoading {
                    HStack(spacing: 12) {
                        ProgressView()
                        Text("Loading details...")
                            .foregroundStyle(.secondary)
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
            }
            .padding(20)
        }
        .background(Color(uiColor: .systemBackground))
        .navigationTitle("Artwork Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }
    
    @ViewBuilder
    private var imageSection: some View {
        Group {
            let imageURL = detail?.imageURL
            
            LazyImage(url: imageURL) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    placeholderImage
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 320)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 72, height: 72)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var detail: ArtworkDetailData? {
        viewModel.detail
    }

    private var techniquesText: String {
        detail?.techniques.joined(separator: ", ") ?? ""
    }

    private var materialsText: String {
        detail?.materials.joined(separator: ", ") ?? ""
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}
