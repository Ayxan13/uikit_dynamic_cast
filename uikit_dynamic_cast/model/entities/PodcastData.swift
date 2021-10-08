//
// Created by Ayxan Haqverdili on 01.10.21.
//

import Foundation
import FeedKit

// Represents one of the items itunes returns in response to a search request.
// More info: https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/UnderstandingSearchResults.html
struct PodcastData: Codable, Identifiable {
    let feedUrl: URL
    let collectionName: String
    let artistName: String?
    let artworkUrl30: URL?
    let artworkUrl60: URL?
    let artworkUrl100: URL?
    let artworkUrl600: URL?
    let collectionId: Int?
    let releaseDate: String?
    let country: String?
    let genres: [String]?
    let trackCount: Int?
    let primaryGenreName: String?

    public var artworkUrl: URL? { artworkUrl600 ?? artworkUrl100 ?? artworkUrl60 ?? artworkUrl30 }
    public var id: URL { feedUrl }
}

// RSS & JSON
extension PodcastData {
    init?(json: [String: Any]) {
        guard let feedUrl = URL(string: json["feedUrl"] as? String) else {
            return nil
        }

        self.feedUrl = feedUrl

        guard let collectionName = json["collectionName"] as? String else {
            return nil
        }

        self.collectionName = collectionName

        artistName = json["artistName"] as? String
        artworkUrl30 = URL(string: json["artworkUrl30"] as? String)
        artworkUrl60 = URL(string: json["artworkUrl60"] as? String)
        artworkUrl100 = URL(string: json["artworkUrl100"] as? String)
        artworkUrl600 = URL(string: json["artworkUrl600"] as? String)
        collectionId = json["collectionId"] as? Int
        releaseDate = json["releaseDate"] as? String
        country = json["country"] as? String
        genres = json["genres"] as? [String]
        trackCount = json["trackCount"] as? Int
        primaryGenreName = json["primaryGenreName"] as? String
    }

    public static func fromItunesResponse(_ data: Data) -> [PodcastData]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let results = json["results"] as? [[String: Any]] else {
            return nil
        }

        var items = [PodcastData]()
        items.reserveCapacity(results.count)

        for case let result in results {
            if let item = PodcastData(json: result) {
                items.append(item)
            }
        }
        return items
    }
}

// Networking
extension PodcastData {
    func loadFeed() async -> [EpisodeData]? {
        return await PodcastData.loadFeed(from: self.feedUrl)
    }

    func loadArtwork() async -> UIImage? {
        guard let url = self.artworkUrl else { return nil }
        return await PodcastData.loadImage(from: url)
    }
    
    private static func loadImage(from url: URL) async -> UIImage? {
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            return nil
        }

        return UIImage(data: data)
    }
    
    private static func loadFeed(from url: URL) async -> [EpisodeData]? {
        typealias PostContinuation = CheckedContinuation<RSSFeed?, Error>

        guard let items = (
                try? await withCheckedThrowingContinuation { (continuation: PostContinuation) in
                    switch FeedParser(URL: url).parse() {
                    case .success(let feed):
                        continuation.resume(returning: feed.rssFeed)
                    case .failure:
                        continuation.resume(returning: nil)
                    }
                }
        )?.items else { return nil }

        var data: [EpisodeData] = []
        data.reserveCapacity(items.count)

        for item in items {
            if let episodeData = EpisodeData(podcastURL: url, feedItem: item) {
                data.append(episodeData)
            }
        }
        return data
    }
}
