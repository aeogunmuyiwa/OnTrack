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
    case pageThree
    
    var name: String {
        switch self {
        case .pageZero:
            return "This week transaction summary "
        case .pageOne:
            return "This month transaction summary"
        case .pageTwo:
            return "Weekly transactions"
        case .pageThree:
            return "This is page three"
        }
    }
    var data : Any? {
        switch self {
        case .pageZero: return setdata(.pageZero)
        case .pageOne: return setdata(.pageOne)
        default: return analytics.self
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
            
        
        default:
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
        case .pageThree:
            return 3
        }
    }
}
