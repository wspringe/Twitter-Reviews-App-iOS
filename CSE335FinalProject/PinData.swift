//
//  PinData.swift
//  CSE335FinalProject
//
//  Created by Wesley Springer on 4/21/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PinData {
    
    var pinContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var fetchResults = [PinEntity]()
    var pinID = 0
    
    //copied from coreDataTableView example
    func fetchRecord() -> Int {
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PinEntity")
        var x   = 0
        // Execute the fetch request, and cast the results to an array of LogItem objects
        fetchResults = ((try? pinContext.fetch(fetchRequest)) as? [PinEntity])!
        
        
        x = fetchResults.count
        
        
        return x
        
    }
    
    func save() {
        do {
            try pinContext.save()
        } catch _ { }
    }
    
    //adds a pin to coredata
    func add(t: String, s: String, lat: Double, long: Double) {
        fetchRecord()
        let ent = NSEntityDescription.entity(forEntityName: "PinEntity", in: pinContext)
        let newItem = PinEntity(entity: ent!, insertInto: pinContext)
        newItem.title = t
        newItem.lat = lat
        newItem.long = long
        newItem.subtitle = s
        
        save()
    }
    
    //Deletes a pin from CoreData taking in the index
    func delete(row: Int) {
        pinContext.delete(fetchResults[row])
        save()
    }
    
    //edits a pin information in CoreData
    func edit(t: String, s: String, lat: Double, long: Double) {
        fetchRecord()
        
        let index = search(lat: lat, long: long)
        
        fetchResults[index].title = t
        fetchResults[index].subtitle = s
        save()
    }
    
    //Seaches for a specific pin in CoreData and returns the index of that pin
    func search(lat: Double, long: Double) -> Int {
        let count = fetchRecord()
        
        var returnedIndex = -1
        
        let formattedLat = String(format: "%.6f", lat)
        let formattedLong = String(format: "%.6f", long)
        
        for row in 0...count-1 {
            
            if String(format: "%.6f", fetchResults[row].lat) == formattedLat {
                
                for row2 in 0...count-1 {
                    
                    if String(format: "%.6f", fetchResults[row2].long) == formattedLong {
                        return row2
                    }
                    else {
                        //should never reach here
                    }
                }
            }
            else {
                //should never reach here
            }
        }
        //should never reach here
        return returnedIndex
    }
    
}
