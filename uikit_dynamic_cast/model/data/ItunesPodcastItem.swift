import Foundation;

import UIKit;

import FeedKit;

// Represents one of the items itunes returns in response to a search request.
// More info: https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/UnderstandingSearchResults.html
public class ItunesPodcastItem {
    public let feedUrl: URL;
    public let collectionName: String;

    public let artistName: String?;
    public let artworkUrl30: URL?;
    public let artworkUrl60: URL?;
    public let artworkUrl100: URL?;
    public let artworkUrl600: URL?;
    public let collectionId: Int?;
    public let releaseDate: String?;
    public let country: String?;
    public let genres: [String]?;
    public let trackCount: Int?;
    public let primaryGenreName: String?;

    public var highResArtworkUrl: URL? {
        artworkUrl600 ?? artworkUrl100 ?? artworkUrl60 ?? artworkUrl30;
    };

    public var artwork: UIImage?;
    public var feed: RSSFeed?;

    public func loadImage(then onComplete: @escaping (UIImage?) -> Void) {
        if let artwork = artwork {
            onComplete(artwork);
            return;
        }

        guard let url = highResArtworkUrl else {
            onComplete(nil);
            return;
        }

        PodcastsModel.loadImage(url: url) { img in
            self.artwork = img;
            onComplete(img);
        }
    }

    public func loadFeed(then onComplete: @escaping (RSSFeed?) -> Void) {
        if let feed = feed {
            onComplete(feed);
            return;
        }

        PodcastsModel.loadFeed(for: self) { feed in
            self.feed = feed;
            onComplete(feed);
        }
    }

    public func get(episode index: Int) -> RSSFeedItem? {
        feed?.items?[index];
    }

    public var episodeCount: Int {
        feed?.items?.count ?? 0;
    }

    init?(json: [String: Any]) {
        let url = { (str: String?) -> URL? in
            guard let str = str else {
                return nil;
            }
            return URL(string: str);
        };

        guard let feedUrl = url(json["feedUrl"] as? String) else {
            return nil;
        }

        self.feedUrl = feedUrl;

        guard let collectionName = json["collectionName"] as? String else {
            return nil;
        }

        self.collectionName = collectionName;

        artistName = json["artistName"] as? String;
        artworkUrl30 = url(json["artworkUrl30"] as? String);
        artworkUrl60 = url(json["artworkUrl60"] as? String);
        artworkUrl100 = url(json["artworkUrl100"] as? String);
        artworkUrl600 = url(json["artworkUrl600"] as? String);
        collectionId = json["collectionId"] as? Int;
        releaseDate = json["releaseDate"] as? String;
        country = json["country"] as? String;
        genres = json["genres"] as? [String];
        trackCount = json["trackCount"] as? Int;
        primaryGenreName = json["primaryGenreName"] as? String;
    }

    public static func fromItunesResponse(_ data: Data) -> [ItunesPodcastItem]? {

        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let results = json["results"] as? [[String: Any]] else {
            return nil;
        }

        var items = [ItunesPodcastItem]();
        items.reserveCapacity(results.count);

        for case let result in results {
            if let item = ItunesPodcastItem(json: result) {
                items.append(item);
            }
        }
        return items;
    }

}