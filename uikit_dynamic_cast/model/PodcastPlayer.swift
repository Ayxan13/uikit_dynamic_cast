//
// Created by Ayxan Haqverdili on 17.09.21.
//

import Foundation;

import FeedKit;

import AudioStreaming;

class PodcastPlayer {
    private static var player = AudioPlayer();
    private(set) static var currentItem: RSSFeedItem?;

    @discardableResult
    public static func play(_ episode: RSSFeedItem) -> Bool {
        guard let url = URL(string: episode.enclosure?.attributes?.url) else {
            return false;
        }

        player.play(url: url);
        currentItem = episode;
        return true;
    }

    public static func isCurrentlyPlaying(_ episode: RSSFeedItem?) -> Bool {
        guard let episode = episode else {
            return false;
        }

        if (!isPlaying()) {
            return false;
        }

        return currentItem == episode;
    }

    public static func resume() {
        player.resume();
    }

    public static func togglePlayPause() {
        if (isPlaying()) {
            player.pause();
        } else {
            player.resume();
        }
    }

    private static func isPlaying() -> Bool {
        switch (player.state) {
        case .running, .playing, .bufferring:
            return true;
        default:
            return false;
        }
    }
}

