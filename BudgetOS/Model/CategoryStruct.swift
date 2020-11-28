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


    //sum of the transactions for the category
    var actual : Money
    
    //difference bewteen the set budget and the sum of transactions
    var difference : Money

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



