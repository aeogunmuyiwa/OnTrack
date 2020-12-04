//
//  sortingFile.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-02.
//

import UIKit
struct analytics {
    let horizontalAxisMarker : [String]
    let dataValueStruct : [DataValueStruct]
    let headerTitle : String
    struct DataValueStruct {
        let title : String
        let value : [NSDecimalNumber]
    }
}

struct BudgetVSTransaction {
    let horizontalAxisMarker : [String]
    let budgetValues : [CGFloat]
    let actualValues : [CGFloat]
}


class analytics_sortbyweekday {
    let headerTitle : String
    var horizontalAxisMarker : [String] = []
    var data : [weekdays : NSDecimalNumber] = [.sunday : 0 , .monday : 0, .tuesday : 0 , .wednesday : 0, .thursday : 0 , .friday : 0 , .saturday : 0]
    var transactions : [weekdays: [OnTractTransaction]] = [:]
    init(_ headerTitle : String) {
        self.headerTitle = headerTitle
    }
    let color = CustomProperties.shared.animationColor
}






enum weekdays : CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    var index : Int {
        switch self {
        case .sunday: return 1
        case .monday : return 2
        case .tuesday : return 3
        case .wednesday : return 4
        case .thursday : return 5
        case .friday : return 6
        case .saturday : return 7
        }
    }
    
    var name : String {
        switch  self {
        case .sunday: return "S"
        case .monday : return "M"
        case .tuesday : return "T"
        case .wednesday : return "W"
        case .thursday : return "T"
        case .friday : return "F"
        case .saturday : return "S"
        }
    }
}


class WeekdayTransactionAnalyticsSort: NSObject {
    func appendToTransaction(weekdayAnalytics : analytics_sortbyweekday, item : OnTractTransaction, key : weekdays){
        if var temp =  weekdayAnalytics.transactions[key] {
            temp.append(item)
            weekdayAnalytics.transactions.updateValue(temp, forKey: key)
        }else{
            weekdayAnalytics.transactions[key] = [item]
        }
    }
    
    func sortingByWeekday(sortby : [OnTractTransaction]) -> analytics_sortbyweekday?{
        let weekdayAnalytics : analytics_sortbyweekday = .init("Transactions")
        weekdayAnalytics.horizontalAxisMarker = .init(repeating: "", count: 7)
        weekdays.allCases.forEach({item in
            switch item {
            case .monday:  weekdayAnalytics.horizontalAxisMarker[1] = item.name
            case .tuesday:  weekdayAnalytics.horizontalAxisMarker[2] = item.name
            case .wednesday: weekdayAnalytics.horizontalAxisMarker[3] = item.name
            case .thursday: weekdayAnalytics.horizontalAxisMarker[4] = item.name
            case .friday: weekdayAnalytics.horizontalAxisMarker[5] = item.name
            case .saturday: weekdayAnalytics.horizontalAxisMarker[6] = item.name
            case .sunday: weekdayAnalytics.horizontalAxisMarker[0] = item.name
            }
        })
        
        
        
        sortby.forEach({ item in
            let date = Date(timeIntervalSince1970: item.date)
            if let day = CustomProperties.shared.checkdate(date: date){
                CustomProperties.shared.convertDatetoDAY(day: day, sunday: {
                    self.appendToTransaction(weekdayAnalytics: weekdayAnalytics, item: item, key: .sunday)
                }, monday: {
                    self.appendToTransaction(weekdayAnalytics: weekdayAnalytics, item: item, key: .monday)
                }, tueday: {
                    self.appendToTransaction(weekdayAnalytics: weekdayAnalytics, item: item, key: .tuesday)
                }, wedneday: {
                    self.appendToTransaction(weekdayAnalytics: weekdayAnalytics, item: item, key: .wednesday)
                }, thursday: {
                    self.appendToTransaction(weekdayAnalytics: weekdayAnalytics, item: item, key: .thursday)
                }, friday: {
                    self.appendToTransaction(weekdayAnalytics: weekdayAnalytics, item: item, key: .friday)
                }, saturday: {
                    self.appendToTransaction(weekdayAnalytics: weekdayAnalytics, item: item, key: .saturday)
                })
            }
        })
        
        _ = weekdayAnalytics.transactions.map({key, values in
            switch key {
            case .monday:
                let sum = values.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
                                            x.adding(y.amount ?? 0)})
                weekdayAnalytics.data[.monday] = sum
            case .tuesday:
                let sum = values.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
                                            x.adding(y.amount ?? 0)})
                weekdayAnalytics.data[.tuesday] = sum
            case .wednesday:
                let sum = values.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
                                            x.adding(y.amount ?? 0)})
                weekdayAnalytics.data[.wednesday] = sum
            case .thursday:
                let sum = values.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
                                            x.adding(y.amount ?? 0)})
                weekdayAnalytics.data[.thursday] = sum
            case .friday:
                let sum = values.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
                                            x.adding(y.amount ?? 0)})
                weekdayAnalytics.data[.friday] = sum
            case .saturday:
                let sum = values.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
                                            x.adding(y.amount ?? 0)})
                weekdayAnalytics.data[.saturday] = sum
            case .sunday:
                let sum = values.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
                                            x.adding(y.amount ?? 0)})
                weekdayAnalytics.data[.sunday] = sum
            }
        })
        
        return weekdayAnalytics
    }
}
