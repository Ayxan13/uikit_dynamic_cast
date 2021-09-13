//
// Created by Ayxan Haqverdili on 10.09.21.
//

import UIKit.UIViewController;

public class PodcastSearchResultsVC: UITableViewController {
    private var podcasts: [ItunesPodcastItem]? = nil;
    private static let cellReuseIdentifier = "SearchResultCell";

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
        return podcasts?.count ?? 0;
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell();

        cell.textLabel?.text = podcasts?[indexPath.row].collectionName;

        return cell
    }
}
