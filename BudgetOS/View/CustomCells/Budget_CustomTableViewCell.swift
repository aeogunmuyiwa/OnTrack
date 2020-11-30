//
//  Budget_CustomTableViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-26.
//

import UIKit

class Budget_CustomTableViewCell: UITableViewCell {
    weak var ViewController : UIViewController?
    var index : Int?
    private lazy var BudgetName : UILabel = {
        let budgetName = UILabel()
        budgetName.textColor = CustomProperties.shared.blackTextColor
        budgetName.font = CustomProperties.shared.basicTextfontStandard
        contentView.addSubview(budgetName)
        budgetName.translatesAutoresizingMaskIntoConstraints = true
        budgetName.topAnchor(contentView.topAnchor, 0)
        budgetName.leftAnchor(contentView.leftAnchor, 0)
        return budgetName
    }()
    
    private lazy var difference : UILabel = {
        let difference = UILabel()
        difference.textColor = CustomProperties.shared.blackTextColor
        difference.font = CustomProperties.shared.basicTextfontStandard
        contentView.addSubview(difference)
        difference.translatesAutoresizingMaskIntoConstraints = true
        difference.topAnchor(contentView.topAnchor, 0)
        difference.rightAnchor(edit.leftAnchor, -10)
        
        return difference
    }()
    
    private lazy var edit : UIButton = {
        let edit = UIButton()
        edit.setImage(CustomProperties.shared.editImage, for: .normal)
        edit.addTarget(self, action: #selector(editBudget), for: .touchUpInside)
        edit.translatesAutoresizingMaskIntoConstraints = false
        edit.tintColor = CustomProperties.shared.animationColor
        contentView.addSubview(edit)
        edit.centerYAnchor(contentView.centerYAnchor, 0)
        edit.rightAnchor(contentView.rightAnchor, 0)
        edit.widthAnchor(20)
        
        return edit
    }()
    
    
    
    lazy var gradientHorizontalBar: GradientHorizontalProgressBar? = {
        let gradientHorizontalBar = GradientHorizontalProgressBar()
        gradientHorizontalBar.color =  CustomProperties.shared.animationColor
        contentView.addSubview(gradientHorizontalBar)
        gradientHorizontalBar.translatesAutoresizingMaskIntoConstraints = true
        gradientHorizontalBar.leftAnchor(contentView.leftAnchor, 0)
        gradientHorizontalBar.rightAnchor(edit.leftAnchor, -10)
        gradientHorizontalBar.bottomAnchor(contentView.bottomAnchor)
        gradientHorizontalBar.heightAnchor(20)
        return gradientHorizontalBar
    }()
    private lazy var overtextDisplay : UILabel = {
        let overtextDisplay = UILabel()
        overtextDisplay.textColor = CustomProperties.shared.whiteTextColor
        overtextDisplay.font = CustomProperties.shared.basicTextfontStandard
        gradientHorizontalBar?.addSubview(overtextDisplay)
        gradientHorizontalBar?.bringSubviewToFront(overtextDisplay)
        overtextDisplay.translatesAutoresizingMaskIntoConstraints = true
        if let gradientHorizontalBar = gradientHorizontalBar {
            overtextDisplay.centerYAnchor(gradientHorizontalBar.centerYAnchor, 0)
            overtextDisplay.leftAnchor(gradientHorizontalBar.leftAnchor, 20)
        }
        return overtextDisplay
    }()
    var data : Category? {
        didSet {
            //set data
            BudgetName.text = data?.categoryDescription
            if let difference_data = data?.difference {
              _ = CustomProperties.shared.determineOverLeft(difference_data).sink(receiveValue: { value in
                    self.difference.text = value
                })
            }
            overtextDisplay.text = "\(CustomProperties.shared.displayMoney(data?.actual ?? 0)) of \(CustomProperties.shared.displayMoney(data?.budget ?? 0))"
            gradientHorizontalBar?.progress = normalize(data?.actual, data?.budget)
        }
    }
    
    func setUp(_ viewController : UIViewController, textColor : UIColor ){
        self.ViewController = viewController
        difference.textColor = textColor
        BudgetName.textColor = textColor
    }
    @objc func editBudget(){
        var budgetField: UITextField?
        var AmountField: UITextField?
        AmountField?.keyboardType = .decimalPad
        
        let alert = UIAlertController(title: "Edit Budget", message: "Enter new budget name and amount", preferredStyle: .alert)
        
        let SaveAction = UIAlertAction(title: "Save", style: .default) { (login) in
            if let budgetName = budgetField?.text, let amount = AmountField?.text {
                ///self.data?.categoryDescription = budgetName
                if let data = self.data {
                    DatabaseManager.shared.updateBudget(data, budgetName, Money.init(string: amount) ?? 0)
                }
               
            }
        }
        SaveAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let textFieldValidator : (Notification) -> Void = { object in
            if let field_1 = object.object as? UITextField {
                if field_1 == budgetField {
                   _ =  FormValidations.shared.validateText(text: field_1.text).sink(receiveCompletion: {error in
                    switch error {
                    case .finished:()
                    case .failure(.InvalidText): SaveAction.isEnabled = false
                    case .failure(.InvalidAmount):()
                    }
                   }, receiveValue: {value in
                    SaveAction.isEnabled = true
                    })
                }
                
                if field_1 == AmountField {
                    if let amount = field_1.text {
                        _ = FormValidations.shared.validateAmount(amount: Money.init(string: amount), errorMessage: .InvalidAmount).sink(receiveCompletion: {error in
                            switch error {
                            case .finished:()
                            case .failure(.InvalidAmount):SaveAction.isEnabled = false
                            case .failure(.InvalidText): ()
                            }
                        }, receiveValue: {value in
                            SaveAction.isEnabled = true
                        })
                    }
                    
                }
            }
            
        }

        
        alert.addTextField { (BudgetTextField) in
            budgetField = BudgetTextField
            budgetField?.text = self.data?.categoryDescription
            budgetField?.placeholder = "Enter the new budget name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: budgetField, queue: .main, using: textFieldValidator)
        }
        
        alert.addTextField { (AmountTextField) in
            AmountField = AmountTextField
            AmountField?.keyboardType = .decimalPad
            if let budget = self.data?.budget {
                AmountField?.text = "\(budget)"
            }
           
            AmountField?.placeholder = "Enter the new amount"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: AmountField, queue: .main, using: textFieldValidator)
        }
        
        
        
        alert.addAction(cancelAction)
        alert.addAction(SaveAction)
        
        ViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    func normalize( _ actual : NSDecimalNumber?, _ budget : NSDecimalNumber?) -> CGFloat{
        if let actual = actual , let budget = budget {
            if budget.doubleValue != 0 {
                return  CGFloat(actual.doubleValue /  budget.doubleValue)
            }
        }
        return 0
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        BudgetName.translatesAutoresizingMaskIntoConstraints = false
        difference.translatesAutoresizingMaskIntoConstraints = false
        gradientHorizontalBar?.translatesAutoresizingMaskIntoConstraints = false
        edit.translatesAutoresizingMaskIntoConstraints = false
        overtextDisplay.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.bounds = contentView.bounds.inset(by: margins)
        //contentView.frame = contentView.frame.inset(by: margins)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

