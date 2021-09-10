//
//  SearchResultTile.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 10.09.21.
//

import UIKit

class SearchResultTile: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    func set(podcast item: ItunesPodcastItem) {
        label.text = item.collectionName;
    }
}
