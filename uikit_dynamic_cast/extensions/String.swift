//
//  String.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 13.10.21.
//

import Foundation

extension String
{
    func toAttributedHTML() -> NSAttributedString? {
        return NSAttributedString(html: self)
    }
}
