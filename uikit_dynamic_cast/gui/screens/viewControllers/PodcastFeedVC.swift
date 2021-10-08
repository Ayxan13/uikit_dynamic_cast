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

    private var items: [EpisodeData]? = nil {
        didSet {
            self.tableView.reloadData()
        }
    }

    func set(podcastData: PodcastData?) {
        guard let podcastData = podcastData else {
            return
        }

        Task.init {
            await load(podcastData: podcastData)
        }
    }

    private func load(podcastData podcast: PodcastData) async {
        DispatchQueue.main.async {
            self.feedTitle.text = podcast.collectionName
            self.feedAuthor.text = podcast.artistName
            self.tableView.tableHeaderView?.sizeToFit()
        }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                guard let items = await podcast.loadFeed() else { return }
                DispatchQueue.main.async { self.items ?= items }
            }
            
            group.addTask {
                guard let img = await podcast.loadArtwork() else { return }
                DispatchQueue.main.async { self.feedArtwork.image ?= img }
            }
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
        cell.playButton.setImage(PodcastFeedVC.getPlayIcon(episode: cell.episode), for: .normal)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard = UIStoryboard(name: "EpisodeInfo", bundle: nil);

        guard let vc = storyBoard.instantiateViewController(withIdentifier: "episodeInfoVC") as? EpisodeInfoVC else {
            return;
        }
        
        vc.set(info: self.items?[indexPath.row].description ?? "no info")
        navigationController?.pushViewController(vc, animated: true);
        
        print("Clicked \(indexPath.row)")
    }
}

// Play pause functionality
extension PodcastFeedVC {
    private static func getPlayIcon(episode: EpisodeData?) -> UIImage {
        let currentlyPlaying = PodcastPlayer.isCurrentItem(episode) && PodcastPlayer.isPlaying()
        return UIImage(systemName: currentlyPlaying ? "pause.circle" : "play.circle")!
    }

    @IBAction func onPlayButtonClick(_ sender: UIButton) {
        guard let episode = items?[sender.tag] else {
            return
        }

        if (PodcastPlayer.isCurrentItem(episode)) {
            PodcastPlayer.togglePlayPause()
        } else {
            PodcastPlayer.play(episode)
        }

        currentlyPlayingButton?.setImage(PodcastFeedVC.getPlayIcon(episode: nil), for: .normal)

        sender.setImage(PodcastFeedVC.getPlayIcon(episode: episode), for: .normal)
        currentlyPlayingButton = sender
    }
}


