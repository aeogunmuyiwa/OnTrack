//
//  AddTransactionModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-22.
//

import UIKit
import Combine

class AddTransactionModel: NSObject {
    
    //todo add error handling
    var viewController : UIViewController
    private var TransactionStruct_subscriber : AnyCancellable?
    
    var datasource : ViewTransaction?
    private lazy var TransactionStruct_publisher = PassthroughSubject<ViewTransaction?, Never>()
    lazy var CategoryStruct_publisherAction = TransactionStruct_publisher.eraseToAnyPublisher()
    
    
    lazy var addTransaction_baseCard: AddTransaction_baseCardView = {
        let addTransaction_baseCard = AddTransaction_baseCardView(TransactionStruct_publisher, datasource, viewController)
        viewController.view.addSubview(addTransaction_baseCard)
        addTransaction_baseCard.pin(to: viewController.view)
        return addTransaction_baseCard
    }()
    
   
    
    init(_ viewController : UIViewController, _ dataSource : ViewTransaction? ) {
        self.viewController = viewController
        self.datasource = dataSource
        super.init()
        self.addTransaction_baseCard.translatesAutoresizingMaskIntoConstraints = false
        setupNavigationController()
        handlePublisherSubscriber()
        CustomProperties.shared.handleHideKeyboard(view: addTransaction_baseCard)
    }
    
    //MARK : SETUP navigation controller buttons
    func setupNavigationController(){
        
        datasource.map({item in
            if (item.transactionStatus == .edit){
                self.viewController.navigationItem.title = "Edit Transaction"
            }else if (item.transactionStatus == .new){
                self.viewController.navigationItem.title = "New Transaction"
            }else if (item.transactionStatus == .addTransaction){
                self.viewController.navigationItem.title = "New Transaction"
            }else {
                self.viewController.navigationItem.title = "Edit Transaction"
            }
        })
        self.viewController.navigationController?.navigationBar.prefersLargeTitles = true
     
        self.viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomProperties.shared.textColour]
        //set rightBarButtonItem to save action and disable button
       
        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTransaction))
        self.viewController.navigationItem.rightBarButtonItem = rightButton
        
        self.viewController.navigationItem.rightBarButtonItem?.isEnabled = false
        self.viewController.navigationItem.rightBarButtonItem?.tintColor = .black
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(dismissView))
        self.viewController.navigationItem.leftBarButtonItem = backButton
        self.viewController.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func dismissView() {
       
        viewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK: dispatch data to saveCategory_Publisher
    @objc func saveTransaction(){
        saveNewTransaction()
        
    }
    
    
    //MARK: handle publisher envents and set datasource
    func handlePublisherSubscriber(){
        TransactionStruct_subscriber = CategoryStruct_publisherAction
            .sink(receiveValue: { [weak self] (receiveValue) in
                if let receivedValue = receiveValue {
                    self?.datasource = receivedValue
                    self?.viewController.navigationItem.rightBarButtonItem?.isEnabled = true
                }else{
                    self?.viewController.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            })
    }
    
 

    
    func saveNewTransaction(){
        if let datasource = datasource {
            if datasource.transactionStatus == .editSaved {
                   // DatabaseManager.shared.updateTransaction(datasource)
                NotificationCenter.default.post(name: .saveEditedTransaction, object: datasource)
            }else if (datasource.transactionStatus == .addTransaction){
                NotificationCenter.default.post(name: .saveNewTransaction, object: datasource)
            }else{
                NotificationCenter.default.post(name: .saveTransaction_Publisher, object: datasource)
            }
          
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
