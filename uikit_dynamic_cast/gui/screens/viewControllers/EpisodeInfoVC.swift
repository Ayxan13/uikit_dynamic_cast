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
    
    func set(podcast: PodcastData, episode: EpisodeData, artwork: UIImage?) {
        
        let desc = episode.description?.toAttributedHTML()
        let date = episode.getFormattedDate()
        
        DispatchQueue.main.async {
            self.artwork.image = artwork
            self.podcastTitle.text = podcast.collectionName
            self.podcastAuthors.text = podcast.artistName
            self.publishedDate.text = date
            self.episodeTitle.text = episode.title
            
            self.episodeDescription.attributedText = desc
            self.episodeDescription.font = UIFont.systemFont(ofSize: 16.0)
        }
    }
}

