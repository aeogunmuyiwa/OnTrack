//
//  AllBudgetView.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-01.
//

import UIKit

class AllBudgetView: UIView {
    lazy var Description: UILabel = {
        let Description = UILabel()
        Description.text = "Budget"
        Description.font = CustomProperties.shared.basicTextFont
        Description.textColor = CustomProperties.shared.textColour
        Description.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(Description)
        Description.topAnchor(self.layoutMarginsGuide.topAnchor, 0)
        Description.leftAnchor(self.leftAnchor, 0)
        return Description
    }()
 
    lazy var DescriptionInput: UITextField = {
        let DescriptionInput = UITextField()
        DescriptionInput.borderStyle = .bezel
        DescriptionInput.attributedPlaceholder = NSAttributedString(string: "Enter transaction", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        DescriptionInput.isEnabled = false
        //DescriptionInput.leftViewMode = .always
        //DescriptionInput.leftView = UIImageView(image: CustomProperties.shared.categoryImage)
       // DescriptionInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        DescriptionInput.backgroundColor = CustomProperties.shared.textColour
        DescriptionInput.textColor = CustomProperties.shared.blackTextColor
        DescriptionInput.font = CustomProperties.shared.basicTexrFieldFont
        self.addSubview(DescriptionInput)
        DescriptionInput.translatesAutoresizingMaskIntoConstraints = true
        DescriptionInput.topAnchor(Description.bottomAnchor, 0)
        DescriptionInput.leftAnchor(self.leftAnchor, 0)
        DescriptionInput.rightAnchor(self.rightAnchor, 0)
        DescriptionInput.heightAnchor(CustomProperties.shared.textfieldHeight)
        
        return DescriptionInput
    }()
    
    //Mark =: Amount label
    lazy var AmountLabel: UILabel = {
        let AmountLabel = UILabel()
        AmountLabel.text = "Amount"
        AmountLabel.font = CustomProperties.shared.basicTextFont
        AmountLabel.textColor = CustomProperties.shared.textColour
        AmountLabel.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(AmountLabel)
        AmountLabel.topAnchor(DescriptionInput.bottomAnchor, 10)
        AmountLabel.leftAnchor(self.leftAnchor, 0)
        return AmountLabel
    }()
    
    //Mark =: Amount input field
    lazy var AmountInput: UITextField = {
        let AmountInput = UITextField()
        AmountInput.keyboardType = .decimalPad
        AmountInput.borderStyle = .bezel
        AmountInput.leftViewMode = .always
        AmountInput.isEnabled = false
        AmountInput.leftView = UIImageView(image: CustomProperties.shared.dollarSign)
        AmountInput.placeholder = "Enter amount"
        AmountInput.attributedPlaceholder = NSAttributedString(string: "Enter transaction amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
       // AmountInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        AmountInput.backgroundColor = CustomProperties.shared.textColour
        AmountInput.textColor = CustomProperties.shared.blackTextColor
        AmountInput.font = CustomProperties.shared.basicTexrFieldFont
        self.addSubview(AmountInput)
        AmountInput.translatesAutoresizingMaskIntoConstraints = true
        AmountInput.topAnchor(AmountLabel.bottomAnchor, 0)
        AmountInput.leftAnchor(self.leftAnchor, 0)
        AmountInput.rightAnchor(self.rightAnchor, 0)
        AmountInput.heightAnchor(CustomProperties.shared.textfieldHeight)
        return AmountInput
    }()

    
    var data : Category? {
        didSet {
            //set data
            DescriptionInput.text = data?.categoryDescription
            if let budget = data?.budget{
                AmountInput.text = "\(budget)"
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        activateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateView(){
        Description.translatesAutoresizingMaskIntoConstraints = false
        DescriptionInput.translatesAutoresizingMaskIntoConstraints = false
        AmountLabel.translatesAutoresizingMaskIntoConstraints = false
        AmountInput.translatesAutoresizingMaskIntoConstraints = false
       // gradientHorizontalBar?.translatesAutoresizingMaskIntoConstraints = false
        //difference.translatesAutoresizingMaskIntoConstraints = false
       // overtextDisplay.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
