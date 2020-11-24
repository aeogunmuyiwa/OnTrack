//
//  Transactions.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-20.
//

import UIKit

class Transaction: NSObject {
    
    let date : TimeInterval?
    let transactionDescription : String?
    var categoryId : Double?
    let amount : Money?
    
    init(_ transactionDescription : String?, _ amount : Money? ,_ categoryId : Double? , _ date  : TimeInterval?) {
        self.transactionDescription = transactionDescription
        self.categoryId = categoryId
        self.amount = amount
        self.date = date
    }
}
