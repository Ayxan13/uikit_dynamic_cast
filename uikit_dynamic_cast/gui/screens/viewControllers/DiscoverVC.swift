import UIKit;

class DiscoverVC: UIViewController, UISearchResultsUpdating {
    
    private let searchController = UISearchController(
            searchResultsController: UIStoryboard(name: "PodcastSearchResults", bundle: nil)
                            .instantiateViewController(withIdentifier: "PodcastSearchResultsVC") as? PodcastSearchResultsVC);
    
    private func refreshSearchData(_ items: [ItunesPodcastItem]?) {
        DispatchQueue.main.async {
            self.searchResultsController.update(podcasts: items);
        }
    }

    private var searchResultsController: PodcastSearchResultsVC {
        assert(Thread.isMainThread);
        return searchController.searchResultsController as! PodcastSearchResultsVC
    };

    override func viewDidLoad() {
        super.viewDidLoad();
        setUpSearchController();
    }

    private func setUpSearchController() {
        searchController.searchResultsUpdater = self;
        navigationItem.searchController = searchController;
        searchController.searchBar.placeholder = "Search for podcasts";
        searchResultsController.navigationController = navigationController;
    }

    // This ensures that a request is not made unless the user
    // has paused for a brief moment
    func updateSearchResults(for searchController: UISearchController) {
        let userPauseDelaySec = 0.75;

        guard !(searchController.searchBar.text.isNilOrEmpty) else {
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

        PodcastsNetworkModel.search(for: text, then: refreshSearchData);
    }
}
