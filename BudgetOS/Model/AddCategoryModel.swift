//
//  AddCategoryModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-20.
//

import UIKit
import Combine

class AddCategoryModel: NSObject {
    //managed controoler
    let AddCategory = "AddCategory_TableViewCell"
    let cellId = "TransactionsTableViewCell"
    var viewController : UIViewController
    private var saveTransactionSubscriber: AnyCancellable?
    private var saveCategorySubscriber : AnyCancellable?
    var datasource : CategoryStruct = .init(nil, nil)
    var CategoryDatasoruce = Category(context: DatabaseManager.shared.viewContext)
    
    
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
        setupNavigationController()
        handleCategorySavePublisher()
        handleTransactionSavePublisher()
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        
    }
    

   // handle publisher envents and set datasource
    func handleCategorySavePublisher(){
        let savePublisher = NotificationCenter.Publisher.init(center: .default, name: .saveCategory_Publisher)
        saveCategorySubscriber = savePublisher.sink(receiveValue: { [weak self] result in
            if let data = result.object as? CategoryStruct {
                self?.datasource.category = data.category
                self?.datasource.budget = data.budget
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
        data.transaction?.categoryId = self.datasource.id
        if let transaction = data.transaction {
            self.datasource.transactions?.append(transaction)
            
        }
    }
    //Mark : function for updating edited transactions
    func editTransaction(_ data : ViewTransaction){
        if let index = data.index , let transaction = data.transaction {
            datasource.transactions?[index] = transaction
        }
       
    }
    
    //MARK : SAVE CATEGORY STRUCT "DATASOURCE
    @objc func saveCategory(){
       dump(datasource)
       
    }
    

}

extension AddCategoryModel : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return datasource.transactions?.count ?? 00
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddCategory, for: indexPath) as! AddCategory_TableViewCell
            cell.setup(viewController, datasource: datasource)
            cell.selectionStyle = .none
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TransactionsTableViewCell
            cell.data = datasource.transactions?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Viewtransaction(datasource: .init(transactionStatus: .edit, index: indexPath.row, transaction: datasource.transactions?[indexPath.row]))
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
           return UIContextualAction(style: .destructive, title: "Delete") {[weak self] (action, swipeButtonView, completion) in
            self?.datasource.transactions?.remove(at: indexPath.row)
            self?.tableView.reloadData()
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
