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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Core Data
        readFavorites()
        readTvShows()
        
        print(favoritesArrayString)
        
        favoritesTableView.reloadData()
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        let nibName = UINib(nibName: "FavoritesTableViewCell", bundle: Bundle.main)
        
        favoritesTableView.register(nibName, forCellReuseIdentifier: "FavoritesTableViewCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readFavorites()
        favoritesTableView.reloadData()
        
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
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.5
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        nextViewController.nameR = favoritesArrayString[indexPath.row]
        
        self.present(nextViewController, animated:true, completion:nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // delete from favoritiesArrayString
            let favorite = self.favoritesArrayObject[indexPath.row]
            
            managedContext.delete(favorite)
            
            // dlete from objeto tvshows favoritesArrayObject
            
            for i in 0..<self.showsArrayString.count{
                
                if  self.favoritesArrayString[indexPath.row] == self.showsArrayString[i] {
                    
                    self.favoritesArrayString.remove(at: indexPath.row)
                    self.showsArrayString.remove(at: i)
                    
                    let show = self.showsArrayObject[i]
                    
                    managedContext.delete(show)
                    break
                    
                }
                
            }
            
            
            do {
                try managedContext.save()
                
                self.alertGeneral(errorDescrip: "TV Show deleted", information: "Information")
                
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
                
                self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
                
            }
            
            self.readTvShows()
            self.readFavorites()
            self.favoritesTableView.reloadData()
            
            
        }
        
        
        
        return [delete]
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
    
    
  

}
