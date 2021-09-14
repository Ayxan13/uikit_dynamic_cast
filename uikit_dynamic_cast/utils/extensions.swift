//
// Created by Ayxan Haqverdili on 13.09.21.
//

import Foundation

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        self?.isEmpty ?? true;
    }
}
