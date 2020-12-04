//
//  AnalyticsPages.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-03.
//

import UIKit
enum AnalyticsPages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
   
    
    var name: String {
        switch self {
        case .pageZero:
            return "This week transaction summary "
        case .pageOne:
            return "This month transaction summary"
        case .pageTwo:
            return "Budget vs transactions"
        }
    }
    var data : Any? {
        switch self {
        case .pageZero: return setdata(.pageZero)
        case .pageOne: return setdata(.pageOne)
        case .pageTwo: return setdata(.pageTwo)
        }
    }
    
    func setdata( _ expression : AnalyticsPages)  -> Any? {
        switch expression {
        case .pageZero:
            DatabaseManager.shared.performTransactionFetch()
            if let transactions =  DatabaseManager.shared.fetchedTransactionResultsController.fetchedObjects {
                let TransactionsInCurrentWeel = transactions.filter({ item in
                    if CustomProperties.shared.isDayInCurrentWeek(date: Date(timeIntervalSince1970: item.date)) == true {
                        return true
                    }else{
                        return false
                    }
                 
                })
                
                let result = WeekdayTransactionAnalyticsSort.init().sortingByWeekday(sortby:  TransactionsInCurrentWeel)
               return result
            }
            return nil
            
        case .pageOne :
            
            DatabaseManager.shared.performTransactionFetch()
            if let transactions =  DatabaseManager.shared.fetchedTransactionResultsController.fetchedObjects {
                let TransactionsInCurrentWeel = transactions.filter({ item in
                    if  Date(timeIntervalSince1970: item.date).isInSameMonth(as: Date()) == true {
                        return true
                    }else{
                        return false
                    }
                 
                })
                let result = WeekdayTransactionAnalyticsSort.init().sortingByWeekday(sortby:  TransactionsInCurrentWeel)
               return result
            }
            return nil
            
            
            
        case .pageTwo:
            DatabaseManager.shared.performFetch()
            let categories = DatabaseManager.shared.fetchedResultsController.fetchedObjects
            if let categories = categories {
                let horizonalValue = categories.map({ item in
                    return (item.categoryDescription ?? "")
                })
                let value : [CGFloat] = categories.map({item in
                    return  (CGFloat(exactly: item.budget ?? 0) ?? 0)
                })
                
                let actial : [CGFloat] = categories.map({item in
                    return (CGFloat(exactly: item.actual ?? 0) ?? 0)
                })
                return BudgetVSTransaction(horizontalAxisMarker: horizonalValue, budgetValues: value, actualValues: actial)
            }
            return nil
        }
    }
    
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        }
    }
}
