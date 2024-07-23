//
//  CoreDataManager.swift
//  TendableApp
//
//  Created by Menti on 16/07/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    func getManagedContext() -> NSManagedObjectContext {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return managedObjectContext
    }
    
    //MARK: - Save into given Entity
    func insert(entity: String, objectToSave: [String : Any]) {
        
        let managedObjectContext = getManagedContext()
        
        //adding new doc and saving in database...
        let content = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedObjectContext)
        content.setValuesForKeys(objectToSave)
        do {
            try managedObjectContext.save()
        } catch {
        }
    }
    
    
    //MARK: - Fetch Data
    func fetchAllData<T>(entityName: String, parameter: T.Type) -> [T] {
       
        let managedObjectContext: NSManagedObjectContext = getManagedContext()
        let fetchRequest   =  NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var commanArray = [T]()
        
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let fetchedResult = try managedObjectContext.fetch(fetchRequest) as? [T]
            if let results = fetchedResult{
                commanArray = results as [T]
            }
        } catch {
        }
        
        return commanArray
    }
    
    //MARK: - Fetch Purticular Inspection Data
    func fetchAllDataForInspection<T>(inspectionId: Int, entityName: String, parameter: T.Type) -> [T] {
       
        let managedObjectContext: NSManagedObjectContext = getManagedContext()
        let fetchRequest   =  NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "inspectionId == %@", argumentArray: [inspectionId])
        var commanArray = [T]()
        
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let fetchedResult = try managedObjectContext.fetch(fetchRequest) as? [T]
            if let results = fetchedResult{
                commanArray = results as [T]
            }
        } catch {
        }
        
        return commanArray
    }
    
    //MARK: - Delet all data of given entity
    func deleteRecordFromDatabase(entityName: String) {
        
        let context = getManagedContext()
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        requestDel.returnsObjectsAsFaults = false
        
        do {
            let arrUsrObj = try context.fetch(requestDel)
            for object in arrUsrObj as! [NSManagedObject] { // Fetching Object
                context.delete(object) // Deleting Object
            }
        } catch {
            print("Failed")
        }
        // Saving the Delete operation
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func updateAnswers(questionId: Int, categoryId: Int, selectedAnswerChoiceId: Int){
        let managedObjectContext: NSManagedObjectContext = getManagedContext()
        let fetchRequest   =  NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionsDB")
        
        fetchRequest.predicate = NSPredicate(format: "questionId == %@ && categoryId == %@", argumentArray: [questionId, categoryId])
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(selectedAnswerChoiceId, forKey: "selectedAnswerChoiceId")
                }
            }
        } catch {
        }
        
        do {
            try managedObjectContext.save()
        } catch {
        }
    }
}
