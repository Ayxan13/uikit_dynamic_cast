//
// Created by Ayxan Haqverdili on 17.09.21.
//

import Foundation

import FeedKit

import AudioStreaming

class PodcastPlayer: ObservableObject
{
    private static let shared = PodcastPlayer()
    private var player = AudioPlayer()
    @Published private var focusedEpisode: EpisodeData? = nil
    private var bottomPlayerVC: PopupPlayerVC? = nil
    
    public func play(episode: EpisodeData, artwork: UIImage?, tabBarController: UITabBarController?) {
        guard episode != focusedEpisode else {
            self.togglePlayPause()
            return
        }
        
        player.play(url: episode.audioUrl)
        self.focusedEpisode = episode
        
        let bottomPlayer = PopupPlayerVC(title: episode.title, image: artwork)
        self.bottomPlayerVC = bottomPlayer
            
        tabBarController?.presentPopupBar(
            withContentViewController: bottomPlayer,
            animated: true, completion: nil
        )
    }

    public func isCurrentItem(_ episode: EpisodeData?) -> Bool {
        guard let episode = episode else {
            return false
        }

        return focusedEpisode == episode
    }
    
    public func itemIsPlaying(_ episode: EpisodeData?) -> Bool {
        guard let episode = episode else {
            return false
        }
        
        return focusedEpisode == episode && isPlaying()
    }

    private func resume() {
        player.resume()
    }

    private func togglePlayPause() {
        if (isPlaying()) {
            player.pause()
        } else {
            player.resume()
        }
    }

    public func isPlaying() -> Bool {
        switch (player.state) {
        case .running, .playing, .bufferring:
            return true
        default:
            return false
        }
    }
}


