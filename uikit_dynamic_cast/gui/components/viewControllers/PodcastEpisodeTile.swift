//
//  PodcastEpisodeTile.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 13.09.21.
//

import UIKit;
import FeedKit;

class PodcastEpisodeTile: UITableViewCell {
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    private let dateFmt = { () -> DateFormatter in
        let fmt = DateFormatter();
        fmt.dateFormat = "MMM dd, yyyy";
        return fmt;
    }();
    
    private let timeFmt = DateComponentsFormatter();
    
    public var episode: PodcastEpisode? {
        didSet {
            setUIFields()
        }
    }
    
    // Sets
    private func setUIFields() {
        title.text = episode?.title;
        
        if let date = episode?.publishDate {
            publishDate.text = dateFmt.string(from: date);
        }
        
        if let duration = episode?.duration,
           let fmtStr = timeFmt.string(from: duration) {
            playButton.setTitle(fmtStr, for: .normal);
        }
    }
    
}
