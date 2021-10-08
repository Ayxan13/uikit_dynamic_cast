//
// Created by Ayxan Haqverdili on 17.09.21.
//

import Foundation;

import FeedKit;

import AudioStreaming;

class PodcastPlayer {
    private static var player = AudioPlayer();
    private(set) static var currentItem: EpisodeData?;

    @discardableResult
    public static func play(_ episode: EpisodeData) -> Bool {
        player.play(url: episode.audioUrl);
        currentItem = episode;
        return true;
    }

    public static func isCurrentItem(_ episode: EpisodeData?) -> Bool {
        guard let episode = episode else {
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

    public static func isPlaying() -> Bool {
        switch (player.state) {
        case .running, .playing, .bufferring:
            return true;
        default:
            return false;
        }
    }
}


