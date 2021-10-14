//
//  HomeVC.swift
//  uikit_dynamic_cast
//
//  Created by exb on 14.10.21.
//

import UIKit

class HomeVC: UIViewController {
    override func viewDidLoad() {
        let demoVC = PopupPlayerVC()
        
        demoVC.view.backgroundColor = .red
        demoVC.popupItem.title = "[title]"
        demoVC.popupItem.subtitle = "[subtitle]"
        demoVC.popupItem.progress = 0.34
            
        tabBarController?.presentPopupBar(
            withContentViewController: demoVC,
            animated: true, completion: nil
        )
    }
}
