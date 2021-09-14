//
//  PodcastFeedVC.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 13.09.21.
//

import UIKit;

import FeedKit;

class PodcastFeedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!;
    @IBOutlet weak var feedTitle: UILabel!

    private var episodes: [RSSFeedItem]?;

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
            PodcastsModel.loadAllEpisodes(for: podcast) {
                self.episodes = $0;
                DispatchQueue.main.async {
                    self.feedTitle.text = podcast.collectionName;
                    self.tableView.reloadData();
                }
            };
        }
    }
}

extension PodcastFeedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes?.count ?? 0;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastEpisodeTile", for: indexPath) as! PodcastEpisodeTile;
        
        cell.episode = episodes![indexPath.row];
        return cell;
    }
}
