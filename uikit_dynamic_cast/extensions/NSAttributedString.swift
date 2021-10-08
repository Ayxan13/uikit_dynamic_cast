//
//  NSAttributedString.swift
//  uikit_dynamic_cast
//
//  Created Ayxan Haqverdili on 08.10.21.
//

import Foundation

extension NSAttributedString {
    
    // create attributed string from a regular string with HTML tags
    internal convenience init?(html: String) {
        guard let data = html.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }

        guard let attributedString = try? NSMutableAttributedString(
                      data: data,
                      options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                      documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString: attributedString)
    }
}
