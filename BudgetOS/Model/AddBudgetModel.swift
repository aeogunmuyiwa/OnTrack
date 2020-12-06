//
//  AddCategoryModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-20.
//

import UIKit
import Combine

class AddBudgetModel: NSObject {
    //managed controoler
    let AddCategory = "AddCategory_TableViewCell"
    let cellId = "TransactionsTableViewCell"
    var viewController : UIViewController
    private var saveTransactionSubscriber: AnyCancellable?
    private var saveCategorySubscriber : AnyCancellable?
 
    lazy var CategoryDatasoruce : CategoryStruct = {
        let CategoryDatasoruce = CategoryStruct("", .none)
        return CategoryDatasoruce
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(TransactionsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(AddCategory_TableViewCell.self, forCellReuseIdentifier: AddCategory)
        viewController.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = true
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.pin(to: viewController.view)

        return tableView
    }()
    
    
    
    init(_ viewController : UIViewController) {
        self.viewController = viewController
        super.init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setupNavigationController()
        handleCategorySavePublisher()
        handleTransactionSavePublisher()
     
        CustomProperties.shared.handleHideKeyboard(view: viewController.view)
        CustomProperties.shared.handleHideKeyboardForscrollableView(view: tableView)
      
    }
   
    
    //MARK : SETUP navigation controller buttons
    func setupNavigationController(){
        self.viewController.navigationController?.navigationBar.prefersLargeTitles = true
        self.viewController.navigationItem.title = "New Category"
        self.viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomProperties.shared.textColour]
        
        //set rightBarButtonItem to save action and disable button
        self.viewController.navigationItem.rightBarButtonItem = .init(title: "Save", style: .plain, target: self, action: #selector(saveCategory))
        self.viewController.navigationItem.rightBarButtonItem?.isEnabled = false
        self.viewController.navigationItem.rightBarButtonItem?.tintColor = CustomProperties.shared.animationColor
        
        //self.viewController.navigationItem.leftBarButtonItem = .init(title: "back", style: .plain, target: self, action: #selector(navigateBack))
        
    }
    
    
    
    //Mark : Navigate to previous view
    
    @objc func navigateBack(){
        self.viewController.navigationController?.popToRootViewController(animated: true)
    }

   // handle publisher envents and set datasource
    func handleCategorySavePublisher(){
        let savePublisher = NotificationCenter.Publisher.init(center: .default, name: .saveCategory_Publisher)
        saveCategorySubscriber = savePublisher.sink(receiveValue: { [weak self] result in
            if let data = result.object as? CategoryStruct {
                self?.CategoryDatasoruce.category = data.category
                self?.CategoryDatasoruce.budget = data.budget
            }
        })
    }
    
    //Mark handle save publisher
    func handleTransactionSavePublisher(){
        let savePubisher = NotificationCenter.Publisher.init(center: .default, name: .saveTransaction_Publisher)
        saveTransactionSubscriber = savePubisher.sink(receiveValue: {[weak self]result in
            if let data = result.object as? ViewTransaction{
               
                if data.transactionStatus == .edit{
                    self?.editTransaction(data)
                }
                if data.transactionStatus == .new {
                    self?.saveNewTransaction(data)
                }
                self?.tableView.reloadData()
            }
        })
    }
    
    //Mark : save new transaction ()
    
    func saveNewTransaction(_ data : ViewTransaction ){
        data.transaction?.categoryId = CategoryDatasoruce.id
        if let transaction = data.transaction{
            CategoryDatasoruce.transactions?.append(transaction)
        }
    }
    //Mark : function for updating edited transactions
    func editTransaction(_ data : ViewTransaction){
        if let index = data.index , let transaction = data.transaction{
            CategoryDatasoruce.transactions?[index] = transaction
        }
       
    }
    
    //MARK : SAVE CATEGORY STRUCT "DATASOURCE
    @objc func saveCategory(){
        DatabaseManager.shared.CategorySave(self.CategoryDatasoruce)
        NotificationCenter.default.post(name: .reloadCategoryTable, object: nil)
        self.viewController.navigationController?.popViewController(animated: true)
        //self.viewController.navigationController?.popToRootViewController(animated: true)
    }
}

extension AddBudgetModel : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            //return datasource.transactions?.count ?? 00
            
            guard let data = CategoryDatasoruce.transactions?.count else { return 0 }
            CustomProperties.shared.emptyDatasource(data: data, tableView: tableView, title: "You do not have any transactions yet", message: "Click the plus icon '+' to add a new transaction", textColor: CustomProperties.shared.whiteTextColor)
            return data
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddCategory, for: indexPath) as! AddCategory_TableViewCell
            cell.setup(viewController)
            cell.selectionStyle = .none
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TransactionsTableViewCell
            //cell.data = datasource.transactions?[indexPath.row]
            let transactions = CategoryDatasoruce.transactions?[indexPath.row]
            cell.data = transactions
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let transactions = CategoryDatasoruce.transactions?[indexPath.row]
            Viewtransaction(datasource: .init(transactionStatus: .edit, index: indexPath.row, transaction: transactions))
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  300
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        }
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualAction(forRowAt: indexPath)])
    }
    
    //MARK: - Contextual Actions
       private func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
           return UIContextualAction(style: .destructive, title: "Delete") { (action, swipeButtonView, completion) in
            self.CategoryDatasoruce.transactions?.remove(at: indexPath.row)
            self.tableView.reloadData()
           }
       }
    
    
    //Mark: transition to addTransaction controller
     func Viewtransaction(datasource : ViewTransaction? ){
        let vc = AddTransactionViewController()
        vc.dataSource = datasource
        let navbar: UINavigationController = UINavigationController(rootViewController: vc)
        navbar.navigationBar.backgroundColor = CustomProperties.shared.animationColor
        viewController.present(navbar, animated: true, completion: nil)
    }
}
