//
//  PopupPlayerVC.swift
//  uikit_dynamic_cast
//
//  Created by exb on 14.10.21.
//

import UIKit
import LNPopupController

class PopupPlayerVC: LNPopupCustomBarViewController {
    convenience init(title: String, image: UIImage?) {
        self.init()
        self.popupItem.title = title
        self.popupItem.image = image
        self.popupItem.progress = .zero
    }
}
