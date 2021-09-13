//
// Created by Ayxan Haqverdili on 10.09.21.
//

import UIKit;

public class PodcastSearchResultsVC: UITableViewController {
    private var podcasts: [ItunesPodcastItem]? = nil;
    private static let cellReuseIdentifier = "SearchResultCell";

    private var _navCtrl: UINavigationController?;

    public override var navigationController: UINavigationController? {
        get {
            _navCtrl;
        }
        set {
            _navCtrl = newValue;
        }
    }

    public func update(podcasts newData: [ItunesPodcastItem]?) {
        podcasts = newData;
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }

    public func clear() {
        update(podcasts: nil);
    }

    public func showLoadingError() {
        clear();
        // TODO: show connection error
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts?.count ?? 0;
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(
                withIdentifier: "PodcastSearchResultTile", for: indexPath
        ) as! PodcastSearchResultTile;

        cell.textLabel?.text = podcasts?[indexPath.row].collectionName;

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedStoryBoard = UIStoryboard(name: "PodcastFeed", bundle: nil);

        guard let vc = feedStoryBoard.instantiateViewController(withIdentifier: "podcastFeed") as? PodcastFeedVC else {
            return;
        }

        vc.podcast = podcasts?[indexPath.row];
        navigationController?.pushViewController(vc, animated: true);
    }
}
