//
//  PodcastEpisodeTile.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 13.09.21.
//

import UIKit;
import FeedKit;

class PodcastEpisodeTile: UITableViewCell {
    public var episode: RSSFeedItem? {
        didSet {
            title.text = episode?.title;
        }
    }

    @IBOutlet weak var title: UILabel!;
}
