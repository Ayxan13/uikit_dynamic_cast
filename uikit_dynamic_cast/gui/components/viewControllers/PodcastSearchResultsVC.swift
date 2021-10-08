//
// Created by Ayxan Haqverdili on 10.09.21.
//

import UIKit;

class PodcastSearchResultsVC: UITableViewController {
    private var podcasts: [PodcastData]? = nil;
    private static let cellReuseIdentifier = "SearchResultCell";

    private var _navCtrl: UINavigationController?;

    override var navigationController: UINavigationController? {
        get {
            _navCtrl;
        }
        set {
            _navCtrl = newValue;
        }
    }

    func update(podcasts newData: [PodcastData]?) {
        podcasts = newData;
        tableView.reloadData();
    }

    func clear() {
        update(podcasts: nil);
    }

    func showLoadingError() {
        clear();
        // TODO: show connection error
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts?.count ?? 0;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PodcastSearchResultTile") ?? UITableViewCell();

        cell.textLabel?.text = podcasts?[indexPath.row].collectionName;
        cell.selectionStyle = .none;
        cell.accessoryType = .disclosureIndicator;

        return cell;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedStoryBoard = UIStoryboard(name: "PodcastFeed", bundle: nil);

        guard let vc = feedStoryBoard.instantiateViewController(withIdentifier: "podcastFeed") as? PodcastFeedVC else {
            return;
        }

        vc.set(podcastData: podcasts?[indexPath.row]);
        navigationController?.pushViewController(vc, animated: true);
    }
}
