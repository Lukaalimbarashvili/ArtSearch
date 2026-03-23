# ArtSearch

## Overview
ArtSearch is a small iOS app built with Swift 6 that browses Rijksmuseum collection items using the Linked Art API. The overview screen is implemented with `UICollectionView`, and the detail screen is implemented in SwiftUI.

## Architecture And Key Decisions
- The app is split into `Presentation`, `Domain`, and `Data` layers.
- `Data` contains DTOs, repositories, endpoints, and networking code.
- `Domain` contains repository protocols, models, and use cases.
- `Presentation` contains UIKit and SwiftUI screens, view models, and routing/configuration.
- The Rijksmuseum API is not flat. Search returns lightweight references, then the app resolves detail data and image URLs through `HumanMadeObject -> VisualItem -> DigitalObject`.
- To keep that orchestration out of the view controller, the overview screen uses `LoadArtworkPreviewsUseCase`, which streams placeholder items first and then updates titles and images as they arrive.
- The detail screen uses a separate `LoadArtworkDetailsUseCase` that turns raw detail data plus the resolved image URL into a final presentation-ready model.

## Libraries Used
- [Nuke](https://github.com/kean/Nuke)
  Chosen because it provides a clean API for both `UIImageView` and SwiftUI image loading, which fit this project’s mixed UIKit/SwiftUI setup.

## Loading, Pagination, And Failures
- The overview screen shows placeholders immediately after a search page is loaded.
- As each linked resource finishes loading, visible cells update in place with title and image data.
- Pagination is driven by the API's `next.id` URL.
- Initial page failures show a centered error view with retry.

## Tests
- The project includes fixture-based tests for the API mapping chain:
  - collection search page mapping
  - artwork details mapping
  - visual item mapping
  - digital object mapping

## Time Spent
 - It is hard to give an exact number. I spent more than the suggested timebox because I also used part of the exercise to learn Swift Concurrency more deeply and to better understand the Linked Data model used by the Rijksmuseum API.

## Known Limitations And Tradeoffs
- The Rijksmuseum Linked Art API requires multiple dependent requests per item, so the app favors correctness and clear orchestration over aggressive optimization.
- Pagination error UX after the first page is minimal.
- The current test suite focuses on data mapping and not full end-to-end integration.
- The overview image/title loading strategy is intentionally scoped for the timebox rather than fully optimized with prefetching or request deduplication.

## What I Would Do Next
- Add stronger pagination failure UI and retry support for subsequent pages.
- Add shimmer placeholders for images and text to make loading states feel more polished.
- If I continued optimizing the overview screen, one likely next step would be batching visible cell updates during progressive loading. That would reduce repeated cell reconfiguration and help smooth out bursts of title/image updates.
- Add unit tests around the preview and detail use cases.
- Refine loading animations and placeholder states.
- Improve accessibility identifiers and UI test coverage.

## AI / LLM Assistance
- I used an LLM as a support tool for implementation, refactoring, naming discussions, and code review-style iteration.
