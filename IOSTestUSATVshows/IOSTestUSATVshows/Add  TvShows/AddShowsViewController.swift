//
//  AddShowsViewController.swift
//  IOSTestUSATVshows
//
//  Created by Jose González on 11/15/18.
//  Copyright © 2018 Jose González. All rights reserved.
//

import UIKit
import CoreData


class AddShowsViewController: UIViewController {

    
    @IBOutlet weak var nameShowTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameShowTextField.setBottomBorderEnabled()

        
        
    }
    
    func saveTvShow(tvShow: String) -> Bool  {
        
        var result = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TVShows", in: context)
        let newTvShow = NSManagedObject(entity: entity!, insertInto: context)
        
        newTvShow.setValue(tvShow, forKey: "tvshows")
        
        do {
            try context.save()
            result = true
        } catch {
            print("Failed saving")
            self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
            
            result  = false
        }
        
        return result
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        
        
        // check if text field have information
        if nameShowTextField.text != "" {
            
            // save in core data
            
            saveTvShow(tvShow: nameShowTextField.text!)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
            
            self.present(nextViewController, animated:true, completion:nil)
            
            
        } else {
            
            
            alertGeneral(errorDescrip: "Type the TVShow first", information: "Information" )
        }
    }
    
    //MARK : alertGeneral
    
    func alertGeneral(errorDescrip:String, information: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
    }
    
    

    

}

extension UITextField {
    func setBottomBorderDisabled() {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 2.0
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = UIColor.purple
        self.addSubview(borderLine)
    }
    func setBottomBorderEnabled() {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 2.0
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = UIColor.black
        self.addSubview(borderLine)
    }
    
}

