//
// Created by Ayxan Haqverdili on 17.09.21.
//

import Foundation;

import FeedKit;

public class PodcastEpisode : Codable, Equatable {

    public static func ==(lhs: PodcastEpisode, rhs: PodcastEpisode) -> Bool {
        lhs === rhs || lhs.audioUrl == rhs.audioUrl;
    }


    public let title: String;
    public let audioUrl: URL;
    public let description: String?;
    public let publishDate: Date?;
    public let duration: TimeInterval?;
    public let artworkUrl: URL?;

    private(set) var progress: TimeInterval = -1;

    init?(feedItem dataPtr: RSSFeedItem) {
        guard let title = dataPtr.title else {
            return nil;
        }
        self.title = title;

        guard let audioUrl = URL(string: dataPtr.enclosure?.attributes?.url) else {
            return nil;
        }
        self.audioUrl = audioUrl;

        description = dataPtr.description;
        publishDate = dataPtr.pubDate;
        duration = dataPtr.iTunes?.iTunesDuration;
        artworkUrl = URL(string: dataPtr.iTunes?.iTunesImage?.attributes?.href);
    }
}
