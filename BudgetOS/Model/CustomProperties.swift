//
//  CustomProperties.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-20.
//

import UIKit
import Combine
class CustomProperties: NSObject {
    
 
    
    static let shared = CustomProperties()
    
    //currency
    let curreny = "$"
    //default text color
    let textColour = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
    
    let blackTextColor = UIColor.black
    let whiteTextColor = UIColor.white
    
    //defaulr subtext color
    let subtextColor = UIColor.init(red: 229, green: 229, blue: 229, alpha: 1)
    let lightGray = UIColor.lightGray
    //default view background color
    let viewBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    
    //default animation color
    let animationColor = #colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1)
        //UIColor.init(red: 252, green: 164, blue: 17, alpha: 1)
    
    
    let tintedColorImage = UIImage(named: "plus")?.withRenderingMode(.automatic).withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let dollarSign = UIImage(named: "dollar")?.withRenderingMode(.automatic).withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let categoryImage = UIImage(named: "category")?.withRenderingMode(.automatic).withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let chevronRight = UIImage(systemName: "chevron.right")?.withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let editImage = UIImage(systemName: "pencil")
    // gradient bar colors
    let gradientRed: CGFloat = 255
    var gradientGreen: CGFloat = 255
    var gradientBlue: CGFloat = 255
    var colorRed: CGFloat = 250
    var colorGreen: CGFloat = 186
    var colorBlue: CGFloat = 218
    
    let mainColor = UIColor(red: 250 / 255, green: 186 / 255, blue: 218 / 255, alpha: 1)
    let gradient = UIColor(red: 234 / 255, green: 76 / 255, blue: 70 / 255, alpha: 1)
    
    //fonts
    
    //basicTextfontStandard
    let basicTextfontStandard = UIFont.boldSystemFont(ofSize: 16)
    
    let basicTextfrontSubtext = UIFont.systemFont(ofSize: 12)
    //basic bold text font
    let basicBoldTextFont = UIFont.boldSystemFont(ofSize: 25)
    
    //base text font
    let basicTextFont = UIFont.preferredFont(forTextStyle: .title2)
    
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
    func displayMoney (_ amount : NSDecimalNumber) -> String {
        if amount.compare(NSDecimalNumber.zero) == .orderedAscending  {
            let negativeValue = NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true)
            let value = amount.multiplying(by: negativeValue)
            return "-\(curreny)\(value)"
        }
        return "\(curreny)\(amount)"
    }
    
    func determineOverLeft(_ amount : NSDecimalNumber) -> Future <String , Never>{
        return Future() { [weak self]promise in
            if amount.compare(NSDecimalNumber.zero) == .orderedAscending  {
                let negativeValue = NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true)
                let value = amount.multiplying(by: negativeValue)
                if let current = self?.curreny {
                    let result = "-\(current)\(value) Over"
                    promise(.success(result))
                }
                
            }
            if let current = self?.curreny {
                let result = "\(current)\(amount) Left"
                promise(.success(result))
            }
           
        }
    }
    
    func navigationControllerProperties(ViewController : UIViewController?, title : String){
        ViewController?.view.backgroundColor = CustomProperties.shared.viewBackgroundColor
        ViewController?.navigationController?.navigationBar.prefersLargeTitles = true
        ViewController?.navigationItem.title = title
        ViewController?.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomProperties.shared.textColour]

    }
    lazy var dateFormatter : DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

    
    
   
}
enum TransactionStatus {
    case new
    case edit 
}

struct ViewTransaction{
    let transactionStatus : TransactionStatus
    let index : Int?
    let transaction : Transaction?
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
enum dataBaseErrors : LocalizedError {
    case ErrorLoadingDatabase
    var errorDescription: String? {
        switch self {
        case .ErrorLoadingDatabase :
            return NSLocalizedString("Error loading data", comment: "")
        }
    }
}

