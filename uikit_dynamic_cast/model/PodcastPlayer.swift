//
// Created by Ayxan Haqverdili on 17.09.21.
//

import Foundation;

import AVFoundation;

import FeedKit;

class PodcastPlayer {
    private static var player: AVPlayer?;
    private(set) static var currentlyPlaying: RSSFeedItem?;

    @discardableResult
    public static func play(_ episode: RSSFeedItem) -> Bool {
        guard let url = URL(string: episode.enclosure?.attributes?.url) else {
            return false;
        }

        let player = AVPlayer(url: url);
        self.player = player;

        player.play();
        currentlyPlaying = episode;
        return true;
    }

    public static func isCurrentlyPlaying(_ episode: RSSFeedItem?) -> Bool {
        guard let episode = episode else {
            return false;
        }
        return currentlyPlaying == episode;
    }

    public static func resume() {
    }

    public static func togglePlayPause() {
        player?.play();
    }
}
