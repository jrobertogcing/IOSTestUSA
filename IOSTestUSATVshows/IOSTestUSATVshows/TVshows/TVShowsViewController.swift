//
//  TVShowsViewController.swift
//  IOSTestUSATVshows
//
//  Created by Jose González on 11/15/18.
//  Copyright © 2018 Jose González. All rights reserved.
//

import UIKit
import CoreData

class TVShowsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    @IBOutlet weak var tvShowsTableView: UITableView!
    
    
    //variables
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
        
        tvShowsTableView.reloadData()
        
        tvShowsTableView.delegate = self
        tvShowsTableView.dataSource = self
        
        let nibName = UINib(nibName: "TVShowsTableViewCell", bundle: Bundle.main)
        
        tvShowsTableView.register(nibName, forCellReuseIdentifier: "TVShowsTableViewCell")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if showsArrayString.count == 0 {
            alertNoTvShows()
        }
        
        // Read core data
        readTvShows()
        readFavorites()
        
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
            
            
            tvShowsTableView.reloadData()
            
            
            
        } catch {
            
            print("Failed")
            self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
            
        }
        
        
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
    
    
    //MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsArrayString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tvShowsTableView.dequeueReusableCell(withIdentifier: "TVShowsTableViewCell", for: indexPath)
        
        guard let showsCell = cell as? TVShowsTableViewCell else {return cell}
        
        //showsCell.nameCell.text = showsArrayString[indexPath.row]
        showsCell.labelCell.text = showsArrayString[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        
        
        return cell
    }
    
    
    //Edit
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // If exist in favorites only show the Delete button, else, show both.
        
        //Read favorites, to know if the TVshow already exist
        var arrReturn = [UITableViewRowAction]()
        
        
        if  favoritesArrayString.count != 0 && favoritesArrayString.contains(showsArrayString[indexPath.row]) {
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                //let noteEntity = "TVShows" //Entity Name
                
                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let show = self.showsArrayObject[indexPath.row]
                
                managedContext.delete(show)
                
                //self.showsArrayString.remove(at: indexPath.row)
                
                // also delete in favorites
                
                print(self.favoritesArrayObject)
                print(self.showsArrayString)
                for i in 0..<self.favoritesArrayString.count {
                    
                    if self.favoritesArrayString[i] == self.showsArrayString[indexPath.row] {
                        
                        print(self.favoritesArrayString[i])
                        print(self.showsArrayString[indexPath.row])
                        
                        self.favoritesArrayString.remove(at: i)
                        self.showsArrayString.remove(at: indexPath.row)
                        
                        let favorite = self.favoritesArrayObject[i]
                        
                        managedContext.delete(favorite)
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
                
                if self.showsArrayObject.count == 0 {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddShowsViewController") as! AddShowsViewController
                    
                    self.present(nextViewController, animated:true, completion:nil)
                } else {
                    
                    self.readTvShows()
                    self.readFavorites()
                    
                    self.tvShowsTableView.reloadData()
                    
                }
                
                
            }
            
            arrReturn = [delete]
            //return [delete]
            
            
        } else {
            
            // Show both buttons
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                //let noteEntity = "TVShows" //Entity Name
                
                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let show = self.showsArrayObject[indexPath.row]
                
                managedContext.delete(show)
                
                self.showsArrayString.remove(at: indexPath.row)
                
                // is not in favarites
                print(self.favoritesArrayObject)
                print(self.showsArrayString)
                
                
                do {
                    try managedContext.save()
                    
                    self.alertGeneral(errorDescrip: "TV Show deleted", information: "Information")
                    
                    
                } catch let error as NSError {
                    print("Error While Deleting Note: \(error.userInfo)")
                    self.alertGeneral(errorDescrip: "Try again", information: "- Oops, something went wrong")
                    
                }
                
                if self.showsArrayObject.count == 0 {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddShowsViewController") as! AddShowsViewController
                    
                    self.present(nextViewController, animated:true, completion:nil)
                } else {
                    
                    
                    
                    self.readTvShows()
                    self.readFavorites()
                    self.tvShowsTableView.reloadData()
                    
                }
                
                
            }
            
            // FAVORITES BUTTON
            
            let share = UITableViewRowAction(style: .normal, title: "Favorite") { (action, indexPath) in
                // Save to another entity to favorities
                
                self.saveFavorite(tvShow: self.showsArrayString[indexPath.row])
                
                self.alertGeneral(errorDescrip: "The tv Show is now in your favorites", information: "Information")
                
                self.readTvShows()
                self.readFavorites()
                self.tvShowsTableView.reloadData()
                
            }
            
            share.backgroundColor = UIColor.green
            
            arrReturn = [delete, share]
            
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
    
    //MARK: Save favoritie
    
    func saveFavorite(tvShow: String)  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TVShows", in: context)
        let newTvShow = NSManagedObject(entity: entity!, insertInto: context)
        
        newTvShow.setValue(tvShow, forKey: "favorites")
        
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
    
    
   
}
