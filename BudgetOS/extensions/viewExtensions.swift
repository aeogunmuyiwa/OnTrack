//
//  viewExtensions.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-19.
//

import UIKit
extension Notification.Name {
    static let saveCategory_Publisher = Notification.Name(rawValue: "saveCategory_Publisher")
    static let saveTransaction_Publisher = Notification.Name(rawValue: "saveTransaction_Publisher")
    static let reloadCategoryTable = Notification.Name(rawValue: "reloadCategoryTable")
    static let updateHomeViewModelManagerHeight = Notification.Name("updateHomeViewModelManagerHeight")
    static let saveEditedTransaction = Notification.Name("saveEditedTransaction")
    static let saveNewTransaction = Notification.Name("saveNewTransaction")
    static let select_subscriber = Notification.Name(rawValue: "select_subscriber")
    static let reloadShowFullBudgetTableModel = Notification.Name("reloadShowFullBudgetTableModel")
    static let reloadAnalytics = Notification.Name("reloadAnalytics")
}

extension UIView{
    func pin(to superView: UIView){
           translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.layoutMarginsGuide.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.layoutMarginsGuide.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.layoutMarginsGuide.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.layoutMarginsGuide.trailingAnchor).isActive = true
       }
    func addToView( _ view : UIView ) {
        view.addSubview(self)
    }
    //width anchor constraints
    func widthAnchor(_ constant : CGFloat){
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    func widthAnchor(_ widthAnchor: NSLayoutDimension, _ constant : CGFloat){
        self.widthAnchor.constraint(equalTo: widthAnchor, constant: constant).isActive = true
    }
    func widthAnchor(_ widthAnchor: NSLayoutDimension,multiplier : CGFloat, _ constant : CGFloat){
        self.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier, constant: constant).isActive = true
    }
    
    
    //height anchor constraints
    func heightAnchor( _ constant : CGFloat){
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    func heightAnchor( _ heightAnchor: NSLayoutDimension, _ constant : CGFloat){
        self.heightAnchor.constraint(equalTo: heightAnchor, constant: constant).isActive = true
    }
    func heightAnchor( _ heightAnchor : NSLayoutDimension, _ multiplier : CGFloat, _ constant : CGFloat){
        self.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier, constant: constant).isActive = true
    }
    
    
    
    //bottom anchor constraints
    func bottomAnchor(_ bottomAnchor : NSLayoutYAxisAnchor, constant : CGFloat){
        self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant).isActive = true
    }
    func bottomAnchor(_ bottomAnchor : NSLayoutYAxisAnchor){
        self.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
    //top anchor constraints
    func topAnchor(_ topAnchor: NSLayoutYAxisAnchor, _ constant : CGFloat){
        self.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
    }
    
    //left anchor constraints
    func leftAnchor(_ leftAnchor: NSLayoutXAxisAnchor, _ constant : CGFloat){
        self.leftAnchor.constraint(equalTo: leftAnchor, constant: constant).isActive = true
    }
    
    //right anchor constraints
    func rightAnchor(_ rightAnchor: NSLayoutXAxisAnchor, _ constant : CGFloat){
        self.rightAnchor.constraint(equalTo: rightAnchor, constant: constant).isActive = true
    }
    
    //center y anchor constraints
    func centerYAnchor (_ centerYanchor : NSLayoutYAxisAnchor, _ constant : CGFloat){
        self.centerYAnchor.constraint(equalTo: centerYanchor, constant: constant).isActive = true
    }

    
}

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}
