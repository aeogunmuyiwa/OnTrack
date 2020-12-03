//
//  sortingFile.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-02.
//

import UIKit
class analytics_sortbyweekday {
    var data : [weekdays : NSDecimalNumber] = [:]
    var transactions : [weekdays: [OnTractTransaction]] = [:]
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
}

class sortingFile: NSObject {
    func appendToTransaction(weekdayAnalytics : analytics_sortbyweekday, item : OnTractTransaction, key : weekdays){
        if var temp =  weekdayAnalytics.transactions[key] {
            temp.append(item)
            weekdayAnalytics.transactions.updateValue(temp, forKey: key)
        }else{
            weekdayAnalytics.transactions[key] = [item]
        }
    }

    func sortingByWeekday(sortby : [OnTractTransaction]) -> analytics_sortbyweekday?{
        let weekdayAnalytics : analytics_sortbyweekday = .init()
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
