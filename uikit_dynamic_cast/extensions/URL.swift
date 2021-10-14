//
//  URL.swift
//  uikit_dynamic_cast
//
//  Created by exb on 14.10.21.
//

import Foundation


extension URL {
    init?(string url: String?) {
        guard let url = url else {
            return nil;
        }
        self.init(string: url);
    }
}
