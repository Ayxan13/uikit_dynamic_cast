import UIKit;

class DisvocerVC : UIViewController, UISearchResultsUpdating {
    
    private let searchController = UISearchController();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setUpSearchController();
    }
    
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self;
        self.navigationItem.searchController = searchController;
    }
    
    // This ensures that a reuest is not made unless the user
    // has pasued for a brief moment
    func updateSearchResults(for searchController: UISearchController) {
        let userPauseDelaySec = 0.75;
        
        guard searchController.searchBar.text != nil else { return; }
        
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(self.updateSearchResultsImpl(_:)),
            object: searchController.searchBar);
        
        perform(#selector(self.updateSearchResultsImpl(_:)),
                with: searchController.searchBar,
                afterDelay: userPauseDelaySec);
    }
    
    @objc private func updateSearchResultsImpl(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return; }

        print(text);
        PodcastsModel.search(for: text);
    }
}
