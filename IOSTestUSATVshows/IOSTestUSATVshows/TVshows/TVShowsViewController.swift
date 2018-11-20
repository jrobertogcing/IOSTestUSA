//
//  TVShowsViewController.swift
//  IOSTestUSATVshows
//
//  Created by Jose González on 11/15/18.
//  Copyright © 2018 Jose González. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

class TVShowsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    @IBOutlet weak var tvShowsTableView: UITableView!
    
    
    //variables
    var showsArrayObject = [NSManagedObject]()
    var showsArrayString = [String]()
    var favoritesArrayObject = [NSManagedObject]()
    var favoritesArrayString = [String]()
    
    // ARRAY from JSON
    var nameArrayJSON = [String]()
    var imageURLArrayJSON = [String]()
    var summaryArrayJSON = [String]()

    // ARRAY images Data
    
    var arrayImageData = [NSData]()
    var arrayImageDataCD = [NSData]()

    
    enum MyError: Error {
        case FoundNil(String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Core Data
        readFavorites()
        
        //Read JSON
        readJSONTVShows()
        
       // print(nameArrayJSON)
        
        
      //  print(favoritesArrayString)
        
        tvShowsTableView.reloadData()
        
        tvShowsTableView.delegate = self
        tvShowsTableView.dataSource = self
        
        let nibName = UINib(nibName: "TVShowsTableViewCell", bundle: Bundle.main)
        
        tvShowsTableView.register(nibName, forCellReuseIdentifier: "TVShowsTableViewCell")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        // Read core data
        readFavorites()
        
    }
    
    
    //MARK: Read Favorites
    func readFavorites()  {
        
        // delete previous information in arrays
        
        favoritesArrayObject = []
        favoritesArrayString = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TVShows")
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
    
    
    //MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return showsArrayString.count
        return nameArrayJSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tvShowsTableView.dequeueReusableCell(withIdentifier: "TVShowsTableViewCell", for: indexPath)
        
        guard let showsCell = cell as? TVShowsTableViewCell else {return cell}
        
        showsCell.labelCell.text = nameArrayJSON[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        // for image async
        
        let urlString = imageURLArrayJSON[indexPath.row]
        
        let urlStringNoHTTP = String(urlString.dropFirst(4))

        let urlStringHTTPS = "https\(urlStringNoHTTP)"

        let imgURL: URL = URL(string: urlStringHTTPS)!
        let request: URLRequest = URLRequest(url: imgURL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    
                    
                    
                    showsCell.imageCell.image = UIImage(data: data!)
                    
                    // save images in array for persistance
                    self.arrayImageData.append(data! as NSData)
                    
                    
                }
                
                
                DispatchQueue.main.async(execute: display_image)
            }
            
        })
        
        task.resume()

        
        return cell
    }
    
    
    //Edit
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // If exist in favorites only show the Delete button, else, show both.
        
        //Read favorites, to know if the TVshow already exist
        var arrReturn = [UITableViewRowAction]()
        
        
        if  favoritesArrayString.count != 0 && favoritesArrayString.contains(nameArrayJSON[indexPath.row]) {
        
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                

                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                // delete from favoritiesArrayString, but Have to search the same name, summary and image URL
                
                for i in 0..<self.favoritesArrayString.count {
                    
                    if self.nameArrayJSON[indexPath.row] == self.favoritesArrayString[i]{
                        
                        let favorite = self.favoritesArrayObject[i]
                        managedContext.delete(favorite)
                        
                    }
                    
                    if self.summaryArrayJSON[indexPath.row] == self.favoritesArrayString[i]{
                        
                        let summary = self.favoritesArrayObject[i]
                        managedContext.delete(summary)
                        
                    }
                    
                    if self.imageURLArrayJSON[indexPath.row] == self.favoritesArrayString[i]{
                        
                        let image = self.favoritesArrayObject[i]
                        managedContext.delete(image)
                        
                    }
                    
                    if self.imageURLArrayJSON[indexPath.row] == self.favoritesArrayString[i]{
                        
                        let imageData = self.favoritesArrayObject[i]
                        managedContext.delete(imageData)
                        
                    }

                    
                }
                
                
                
                do {
                    try managedContext.save()
                    
                    self.alertGeneral(errorDescrip: "TV Show deleted", information: "Information")
                    
                } catch let error as NSError {
                    print("Error While Deleting Note: \(error.userInfo)")
                    
                    self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
                    
                }
                
//                if self.showsArrayObject.count == 0 {
//
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddShowsViewController") as! AddShowsViewController
//
//                    self.present(nextViewController, animated:true, completion:nil)
//                } else {
//
//                   // self.readTvShows()
//                    self.readFavorites()
//
//                    self.tvShowsTableView.reloadData()
//
//                }
                
                
            }
            
            arrReturn = [delete]
            //return [delete]
            
            
        } else {
            
 
            
            // FAVORITES BUTTON
            
            let share = UITableViewRowAction(style: .normal, title: "Favorite") { (action, indexPath) in
                // Save to another entity to favorities
                
              //  self.saveFavorite(tvShow: self.showsArrayString[indexPath.row])
               //self.saveFavorite(tvShow: self.nameArrayJSON[indexPath.row])
                self.saveFavorite(tvShow: self.nameArrayJSON[indexPath.row], summary: self.summaryArrayJSON[indexPath.row], image: self.imageURLArrayJSON[indexPath.row], indexRow: indexPath.row)
                
                self.alertGeneral(errorDescrip: "The tv Show is now in your favorites", information: "Information")
                
                //self.readTvShows()
                self.readFavorites()
               ///self.tvShowsTableView.reloadData()
                
            }
            
            share.backgroundColor = UIColor.green
            
            arrReturn = [share]
            
            //return [delete, share]
            
            
        }
        
        return arrReturn
        
    }// End Table edit
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.5
        
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: Save favorite
    
    func saveFavorite(tvShow: String, summary:String, image:String, indexRow: Int)  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TVShows", in: context)
        let newTvShow = NSManagedObject(entity: entity!, insertInto: context)
        
        newTvShow.setValue(tvShow, forKey: "favorites")
        newTvShow.setValue(summary, forKey: "summary")
        newTvShow.setValue(image, forKey: "image")

        print(image)
        print(imageURLArrayJSON)
        
        // take de image URL and convert it to Data
        
        // for image async
        
        let urlString = image
        
        let urlStringNoHTTP = String(urlString.dropFirst(4))
        
        let urlStringHTTPS = "https\(urlStringNoHTTP)"
        
        let imgURL: URL = URL(string: urlStringHTTPS)!
        let request: URLRequest = URLRequest(url: imgURL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                
                self.arrayImageData.append(data! as NSData)

                newTvShow.setValue(data!, forKey: "imageData")

                
                
            }
            
        })
        
        task.resume()
        
        
        
        
        //Convert image URL to image and save it in Data type in NSUserDefatult array
        
       // arrayImageDataCD.append(arrayImageData[indexRow])
        
        //print(arrayImageDataCD)
        
        let defaults = UserDefaults.standard
        defaults.set(arrayImageData, forKey: "imagesDataUserDefault")
        
        
       
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
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
    
    func alertNoTvShows() {
        
        let alert = UIAlertController(title: "Information", message: "You don't have Tv Shows yet, Do you whant to add some?.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            // go to  addVC
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddShowsViewController") as! AddShowsViewController
            
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            
        }))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func readJSONTVShows() {
        
        let url = "https://api.tvmaze.com/shows"
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.data != nil {
                    
                    print("###Success: \(response.result.isSuccess)")
                    //now response.result.value is SwiftyJSON.JSON type
                    
                    // print(response.data!)
                    
                    
                    do {
                        //let json = try JSON(data: response.data!)
                        // print(json)
                        
                        if let dict = response.result.value as? [[String : AnyObject]]{
                            
                            for everyItem in dict {
                                guard let name = everyItem["name"] as! String? else {
                                    
                                    throw MyError.FoundNil("JSONDict")
                                    
                                }
                                

                                
                                guard let summary = everyItem["summary"] as! String? else {
                                    
                                    throw MyError.FoundNil("JSONDict")
                                    
                                }
                                
                                
                                guard let image = everyItem["image"]  else {
                                
                                throw MyError.FoundNil("JSONDict")
                                
                                }
                                
                                guard let imageMedium = image["medium"] as! String? else {
                                    
                                    throw MyError.FoundNil("JSONDict")

                                }
                                
                               // print(imageMedium)
                                
                                self.nameArrayJSON.append(name)
                                self.summaryArrayJSON.append(summary)
                                self.imageURLArrayJSON.append(imageMedium)


                            }
                            
                            self.tvShowsTableView.reloadData()

                            
                        }
                        
                    } catch {
                        print(error)
                        // or display a dialog
                    }
                    
                    
                }
        }
        
        
    } // End function
   
}// End VC
