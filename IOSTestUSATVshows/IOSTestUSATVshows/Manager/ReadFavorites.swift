//
//  ReadFavorites.swift
//  IOSTestUSATVshows
//
//  Created by Jose González on 11/20/18.
//  Copyright © 2018 Jose González. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class ReadFavorites: NSObject {

    // ARRAY from JSON
    var nameArrayJSON = [String]()
    var imageURLArrayJSON = [String]()
    var summaryArrayJSON = [String]()

    enum MyError: Error {
        case FoundNil(String)
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
                            
                           // self.tvShowsTableView.reloadData()
                            
                            
                        }
                        
                    } catch {
                        print(error)
                        // or display a dialog
                    }
                    
                    
                }
        }
        
        
    } // End function
    
    
}
