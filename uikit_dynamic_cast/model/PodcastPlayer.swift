//
// Created by Ayxan Haqverdili on 17.09.21.
//

import Foundation;
import AVFoundation;
import FeedKit;

class PodcastPlayer {
    private var player: AVPlayer?;

    @discardableResult
    public func play(_ episode: RSSFeedItem) -> Bool {
        guard let url = URL(string: episode.enclosure?.attributes?.url) else {
            return false;
        }

        let player = AVPlayer(url: url);
        self.player = player;

        player.play();
        return true;
    }

    public func resume() {

    }

    public func stop() {

    }
}
