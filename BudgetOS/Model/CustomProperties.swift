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
    let trashImage = UIImage(systemName: "trash")?.withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let dollarSign = UIImage(named: "dollar")?.withRenderingMode(.automatic).withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let categoryImage = UIImage(named: "category")?.withRenderingMode(.automatic).withTintColor(#colorLiteral(red: 0.9882352941, green: 0.6392156863, blue: 0.06666666667, alpha: 1))
    
    let categoryImagePlain = UIImage(named: "category")
    
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
    
    //buttom image confir
    let config = UIImage.SymbolConfiguration(pointSize: 30)
    
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
    
    //Mark : normalizing to 0-1
    func normalize( _ actual : NSDecimalNumber?, _ budget : NSDecimalNumber?) -> CGFloat{
        if let actual = actual , let budget = budget {
            if budget.doubleValue != 0 {
                return  CGFloat(actual.doubleValue /  budget.doubleValue)
            }
        }
        return 0
    }
    
    //Mark : navigation controller title setter
    func navigationControllerProperties(ViewController : UIViewController?, title : String){
        ViewController?.view.backgroundColor = CustomProperties.shared.viewBackgroundColor
        ViewController?.navigationController?.navigationBar.tintColor = CustomProperties.shared.animationColor
        ViewController?.navigationController?.navigationBar.prefersLargeTitles = true
        ViewController?.navigationItem.title = title
        ViewController?.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomProperties.shared.textColour]

    }
    
    //Mark changecell selected BackgroundView
    
    lazy var cellBackgroundView: UIView = {
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = CustomProperties.shared.animationColor
        return cellBackgroundView
    }()
    
    //Mark shared date formatter
    lazy var dateFormatter : DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
       // dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

    //MARK : Helper navigation function
    func navigateToController( to : UIViewController , from  : UIViewController){
        from.navigationController?.pushViewController(to, animated: true)
    }
    
    func checkdate(date : Date) -> Int? {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday
    }
    
    //Mark : convert components.weekday to sunday = 1
    func convertDatetoDAY(day : Int) -> String {
        if day == 1 {return "Sunday"}
        if day == 2 {return "Monday"}
        if day == 3 {return "Tueday"}
        if day == 4 {return "Wednesday"}
        if day == 5 {return "Thurday"}
        if day == 6 {return "Friday"}
        else {return "Saturday"}
    }
   
    func convertDatetoDAY(day : Int , sunday : @escaping() -> Void , monday : @escaping() -> Void,
                          tueday : @escaping() -> Void, wedneday : @escaping() -> Void,thursday : @escaping() -> Void, friday : @escaping() -> Void,saturday : @escaping() -> Void)  {
        if day == 1 {sunday()}
        else if day == 2 {monday()}
        else if day == 3 {tueday()}
        else if day == 4 {wedneday()}
        else if day == 5 {thursday()}
        else if day == 6 {friday()}
        else {saturday()}
    }
    
    
    //Mark placeholder attribute
}


enum TransactionStatus {
    case new
    case edit
    case editSaved
    case addTransaction
}

struct ViewTransaction{
    let transactionStatus : TransactionStatus
    let index : Int?
    let transaction : Transaction?
    var onTransaction : OnTractTransaction? = nil
    var category : Category? = nil
    
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

