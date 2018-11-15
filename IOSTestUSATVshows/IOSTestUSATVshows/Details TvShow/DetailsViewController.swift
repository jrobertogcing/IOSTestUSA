//
//  DetailsViewController.swift
//  IOSTestUSATVshows
//
//  Created by Jose González on 11/15/18.
//  Copyright © 2018 Jose González. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    // variables
    var nameR = ""
    
    
    @IBOutlet weak var nameTvShow: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTvShow.text = nameR
    }
    

   

}
