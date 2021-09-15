//
//  PodcastFeedVC.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 13.09.21.
//

import UIKit;

import FeedKit;

class PodcastFeedVC: UIViewController {
    @IBOutlet weak var feedTitle: UILabel!;
    @IBOutlet weak var feedAuthor: UILabel!
    @IBOutlet weak var feedArtwork: UIImageView!
    @IBOutlet weak var tableView: UITableView!;

    public var podcast: ItunesPodcastItem? {
        didSet {
            loadData();
        }
    }
    
    private func loadData() {
        guard let podcast = podcast else {
            // TODO:
            // We are not resetting the feed to
            // an empty state when nil is set.
            // This needs to be considered.
            return;
        }

        DispatchQueue.main.async {
            self.feedTitle.text = podcast.collectionName;
            self.feedAuthor.text = podcast.artistName;
        }

        PodcastsModel.loadFeed(for: podcast) { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        }

        podcast.loadFeed { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        }

        podcast.loadImage{ img in
            DispatchQueue.main.async {
                self.feedArtwork.image = img;
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad();
    }
}

extension PodcastFeedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcast?.episodeCount ?? 0;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastEpisodeTile", for: indexPath) as! PodcastEpisodeTile;
        
        cell.episode = podcast?.get(episode: indexPath.row);
        return cell;
    }
}
