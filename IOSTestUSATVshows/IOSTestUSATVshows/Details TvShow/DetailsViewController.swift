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
    var imageURL = ""
    var summary = ""
    
    var showsArrayObject = [NSManagedObject]()
    var showsArrayString = [String]()
    var favoritesArrayObject = [NSManagedObject]()
    var favoritesArrayString = [String]()
    
    // ARRAY from JSON
    var imageArrayURL = [String]()
    var imageArrayURLObject = [NSManagedObject]()
    var summaryArrayURL = [String]()
    var summaryArrayURLObject = [NSManagedObject]()
    
    var imageDataArrayURL = [Data]()
    var imageDataArrayURLObject = [NSManagedObject]()

    
    
    @IBOutlet weak var imageTvShow: UIImageView!
    
    @IBOutlet weak var nameTvShow: UILabel!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTvShow.text = nameR
        
        readFavorites()
        
        self.tabBarController?.selectedIndex = 0

        let summarySinP = String(summary.dropFirst(3))
        let summarySinPB = String(summarySinP.dropLast(4))
        
       // summarySinPB.replacingOccurrences(of: "\", with: "")
        
           let resultStringOne  = summarySinPB.replacingOccurrences(of: "<b>", with: " - ")
        let resultSringF = resultStringOne.replacingOccurrences(of: "</b>", with: " - ")
            
        detailsTextView.text = resultSringF
        
        self.imageTvShow.image = UIImage(data: imageDataArrayURL[indexTvShow])

        
        
//        // for image async
//
//        let urlString = imageURL
//        print(urlString)
//        let urlStringNoHTTP = String(urlString.dropFirst(4))
//
//        let urlStringHTTPS = "https\(urlStringNoHTTP)"
//
//        let imgURL: URL = URL(string: urlStringHTTPS)!
//        let request: URLRequest = URLRequest(url: imgURL)
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request, completionHandler: {
//            (data, response, error) -> Void in
//
//            if (error == nil && data != nil)
//            {
//                func display_image()
//                {
//
//
//
//                   // favoritesCell.imageCell.image = UIImage(data: data!)
//
//                    self.imageTvShow.image = UIImage(data: data!)
//                }
//
//
//                DispatchQueue.main.async(execute: display_image)
//            }
//
//        })
//
//        task.resume()

        
        

        
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
        // dlete from objeto tvshows favoritesArrayObject
        
        let favorite = self.favoritesArrayObject[indexTvShow]
        
        managedContext.delete(favorite)
        
        let image = self.imageArrayURLObject[indexTvShow]
        
        managedContext.delete(image)
        
        let summary = self.summaryArrayURLObject[indexTvShow]
        
        managedContext.delete(summary)
        
        let imageData = self.imageDataArrayURLObject[indexTvShow]
        
        managedContext.delete(imageData)
            
        
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
        
        let settingsUrl = NSURL(string : "https://www.tvmaze.com/")! as URL
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        
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
            
            if let imageData = data.value(forKey: "image"){
                //print(favoriteData as! String)
                imageArrayURL.append(imageData as! String)
                imageArrayURLObject.append(data)
            }
            
            if let summaryData = data.value(forKey: "summary"){
                //print(favoriteData as! String)
                summaryArrayURL.append(summaryData as! String)
                summaryArrayURLObject.append(data)
            }
            
            if let imageDataCD = data.value(forKey: "imageData"){
                //print(favoriteData as! String)
                imageDataArrayURL.append(imageDataCD as! Data)
                imageDataArrayURLObject.append(data)
            }
            
        }
        
        
    } catch {
        
        print("Failed")
        self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
        
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
        

        present(alert, animated: true, completion: nil)
        
        
    }
    
    
}
