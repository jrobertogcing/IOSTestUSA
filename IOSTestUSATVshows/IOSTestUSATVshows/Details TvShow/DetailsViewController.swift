//
//  DetailsViewController.swift
//  IOSTestUSATVshows
//
//  Created by Jose González on 11/15/18.
//  Copyright © 2018 Jose González. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    
    
    // variables
    var nameR = ""
    var indexTvShow = 0
    
    var showsArrayObject = [NSManagedObject]()
    var showsArrayString = [String]()
    var favoritesArrayObject = [NSManagedObject]()
    var favoritesArrayString = [String]()
    
    @IBOutlet weak var imageTvShow: UIImageView!
    
    @IBOutlet weak var nameTvShow: UILabel!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTvShow.text = nameR
        
        readFavorites()
        readTvShows()
        
        self.tabBarController?.selectedIndex = 0


        
    }
    
    //MARK: Back Button Action
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
 
        
         let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TvShowsUITabBarController") as! TvShowsUITabBarController
            
            // self.tabBarController?.selectedIndex = 0
            // Select the favorites tab. = 1
            tabViewController.tabNumber = 1
        
            present(tabViewController, animated: true, completion: nil)
        
        
       
        
    }
    
    
    //MARK: deleteButton Action
    @IBAction func deleteButtonAction(_ sender: UIButton){
    
      let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
        // delete from favoritiesArrayString
        let favorite = self.favoritesArrayObject[indexTvShow]
        
        managedContext.delete(favorite)
        
        // dlete from objeto tvshows favoritesArrayObject
        
        for i in 0..<self.showsArrayString.count{
            
            if  self.favoritesArrayString[indexTvShow] == self.showsArrayString[i] {
                
                self.favoritesArrayString.remove(at: indexTvShow)
                self.showsArrayString.remove(at: i)
                
                let show = self.showsArrayObject[i]
                
                managedContext.delete(show)
                break
                
            }
            
        }
        do {
            try managedContext.save()
            
           // self.alertGeneral(errorDescrip: "TV Show deleted", information: "Information")
            self.alertDeleteTVshow()
            
            
            
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
            
            self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
            
        }
        
        
    }
    
    @IBAction func infoButtonAction(_ sender: UIButton) {
        
        
        
    }
    
//MARK: Read Favorites
func readFavorites()  {
    
    // delete previous information in arrays
    
    favoritesArrayObject = []
    favoritesArrayString = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TVShows")
    //request.predicate = NSPredicate(format: "age = %@", "12")
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        for data in result as! [NSManagedObject] {
            
            if let favoriteData = data.value(forKey: "favorites"){
                print(favoriteData as! String)
                favoritesArrayString.append(favoriteData as! String)
                favoritesArrayObject.append(data)
            }
        }
        
        
    } catch {
        
        print("Failed")
        self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
        
    }
    
    
}

//MARK: Read TVshows
func readTvShows()  {
    
    // delete previous information in arrays
    showsArrayObject = []
    showsArrayString = []
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TVShows")
    //request.predicate = NSPredicate(format: "age = %@", "12")
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
            
            if let tvshowData = data.value(forKey: "tvshows") {
                print(tvshowData as! String)
                showsArrayString.append(tvshowData as! String)
                showsArrayObject.append(data)
            }
        }
        
    } catch {
        
        print("Failed")
        alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
        
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

    func alertDeleteTVshow() {
        
        let alert = UIAlertController(title: "Information", message: "Tv Show was deleted.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            // go to  addVC
            let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TvShowsUITabBarController") as! TvShowsUITabBarController
            
            // self.tabBarController?.selectedIndex = 0
            // Select the favorites tab. = 1
            tabViewController.tabNumber = 1
            
            self.present(tabViewController, animated: true, completion: nil)
            
        }))
        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//
//
//        }))
//
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
}
