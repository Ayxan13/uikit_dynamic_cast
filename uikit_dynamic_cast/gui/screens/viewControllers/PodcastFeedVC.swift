//
//  PodcastFeedVC.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 13.09.21.
//

import UIKit

class PodcastFeedVC: UIViewController {

    public var podcast: ItunesPodcastItem? = nil;

    @IBOutlet weak var label: UILabel!;

    override func viewDidLoad() {
        super.viewDidLoad();
        label.text = podcast?.collectionName;
    }
}
