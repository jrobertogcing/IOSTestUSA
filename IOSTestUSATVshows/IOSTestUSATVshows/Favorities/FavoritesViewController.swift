//
//  FavoritesViewController.swift
//  IOSTestUSATVshows
//
//  Created by Jose González on 11/15/18.
//  Copyright © 2018 Jose González. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favoritesTableView: UITableView!
    
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


    // ARRAY images Data
    
    var arrayImageDataCD = [NSData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Core Data
       // readFavorites()
        
        //print(favoritesArrayString)
       // print(imageArrayURL)
        
        
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        let nibName = UINib(nibName: "FavoritesTableViewCell", bundle: Bundle.main)
        
        favoritesTableView.register(nibName, forCellReuseIdentifier: "FavoritesTableViewCell")
       
       // favoritesTableView.reloadData()
        DispatchQueue.main.async {
            self.favoritesTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //readFavorites()
        
        readFavorites { (dataBol) in
            
            self.favoritesTableView.reloadData()

            
        }
        
    }
    
    
    //MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoritesArrayString.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath)
        
        guard let favoritesCell = cell as? FavoritesTableViewCell else {return cell}
        
        favoritesCell.nameCell.text = favoritesArrayString[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        
        //Reading image from CoreData
      
        
            favoritesCell.imageCell.image = UIImage(data: self.imageDataArrayURL[indexPath.row])
        
    
        
        // --Reading image from NSUSERDEFAULT -- OPTIONAL
//        if arrayImageDataCD.count != 0{
//        favoritesCell.imageCell.image = UIImage(data: arrayImageDataCD[indexPath.row] as Data)
//        }
        
        
        // Reading image from URL Internet
        
//        // for image async
//
//        let urlString = imageArrayURL[indexPath.row]
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
//               {
//
//
//
//                    favoritesCell.imageCell.image = UIImage(data: data!)
//
//
//               }
//
//
//            DispatchQueue.main.async(execute: display_image)
//            }
//
//        })
//
//        task.resume()


        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.5
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        nextViewController.nameR = favoritesArrayString[indexPath.row]
        nextViewController.indexTvShow = indexPath.row
        nextViewController.summary = summaryArrayURL[indexPath.row]
        nextViewController.imageURL = imageArrayURL[indexPath.row]
        
        self.present(nextViewController, animated:true, completion:nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // delete from favoritiesArrayString
            let favorite = self.favoritesArrayObject[indexPath.row]
            
            managedContext.delete(favorite)
            
            let image = self.imageArrayURLObject[indexPath.row]
            
            managedContext.delete(image)
            
            let summary = self.summaryArrayURLObject[indexPath.row]
            
            managedContext.delete(summary)
            
          
            
            
            do {
                try managedContext.save()
                
                self.alertGeneral(errorDescrip: "TV Show deleted from Favorites", information: "Information")
                
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
                
                self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
                
            }
            
            //self.readFavorites()
            self.readFavorites { (dataBol) in
                
                self.favoritesTableView.reloadData()
                
                
            }
            
            //self.favoritesTableView.reloadData()
            
            
        }
        
        
        
        return [delete]
    }
    
    //MARK: Read Favorites
        func readFavorites (completion: @escaping (Bool) -> Void ){

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
                
                favoritesTableView.reloadData()
                
            }
            
            
            // -----Read NSUserDefault Image Data array-- Optional
            
           // let defaults = UserDefaults.standard

//            if favoritesArrayString.count != 0{
//                arrayImageDataCD = (defaults.object(forKey: "imagesDataUserDefault")) as! [NSData]
//            }
//            //as? [NSData])!
//            print(arrayImageDataCD)

            
            
           // favoritesTableView.reloadData()
            completion (true)
            
        } catch {
            
            print("Failed")
            self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
            completion(false)
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
