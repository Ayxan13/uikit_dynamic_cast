//
// Created by Ayxan Haqverdili on 13.09.21.
//

import Foundation

extension String {
    static func isNilOrEmpty(_ str: String?) -> Bool {
        str?.isEmpty ?? true;
    }
}