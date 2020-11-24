//
//  DatabaseManager.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-24.
//

import UIKit
import CoreData
class DatabaseManager: NSObject {
    // MARK: - Core Data stack

    static let shared = DatabaseManager()
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BudgetOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Mark : create OnTractTransaction object
    func createTransaction(_ transaction : Transaction ) -> OnTractTransaction?  {
      
        let newTransaction = OnTractTransaction.init(context: viewContext)
        if let amount = transaction.amount , let id = transaction.categoryId , let date = transaction.date, let t_description = transaction.transactionDescription{
            newTransaction.amount = NSDecimalNumber(decimal: amount)
            newTransaction.categoryId = id
            newTransaction.date = date
            newTransaction.transactionDescription = t_description
            return newTransaction
        }
        return nil
    }
    
    func createCategory(_ categoryStruct : CategoryStruct) -> Category {
        let category = Category.init(context: viewContext)
        category.actual = NSDecimalNumber(decimal: categoryStruct.actual)
        category.budget = categoryStruct.budget as NSDecimalNumber?
        category.categoryDescription = categoryStruct.category
        category.id = categoryStruct.id
        
        categoryStruct.transactions?.forEach({ transaction in
            if let createdTransaction = createTransaction(transaction){
                category.addToTransactions(createdTransaction)
            }
        })
        
        return category
    }
}
