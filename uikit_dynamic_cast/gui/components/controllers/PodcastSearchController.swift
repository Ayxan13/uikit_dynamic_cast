//
// Created by Ayxan Haqverdili on 10.09.21.
//

import UIKit;

class PodcastSearchController : UISearchController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        searchResultsController?.viewDidDisappear(animated);
    }
}