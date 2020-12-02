//
//  DatabaseManager.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-24.
//

import UIKit
import CoreData
import Combine
class DatabaseManager: NSObject {
    // MARK: - Core Data stack

    static let shared = DatabaseManager()
    
  
    private lazy var persistentContainer: NSPersistentContainer = {
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let categoryFetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetchRequest.sortDescriptors = [.init(keyPath: \Category.categoryDescription, ascending: true)]
        
        let fetchedController = NSFetchedResultsController<Category>(fetchRequest: categoryFetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedController
    }()
    
    lazy var fetchedTransactionResultsController: NSFetchedResultsController<OnTractTransaction> = {
        let TransactionFetchRequest : NSFetchRequest<OnTractTransaction> = OnTractTransaction.fetchRequest()
        TransactionFetchRequest.sortDescriptors = [.init(keyPath: \OnTractTransaction.date, ascending: false)]
        
        let fetchedController = NSFetchedResultsController<OnTractTransaction>(fetchRequest: TransactionFetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedController
    }()
    
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
  
    // MARK: - Core Data Saving support

    func saveContext () {
        
        do {
            if self.viewContext.hasChanges {
                try self.viewContext.save()
                NotificationCenter.default.post(name: .reloadCategoryTable, object: nil)
                determineHeight()
            }
           
        }catch{
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    func determineHeight(){
        let height = (DatabaseManager.shared.fetchedResultsController.sections?[0].numberOfObjects ?? 0) * 100
        NotificationCenter.default.post(name: .updateHomeViewModelManagerHeight, object: height)
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

    //MARK : add transaction to category , update category aftual and difference
    func AddTransactionToCategory(_ transaction : OnTractTransaction, category : Category){
        category.addToTransactions(transaction)
        category.actual =  category.actual?.adding(transaction.amount ?? 0)
        let temp = category.actual
        category.difference = category.budget?.subtracting(temp ?? 0)
    }
    
    //Mark save transaction
    func saveTransaction (_ transactionValue : ViewTransaction ) -> OnTractTransaction{
        let transaction = OnTractTransaction.init(context: viewContext)
        transaction.amount = NSDecimalNumber(decimal: transactionValue.transaction?.amount ?? 0)
        transaction.date = transactionValue.transaction?.date ?? Date().timeIntervalSince1970
        transaction.transactionDescription = transactionValue.transaction?.transactionDescription
        if let category = transactionValue.category {
            transaction.category = category
            transaction.category?.actual = transaction.category?.actual?.adding(transaction.amount ?? 0)
            transaction.category?.difference = transaction.category?.budget?.subtracting(transaction.category?.actual ?? 0)
            transaction.category?.addToTransactions(transaction)
        }
      
        saveContext()
        return transaction
    }
    
 
    //MARK: edit transaction
//    func editTransactionToCategory(_ transaction : OnTractTransaction, category : Category, _ index : Int){
//
//        let t_atPreviousIndex = (category.transactions?.array as! [OnTractTransaction])[index].amount ?? 0
//
//        let actual_difference = category.actual?.subtracting(t_atPreviousIndex)
//        category.actual = actual_difference?.adding(transaction.amount ?? 0)
//        category.replaceTransactions(at: index, with: transaction)
//        category.difference = category.budget?.subtracting(category.actual ?? 0)
//
//
//    }
    
    //MARK: DELETE TRANSACTION FORM CATEGORY AND UPDATE ACTUAL AND DIFFERENCE
    func deleteTransactionHelper(_ category : Category, transaction : OnTractTransaction){
        transaction.category?.actual =  category.actual?.subtracting(transaction.amount ?? 0)
        transaction.category?.difference = category.budget?.subtracting(category.actual ?? 0)
       // saveContext()
        viewContext.delete(transaction)
        saveContext()
        
    }
    
    //MARK: save category helper function,
    func CategorySave(_ category : CategoryStruct){
        let data = Category(context: viewContext)
        data.budget =  NSDecimalNumber(decimal: category.budget ?? 0)
        data.id = category.id
        data.categoryDescription = category.category
        data.difference = data.budget?.subtracting(data.actual ?? 0)
            category.transactions?.forEach({ item in
            let transaction = OnTractTransaction.init(context: viewContext)
            transaction.amount =  item.amount as NSDecimalNumber?
            transaction.categoryId =  category.id
            transaction.date = item.date ?? Date().timeIntervalSince1970
            transaction.transactionDescription = item.transactionDescription
            data.actual = data.actual?.adding(transaction.amount ?? 0)
            data.difference = data.budget?.subtracting(data.actual ?? 0)
            data.addToTransactions(transaction)
                transaction.category = data
        })
        self.saveContext()
    }
    
    //Mark updateBudget
    func updateBudget(_ budget : Category , _ budgetName : String, _ amount : Money){
        budget.categoryDescription = budgetName
        budget.budget = NSDecimalNumber(decimal: amount)
        budget.difference = budget.budget?.subtracting(budget.actual ?? 0)
        self.saveContext()
    }

    //Mark : update Transaction
    func updateTransaction(_ viewTransaction : ViewTransaction, transaction : OnTractTransaction){
        let t_atPreviousIndex = transaction.amount
        transaction.amount = NSDecimalNumber(decimal: viewTransaction.transaction?.amount ?? 0)
        transaction.date = viewTransaction.transaction?.date ?? Date().timeIntervalSince1970
        transaction.transactionDescription = viewTransaction.transaction?.transactionDescription
        transaction.category?.actual = transaction.category?.actual?.subtracting(t_atPreviousIndex ?? 0)
        transaction.category?.actual = transaction.category?.actual?.adding(transaction.amount ?? 0)
        transaction.category?.difference = transaction.category?.budget?.subtracting(transaction.category?.actual ?? 0)
        saveContext()
    }
    
    
    //MARK: edit transaction
//    func editTransactionToCategory(_ transaction : OnTractTransaction, category : Category, _ index : Int){
//
//        let t_atPreviousIndex = (category.transactions?.array as! [OnTractTransaction])[index].amount ?? 0
//
//        let actual_difference = category.actual?.subtracting(t_atPreviousIndex)
//        category.actual = actual_difference?.adding(transaction.amount ?? 0)
//        category.replaceTransactions(at: index, with: transaction)
//        category.difference = category.budget?.subtracting(category.actual ?? 0)
//
//
//    }
    //MARK: delete category from database
    func deleteCategory(_ deleteObject : NSManagedObject){
        viewContext.delete(deleteObject)
        saveContext()
        
    }
    
    //Mark delete transaction from database
    func deleteTransaction(_ transactionObject : OnTractTransaction){
        if let category  = transactionObject.category {
            deleteTransactionHelper(category, transaction: transactionObject)
        }else{
            viewContext.delete(transactionObject)
            saveContext()
        }
        
    }
 
    
    func loadDatabase(completionHandler : @escaping([Category]?) -> Void) {
            let categoryFetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
            categoryFetchRequest.sortDescriptors = [.init(keyPath: \Category.categoryDescription, ascending: true)]
            do {
                let categories = try self.viewContext.fetch(categoryFetchRequest)
                completionHandler(categories)
                
            }catch {
                completionHandler(nil)
            }
    }
    
    func loadTransactions() -> [OnTractTransaction]? {
       
            let TransactionFetchRequest : NSFetchRequest<OnTractTransaction> = OnTractTransaction.fetchRequest()
            TransactionFetchRequest.sortDescriptors = [.init(keyPath: \OnTractTransaction.date, ascending: true)]
            do {
                let transactions = try self.viewContext.fetch(TransactionFetchRequest)
                return transactions
            }catch {
                return nil
            }
    }
    
    func performFetch(){
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            print("error")
        }
    }
    
    func performTransactionFetch(){
        do {
            try fetchedTransactionResultsController.performFetch()
        }catch{
            print("error")
        }
    }
    
    //func delete all categories from coredata
    func deleteAllCategory(){
        let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try viewContext.execute(deleteRequest)
        } catch {
            print("error performing batch delete")
        }
    }
    
    func LoadDatabase () -> Future < [Category] , dataBaseErrors> {
        return Future () { promise in
            let categoryFetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
            categoryFetchRequest.sortDescriptors = [.init(keyPath: \Category.categoryDescription, ascending: true)]
            do {
                let categories = try self.viewContext.fetch(categoryFetchRequest)
                promise(.success(categories))
            }catch {
                promise(.failure(.ErrorLoadingDatabase))
            }


        }
    }
}

