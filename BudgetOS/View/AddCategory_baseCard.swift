//
//  AddCategory_baseCard.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-20.
//

import UIKit
import Combine

struct tester {
    let test : String
}

class AddCategory_baseCard: UIView {
    // AddCategoryModel publisher
    var AddCategoryModel :  PassthroughSubject<CategoryStruct, Never>
    var data : CategoryStruct = .init("", 0, nil)
    

    lazy var categoryName: UILabel = {
        let categoryName = UILabel()
        categoryName.text = "Category"
        categoryName.font = CustomProperties.shared.basicTestFont
        categoryName.textColor = CustomProperties.shared.textColour
        categoryName.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(categoryName)
        categoryName.topAnchor(self.layoutMarginsGuide.topAnchor, 0)
        categoryName.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        return categoryName
    }()
    
    lazy var categoryNameInput: UITextField = {
        let categoryNameInput = UITextField()
        categoryNameInput.borderStyle = .roundedRect
        categoryNameInput.placeholder = "Enter category"
        categoryNameInput.leftViewMode = .always
        categoryNameInput.leftView = UIImageView(image: CustomProperties.shared.categoryImage)
        categoryNameInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        categoryNameInput.backgroundColor = CustomProperties.shared.textColour
        categoryNameInput.textColor = CustomProperties.shared.blackTextColor
        categoryNameInput.font = CustomProperties.shared.basicTexrFieldFont
        self.addSubview(categoryNameInput)
        categoryNameInput.translatesAutoresizingMaskIntoConstraints = true
        categoryNameInput.topAnchor(categoryName.bottomAnchor, 0)
        categoryNameInput.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        categoryNameInput.rightAnchor(self.layoutMarginsGuide.rightAnchor, 0)
        categoryNameInput.heightAnchor(CustomProperties.shared.textfieldHeight)
        
        return categoryNameInput
    }()
    
    
    //Mark =: budget label
    lazy var budgeLabel: UILabel = {
        let budgeLabel = UILabel()
        budgeLabel.text = "Budget"
        budgeLabel.font = CustomProperties.shared.basicTestFont
        budgeLabel.textColor = CustomProperties.shared.textColour
        budgeLabel.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(budgeLabel)
        budgeLabel.topAnchor(categoryNameInput.bottomAnchor, 0)
        budgeLabel.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        return budgeLabel
    }()
    
    //Mark =: budget input field
    lazy var budgetInput: UITextField = {
        let budgetInput = UITextField()
        budgetInput.keyboardType = .decimalPad
        budgetInput.borderStyle = .roundedRect
        budgetInput.leftViewMode = .always
        budgetInput.leftView = UIImageView(image: CustomProperties.shared.dollarSign)
        budgetInput.placeholder = "Enter budget"
        budgetInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        budgetInput.backgroundColor = CustomProperties.shared.textColour
        budgetInput.textColor = CustomProperties.shared.blackTextColor
        budgetInput.font = CustomProperties.shared.basicTexrFieldFont
        self.addSubview(budgetInput)
        budgetInput.translatesAutoresizingMaskIntoConstraints = true
        budgetInput.topAnchor(budgeLabel.bottomAnchor, 0)
        budgetInput.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        budgetInput.rightAnchor(self.layoutMarginsGuide.rightAnchor, 0)
        budgetInput.heightAnchor(CustomProperties.shared.textfieldHeight)
        return budgetInput
    }()
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //check if textfield is categoryNameInput or budgetInput , if true , send data to datasource
        if (textField ==  categoryNameInput) || (textField == budgetInput){
            //todo form validation
            prepareDatasource(categoryNameInput.text ?? "", Money.init(string: budgetInput.text ?? "") ?? 0 , nil)
            
        }
    }
    
    //addCategoryButton actionn: send data when completed
    func prepareDatasource( _ category  : String , _ budget : Money , _ transactions : [Transaction]?){
        data.category = category
        data.budget = budget
        data.transactions = transactions
        AddCategoryModel.send(data)
    }
    
    //MARK : Initialization
    init(AddCategoryModel : PassthroughSubject<CategoryStruct, Never>?) {
        self.AddCategoryModel = AddCategoryModel!
        super.init(frame: .zero)
        setup()
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // activate views
    func setup(){
        self.layer.cornerRadius = 10
        self.backgroundColor = CustomProperties.shared.animationColor
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        categoryNameInput.translatesAutoresizingMaskIntoConstraints = false
        budgeLabel.translatesAutoresizingMaskIntoConstraints = false
        budgetInput.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateUI(_ datasource : CategoryStruct){

        budgetInput.text = "\(datasource.budget)"
       
        categoryNameInput.text = datasource.category
       
    }
}
