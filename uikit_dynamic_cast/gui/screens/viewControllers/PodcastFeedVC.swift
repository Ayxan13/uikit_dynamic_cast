//
//  PodcastFeedVC.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 13.09.21.
//

import UIKit

class PodcastFeedVC: UIViewController {
    public var podcast: ItunesPodcastItem? = nil {
        didSet {
            loadData();
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad();
    }

    private func loadData() {
        if let podcast = podcast {
            PodcastsModel.loadAllEpisodes(for: podcast) { episodes in
                guard let episodes = episodes else {
                    // TODO no episodes found implement
                    return;
                }

                for item in episodes {
                    print(item.title ?? "nil");
                }
            };
            title = podcast.collectionName;
        }
    }
}
