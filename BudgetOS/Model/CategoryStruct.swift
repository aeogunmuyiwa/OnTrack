//
//  CategoryStruct.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-20.
//

import UIKit


typealias Money = Decimal


class CategoryStruct: NSObject {
    let id : Double = Date().timeIntervalSince1970
    var category : String?
    var budget : Money?
    var transactions : [Transaction]?
//    func addToTransaction(_ object : Any){
//        if let transaction = transactions {
//            (transaction.mutableCopy() as? NSMutableOrderedSet)?.add(object)
//            
//        }
//    }
//    func editTransaction(_ object : Any, _ index : Int){
//        if let transactions = transactions {
//            (transactions.mutableCopy() as? NSMutableOrderedSet)?.replaceObject(at: index, with: object)
//        }
//    }
    
    
    //sum of the transactions for the category
    var actual : Money
    //{
//
//        get {
//            var totalTransaction : Money = 0
//            transactions?.forEach({item in
//                totalTransaction = totalTransaction  + (item.amount ?? 0)
//            })
//            return totalTransaction
//        }
//    }
    
    
    
    //difference bewteen the set budget and the sum of transactions
    var difference : Money
    //{
//        get{
//            return (budget ?? 0) - (actual ?? 0)
//        }
//    }
    init(_ category : String, _ budget : Money, _ transactions : [Transaction]?) {
        self.category = category
        self.budget = budget
        self.transactions  = transactions
        self.actual = 0
        self.difference = 0
    }
     init(_ category : String?, _ budget : Money?) {
        self.category = category
        self.budget = budget
        self.transactions = .init()
        self.actual = 0
        self.difference = 0
    }
}



