//
//  AddTransaction_baseCard.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-22.
//

import UIKit
import Combine

class AddTransaction_baseCardView: UIView {
    
    var AddTransactionModel :  PassthroughSubject<ViewTransaction?, Never>
    var transaction : ViewTransaction?
    var cancellable : Cancellable?
    weak var controller : UIViewController?
    private var select_subscriber : AnyCancellable?
    
    lazy var Description: UILabel = {
        let Description = UILabel()
        Description.text = "Description"
        Description.font = CustomProperties.shared.basicTextFont
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
        DescriptionInput.attributedPlaceholder = NSAttributedString(string: "Enter transaction", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
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
        AmountLabel.font = CustomProperties.shared.basicTextFont
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
        AmountInput.attributedPlaceholder = NSAttributedString(string: "Enter transaction amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
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
        self.addSubview(datepicker)
        datepicker.translatesAutoresizingMaskIntoConstraints = true
        datepicker.topAnchor(AmountInput.bottomAnchor, 20)
        datepicker.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        datepicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datepicker
    }()
    
    lazy var SelectCategory: selectCategory = {
        let SelectCategory = selectCategory()
        SelectCategory.controller =  controller
        self.addSubview(SelectCategory)
        SelectCategory.translatesAutoresizingMaskIntoConstraints = true
        SelectCategory.topAnchor(datepicker.bottomAnchor, 20)
        SelectCategory.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        SelectCategory.heightAnchor(60)
        SelectCategory.rightAnchor(self.layoutMarginsGuide.rightAnchor, 0)
        SelectCategory.backgroundColor = CustomProperties.shared.animationColor
        SelectCategory.layer.cornerRadius = 10
        SelectCategory.isHidden = true
        
        return SelectCategory
    }()
    
        @objc func datePickerValueChanged(_ sender: UIDatePicker){
    //        let dateFormatter: DateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
            
            _ =  FormValidations.shared.ValidateTransaction(Money.init(string: AmountInput.text ?? ""), DescriptionInput.text, invalidAmount: { errorMessage in
                  self.AddTransactionModel.send(nil)
              }, invalidText: { errorMessage in
                  self.AddTransactionModel.send(nil)
              }).sink(receiveValue: { [weak self] value in
                  self?.preparedatasource(self?.transaction, value.1, amount: value.0, id: .zero, date: self?.datepicker.date.timeIntervalSince1970)
              })
        }
    

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //check if textfield is categoryNameInput or budgetInput , if true , send data to datasource
        if (textField ==  DescriptionInput) || (textField == AmountInput){
            //todo form validation: make robost
          _ =  FormValidations.shared.ValidateTransaction(Money.init(string: AmountInput.text ?? ""), DescriptionInput.text, invalidAmount: { errorMessage in
                self.AddTransactionModel.send(nil)
            }, invalidText: { errorMessage in
                self.AddTransactionModel.send(nil)
            }).sink(receiveValue: { [weak self] value in
                self?.preparedatasource(self?.transaction, value.1, amount: value.0, id: .zero, date: self?.datepicker.date.timeIntervalSince1970)
            })
           
        }
    }
    
    func handleSelectCategorySubscriber (){
        let selectCategoryPublisher =  NotificationCenter.Publisher.init(center: .default, name: .select_subscriber)
        select_subscriber = selectCategoryPublisher.sink(receiveValue: { [weak self] result in
            if let value = result.object as? Category {
                self?.SelectCategory.categoryData.text = value.categoryDescription
            }
        })
    }
    
    //MARK : Initialization
    init(_ AddTransactionModel : PassthroughSubject<ViewTransaction?, Never>?,_ datasource : ViewTransaction?, _ controller : UIViewController ) {
        self.AddTransactionModel = AddTransactionModel!
        self.transaction = datasource
        self.controller = controller
        super.init(frame: .zero)
        setup()
        setupUI()
        handleSelectCategorySubscriber()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        SelectCategory.isUserInteractionEnabled = true
        SelectCategory.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //let tappedImage = tapGestureRecognizer.view as! 
        // And some actions
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
        SelectCategory.translatesAutoresizingMaskIntoConstraints = false
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
            
            if item.transactionStatus == .editSaved{
                DispatchQueue.main.async { [weak self] in
                    self?.DescriptionInput.text = self?.transaction?.onTransaction?.transactionDescription
                    if let date =  self?.transaction?.onTransaction?.date {
                        self?.datepicker.date = Date(timeIntervalSince1970: date)
                    }
                    if let amount = self?.transaction?.onTransaction?.amount {
                        self?.AmountInput.text = "\(amount)"
                    }}
            }
            if item.transactionStatus == .addTransaction {
                SelectCategory.isHidden = false
            }
        })
    }
    
}
