import UIKit;

class DiscoverVC: UIViewController, UISearchResultsUpdating {

    private let searchController = UISearchController(searchResultsController: PodcastSearchResultsVC());
    private var searchResultsController: PodcastSearchResultsVC {
        searchController.searchResultsController as! PodcastSearchResultsVC
    };

    override func viewDidLoad() {
        super.viewDidLoad();
        setUpSearchController();
    }


    private func setUpSearchController() {
        searchController.searchResultsUpdater = self;
        navigationItem.searchController = searchController;
    }

    // This ensures that a request is not made unless the user
    // has paused for a brief moment
    func updateSearchResults(for searchController: UISearchController) {
        let userPauseDelaySec = 0.75;

        let text = searchController.searchBar.text;

        guard text != nil, !text!.isEmpty else {
            searchResultsController.clear();
            return;
        }

        NSObject.cancelPreviousPerformRequests(
                withTarget: self,
                selector: #selector(updateSearchResultsImpl(_:)),
                object: searchController);

        perform(#selector(updateSearchResultsImpl(_:)),
                with: searchController,
                afterDelay: userPauseDelaySec);
    }

    @objc private func updateSearchResultsImpl(_ searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return;
        }

        PodcastsModel.search(for: text) { items in
            guard let items = items else {
                self.searchResultsController.showLoadingError();
                return;
            }

            self.searchResultsController.update(podcasts: items);
        };
    }
}
