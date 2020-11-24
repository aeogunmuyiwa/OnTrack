//
//  AddTransaction_baseCard.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-22.
//

import UIKit
import Combine

class AddTransaction_baseCard: UIView {
    
    var AddTransactionModel :  PassthroughSubject<ViewTransaction, Never>
    var transaction : ViewTransaction?
    var cancellable : Cancellable?

    lazy var Description: UILabel = {
        let Description = UILabel()
        Description.text = "Description"
        Description.font = CustomProperties.shared.basicTestFont
        Description.textColor = CustomProperties.shared.textColour
        Description.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(Description)
        Description.topAnchor(self.layoutMarginsGuide.topAnchor, 0)
        Description.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        return Description
    }()
    
    
    lazy var DescriptionInput: UITextField = {
        let DescriptionInput = UITextField()
        DescriptionInput.borderStyle = .roundedRect
        DescriptionInput.placeholder = "Enter description"
        DescriptionInput.leftViewMode = .always
        DescriptionInput.leftView = UIImageView(image: CustomProperties.shared.categoryImage)
        DescriptionInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        DescriptionInput.backgroundColor = CustomProperties.shared.textColour
        DescriptionInput.textColor = CustomProperties.shared.blackTextColor
        DescriptionInput.font = CustomProperties.shared.basicTexrFieldFont
        self.addSubview(DescriptionInput)
        DescriptionInput.translatesAutoresizingMaskIntoConstraints = true
        DescriptionInput.topAnchor(Description.bottomAnchor, 0)
        DescriptionInput.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        DescriptionInput.rightAnchor(self.layoutMarginsGuide.rightAnchor, 0)
        DescriptionInput.heightAnchor(CustomProperties.shared.textfieldHeight)
        
        return DescriptionInput
    }()
    
    //Mark =: Amount label
    lazy var AmountLabel: UILabel = {
        let AmountLabel = UILabel()
        AmountLabel.text = "Amount"
        AmountLabel.font = CustomProperties.shared.basicTestFont
        AmountLabel.textColor = CustomProperties.shared.textColour
        AmountLabel.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(AmountLabel)
        AmountLabel.topAnchor(DescriptionInput.bottomAnchor, 10)
        AmountLabel.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        return AmountLabel
    }()
    
    //Mark =: Amount input field
    lazy var AmountInput: UITextField = {
        let AmountInput = UITextField()
        AmountInput.keyboardType = .decimalPad
        AmountInput.borderStyle = .roundedRect
        AmountInput.leftViewMode = .always
        AmountInput.leftView = UIImageView(image: CustomProperties.shared.dollarSign)
        AmountInput.placeholder = "Enter amount"
        AmountInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        AmountInput.backgroundColor = CustomProperties.shared.textColour
        AmountInput.textColor = CustomProperties.shared.blackTextColor
        AmountInput.font = CustomProperties.shared.basicTexrFieldFont
        self.addSubview(AmountInput)
        AmountInput.translatesAutoresizingMaskIntoConstraints = true
        AmountInput.topAnchor(AmountLabel.bottomAnchor, 0)
        AmountInput.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        AmountInput.rightAnchor(self.layoutMarginsGuide.rightAnchor, 0)
        AmountInput.heightAnchor(CustomProperties.shared.textfieldHeight)
        return AmountInput
    }()
    
    //mark : datepicker
    lazy var datepicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.timeZone = NSTimeZone.local
        datepicker.backgroundColor = .white
        datepicker.preferredDatePickerStyle = .compact
        //datepicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.addSubview(datepicker)
        datepicker.translatesAutoresizingMaskIntoConstraints = true
        datepicker.topAnchor(AmountInput.bottomAnchor, 20)
        datepicker.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        return datepicker
    }()
    
//    @objc func datePickerValueChanged(_ sender: UIDatePicker){
////        let dateFormatter: DateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
//        preparedatasource(transaction, DescriptionInput.text, amount: Money.init(string: AmountInput.text ?? ""), id: nil, date: datepicker.date.timeIntervalSince1970)
//
//    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        //check if textfield is categoryNameInput or budgetInput , if true , send data to datasource
        if (textField ==  DescriptionInput) || (textField == AmountInput){
            //todo form validation
      
            preparedatasource(transaction, DescriptionInput.text, amount: Money.init(string: AmountInput.text ?? ""), id: nil, date: datepicker.date.timeIntervalSince1970)
        }
    }
    
    //MARK : Initialization
    init(_ AddTransactionModel : PassthroughSubject<ViewTransaction, Never>?,_ datasource : ViewTransaction? ) {
        self.AddTransactionModel = AddTransactionModel!
        self.transaction = datasource
        super.init(frame: .zero)
        setup()
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark : activate views
    func setup(){
        self.backgroundColor = .black
        Description.translatesAutoresizingMaskIntoConstraints = false
        DescriptionInput.translatesAutoresizingMaskIntoConstraints = false
        AmountLabel.translatesAutoresizingMaskIntoConstraints = false
        AmountInput.translatesAutoresizingMaskIntoConstraints = false
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        
       
    }
    
    //mark handle changes in datasource
    
    func preparedatasource ( _ currenttransaction :  ViewTransaction? ,_ description : String?, amount : Money?, id : Double?, date : TimeInterval?){
        //prepare to send data
        if let currenttransaction = currenttransaction{
            transaction = .init(transactionStatus: currenttransaction.transactionStatus, index: currenttransaction.index, transaction: .init(description, amount, id, date))
        }
        if let transaction = transaction {
            AddTransactionModel.send(transaction)
        }
        
    }
    
    func setupUI(){
        transaction.map({item in
            if item.transactionStatus == .edit {
                DispatchQueue.main.async { [weak self] in
                    self?.DescriptionInput.text = self?.transaction?.transaction?.transactionDescription
                    if let date =  self?.transaction?.transaction?.date {
                        self?.datepicker.date = Date(timeIntervalSince1970: date)
                    }
                
                    if let amount = self?.transaction?.transaction?.amount {
                        self?.AmountInput.text = "\(amount)"
                    }}}
        })
    }
    
}
