//
//  CoreDataFunctions.swift
//  testMusic1
//
//  Created by Heltisace on 15.04.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import CoreData

class CoreDataFunctions {
    var fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getUser() -> [NSManagedObject]? {
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            return nil
        }
    }
    
    func deleteUser() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            appDelegate.saveContext()
        } catch {
            print("error")
        }
    }
    
    func addUser(email: String, password: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        //Creating new variable in CoreData
        let entity = NSEntityDescription.entity(forEntityName: "User", in: self.context)!
        let dataTask = NSManagedObject(entity: entity, insertInto: self.context)
        
        //Setting data to variable
        dataTask.setValue(email, forKey: "email")
        dataTask.setValue(password, forKey: "password")
        
        //Save data with appDelegate function
        appDelegate.saveContext()
    }
    
    func addToHistory(theSetID: String) {
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        
        //Get AppDelegate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        do {
            var results = try context.fetch(fetchRequest)
            while results.count > 19 {
                //Delte and save data with appDelegate function
                context.delete(results.first!)
                appDelegate.saveContext()
                //Get new results
                results = try context.fetch(fetchRequest)
            }
            
            //Creating new variable in CoreData
            let entity = NSEntityDescription.entity(forEntityName: "History", in: self.context)!
            let dataTask = NSManagedObject(entity: entity, insertInto: self.context)
            
            //Setting data to variable
            dataTask.setValue(theSetID, forKey: "setID")
            
            //Save data with appDelegate function
            appDelegate.saveContext()
        } catch {
            print("error")
        }
    }
    
    func getHistory() -> [NSManagedObject]? {
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            return nil
        }
    }
}
