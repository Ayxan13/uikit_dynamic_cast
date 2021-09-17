//
// Created by Ayxan Haqverdili on 13.09.21.
//

import Foundation;
import FeedKit;
import AVFoundation;

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        self?.isEmpty ?? true;
    }
}

extension URL {
    init?(string url: String?) {
        guard let url = url else {
            return nil;
        }
        self.init(string: url);
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        rate != 0 && error == nil
    }
}