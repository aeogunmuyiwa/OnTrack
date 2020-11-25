//
//  CustomProperties.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-20.
//

import UIKit

class CustomProperties: NSObject {
    
 
    
    static let shared = CustomProperties()
    
    //default text color
    let textColour = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
    
    let blackTextColor = UIColor.black
    
    //defaulr subtext color
    let subtextColor = UIColor.init(red: 229, green: 229, blue: 229, alpha: 1)
    
    //default view background color
    let viewBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    
    //default animation color
    let animationColor = #colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1)
        //UIColor.init(red: 252, green: 164, blue: 17, alpha: 1)
    
    
    let tintedColorImage = UIImage(named: "plus")?.withRenderingMode(.automatic).withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let dollarSign = UIImage(named: "dollar")?.withRenderingMode(.automatic).withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let categoryImage = UIImage(named: "category")?.withRenderingMode(.automatic).withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    
    //fonts
    
    //basic bold text font
    let basicBoldTextFont = UIFont.boldSystemFont(ofSize: 25)
    
    //base text font
    let basicTestFont = UIFont.preferredFont(forTextStyle: .title2)
    
    //base textfield font
    
    let basicTexrFieldFont = UIFont.preferredFont(forTextStyle: .body)
    
    
    //input field height
    
    let textfieldHeight = CGFloat(50)
    func handleHideKeyboard(view : UIView){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func handleHideKeyboardForscrollableView(view: UIScrollView)  {
        view.keyboardDismissMode = .onDrag
    }
    func handleHideKeyboardGlobal(){
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder),
                        to: nil, from: nil, for: nil)
    }
    
    //decimal rounding scale
    let decimalScale = 2
    
    func roundAmount(_ amount : String) -> Money? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = 3
    
        let roundedAmount = formatter.number(from: amount)
        return roundedAmount?.decimalValue
    }
    
    
   
}
enum TransactionStatus {
    case new
    case edit 
}

struct ViewTransaction{
    let transactionStatus : TransactionStatus
    let index : Int?
    let transaction : OnTractTransaction?
}

enum ErrorMessages  :  LocalizedError{
    
    case InvalidAmount
    case InvalidText
    
    var errorDescription: String? {
        switch self {
        case .InvalidAmount:
            return NSLocalizedString("Invalid amount entered", comment: "")
        case .InvalidText :
            return NSLocalizedString("Invalid text entered", comment: "")
        }
    }
}

