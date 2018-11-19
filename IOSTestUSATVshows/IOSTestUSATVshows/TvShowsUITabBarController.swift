//
//  TvShowsUITabBarController.swift
//  IOSTestUSATVshows
//
//  Created by Jose González on 11/19/18.
//  Copyright © 2018 Jose González. All rights reserved.
//

import UIKit

class TvShowsUITabBarController: UITabBarController {

    var tabNumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedIndex = tabNumber;
    }
    

  
}
