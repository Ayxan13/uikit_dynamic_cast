//
//  PodcastFeedVC.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 13.09.21.
//

import UIKit

import FeedKit

class PodcastFeedVC: UIViewController {
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedAuthor: UILabel!
    @IBOutlet weak var feedArtwork: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    private weak var currentlyPlayingButton: UIButton?
    
    private var podcastData: PodcastData? = nil;

    private var items: [EpisodeData]? = nil

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func set(podcastData: PodcastData?) {
        guard let podcastData = podcastData else {
            return
        }
        
        self.podcastData = podcastData

        Task.init {
            await loadPodcastData()
        }
    }

    private func loadPodcastData() async {
        guard let podcast = self.podcastData else {
            return
        }
        
        async let cacheFuture = CachedPoscastsTable.shared.getCache(for: podcast)
        
        DispatchQueue.main.async {
            self.feedTitle.text = podcast.collectionName
            self.feedAuthor.text = podcast.artistName
            self.tableView.tableHeaderView?.sizeToFit()
        }
        
        let cache = await cacheFuture
        
        DispatchQueue.main.async {
            self.feedArtwork.image ?= cache.artwork
            self.items ?= cache.items
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension PodcastFeedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastEpisodeTile", for: indexPath) as! PodcastEpisodeTile

        cell.episode = items?[indexPath.row]
        cell.playButton.tag = indexPath.row
        
        if let episode = cell.episode {
            setButtonIcon(cell.playButton, with: episode)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard = UIStoryboard(name: "EpisodeInfo", bundle: nil);

        guard let vc = storyBoard.instantiateViewController(withIdentifier: "episodeInfoVC") as? EpisodeInfoVC else {
            return;
        }
        
        vc.set(
            podcast: self.podcastData!,
            episode: self.items![indexPath.row],
            artwork: self.feedArtwork.image
        )
        
        navigationController?.pushViewController(vc, animated: true);
    }
}

// Play pause functionality
extension PodcastFeedVC {
    @IBAction func onPlayButtonClick(_ sender: UIButton) {
        guard let episode = items?[sender.tag] else {
            return
        }

        if (PodcastPlayer.isCurrentItem(episode)) {
            PodcastPlayer.togglePlayPause()
        } else {
            PodcastPlayer.play(episode)
        }

        setButtonIcon(sender, with: episode)
    }
    
    
    func setButtonIcon(_ button: UIButton, with episode: EpisodeData) {
        let isPlaying = (PodcastPlayer.isCurrentItem(episode) && PodcastPlayer.isPlaying())
        
        if isPlaying {
            currentlyPlayingButton?.setImage(Constants.playImg, for: .normal)
            currentlyPlayingButton = button
            button.setImage(Constants.pausedImg, for: .normal)
        } else {
            button.setImage(Constants.playImg, for: .normal)
        }
    }
}


