//
//  EpisodeInfoVC.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 08.10.21.
//

import Foundation
import UIKit
import WebKit

public class EpisodeInfoVC: UIViewController
{
    @IBOutlet weak var info: UITextView!
    
    func set(info str: String) {
        let html = NSAttributedString(html: str);
        
        DispatchQueue.main.async { self.info.attributedText = html }
    }
}

