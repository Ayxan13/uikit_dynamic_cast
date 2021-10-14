//
//  EpisodeInfoVC.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 08.10.21.
//

import Foundation
import UIKit
import WebKit

public class EpisodeInfoVC: UIViewController
{
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var podcastAuthors: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var episodeDescription: UITextView!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var episode: EpisodeData? = nil
    
    @IBAction func onPlayClicked(_ sender: UIButton) {
        
        guard let episode = episode else {
            return
        }
        
        if (PodcastPlayer.isCurrentItem(episode)) {
            PodcastPlayer.togglePlayPause()
        } else {
            PodcastPlayer.play(episode)
        }

        DispatchQueue.main.async {
            self.setPlayingIcon()
        }
    }
    
    func set(podcast: PodcastData, episode: EpisodeData, artwork: UIImage?) {
        
        self.episode = episode
        
        let desc: NSAttributedString = {
            guard let desc = episode.description?.toAttributedHTML(),
                  desc.length != .zero else {
                      return NSAttributedString(string: "No Description")
                  }
            return desc
        }()
            
        
        
        let date = episode.getFormattedDate()
        
        DispatchQueue.main.async {
            self.artwork.image = artwork
            self.podcastTitle.text = podcast.collectionName
            self.podcastAuthors.text = podcast.artistName
            self.publishedDate.text = date
            self.episodeTitle.text = episode.title
            
            self.episodeDescription.attributedText = desc
            self.episodeDescription.font = UIFont.systemFont(ofSize: 16.0)
            
            self.setPlayingIcon()
        }
    }
    
    private func setPlayingIcon() {
        let isPlaying = PodcastPlayer.isCurrentItem(episode) && PodcastPlayer.isPlaying()
        
        self.playButton.setImage(
            isPlaying ? Constants.pausedImg : Constants.playImg,
            for: .normal
        )
    }
}

