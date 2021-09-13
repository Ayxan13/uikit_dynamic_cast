import Foundation;

// Represents one of the items itunes returns in response to a search request.
// More info: https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/UnderstandingSearchResults.html
public class ItunesPodcastItem: Codable {
    public let feedUrl: String;
    public let collectionName: String;

    public let artistName: String?;
    public let artworkUrl30: String?;
    public let artworkUrl60: String?;
    public let artworkUrl100: String?;
    public let artworkUrl600: String?;
    public let collectionId: Int?;
    public let releaseDate: String?;
    public let country: String?;
    public let genres: [String]?;
    public let trackCount: Int?;
    public let primaryGenreName: String?;


    init?(json: [String: Any]) {
        guard let feedUrl = json["feedUrl"] as? String else {
            return nil;
        }
        self.feedUrl = feedUrl;

        guard let collectionName = json["collectionName"] as? String else {
            return nil;
        }
        self.collectionName = collectionName;

        artistName  = json["artistName"] as? String;
        artworkUrl30 = json["artworkUrl30"] as? String;
        artworkUrl60 = json["artworkUrl60"] as? String;
        artworkUrl100 = json["artworkUrl100"] as? String;
        artworkUrl600 = json["artworkUrl600"] as? String;
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