//
// Created by Ayxan Haqverdili on 17.09.21.
//

import Foundation

import FeedKit

import AudioStreaming

class PodcastPlayer {
    private static var player = AudioPlayer()
    private(set) static var currentItem: EpisodeData? = nil
    private static var bottomPlayerVC: PopupPlayerVC? = nil

    public static func play(episode: EpisodeData, artwork: UIImage?, tabBarController: UITabBarController?) {
        guard episode != currentItem else {
            self.togglePlayPause()
            return
        }
        
        player.play(url: episode.audioUrl)
        self.currentItem = episode
        
        let bottomPlayer = PopupPlayerVC(title: episode.title, image: artwork)
        self.bottomPlayerVC = bottomPlayer
            
        tabBarController?.presentPopupBar(
            withContentViewController: bottomPlayer,
            animated: true, completion: nil
        )
    }

    public static func isCurrentItem(_ episode: EpisodeData?) -> Bool {
        guard let episode = episode else {
            return false
        }

        return currentItem == episode
    }

    private static func resume() {
        player.resume()
    }

    private static func togglePlayPause() {
        if (isPlaying()) {
            player.pause()
        } else {
            player.resume()
        }
    }

    public static func isPlaying() -> Bool {
        switch (player.state) {
        case .running, .playing, .bufferring:
            return true
        default:
            return false
        }
    }
}


