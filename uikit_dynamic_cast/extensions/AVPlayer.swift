//
//  AVPlayer.swift
//  uikit_dynamic_cast
//
//  Created by exb on 14.10.21.
//

import Foundation
import AVFoundation;

extension AVPlayer {
    var isPlaying: Bool {
        rate != 0 && error == nil
    }
}
