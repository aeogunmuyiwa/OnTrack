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
    
    //add transaction to category , update category aftual and difference
    
    func AddTransactionToCategory(_ transaction : OnTractTransaction, category : Category){
        category.addToTransactions(transaction)
        category.actual =  category.actual?.adding(transaction.amount ?? 0)
        let temp = category.actual
        category.difference = category.budget?.subtracting(temp ?? 0)
    }
    
 
    //edit transaction
    func editTransactionToCategory(_ transaction : OnTractTransaction, category : Category, _ index : Int){
      
        let t_atPreviousIndex = (category.transactions?.array as! [OnTractTransaction])[index].amount ?? 0
        
        let actual_difference = category.actual?.subtracting(t_atPreviousIndex)
        category.actual = actual_difference?.adding(transaction.amount ?? 0)
        category.replaceTransactions(at: index, with: transaction)
        category.difference = category.budget?.subtracting(category.actual ?? 0)
        dump(category)
        
    }
    
    
    func deleteTransaction(_ category : Category, _ index : Int){
        let transaction = (category.transactions?.array as! [OnTractTransaction])[index]
        
        
        
        category.actual?.subtracting(transaction.amount ?? 0)
        category.difference = category.budget
        category.difference?.subtracting(category.actual ?? 0)
        category.removeFromTransactions(at: index)
        dump(category)
    }
    
    func saveCategory(_ category : Category){
      //  category.difference = category.budget?.subtracting(category.actual ?? 0)
    }
}
