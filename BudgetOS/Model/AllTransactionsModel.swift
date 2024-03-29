//
//  AllTransactionsModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-27.
//

import UIKit
import CoreData
import Combine
enum AllTransactionsModelState {
    case showFullBudgetTableModel
    case base
}
class AllTransactionsModel: NSObject {
    private weak var ViewController : UIViewController?
    var data : [OnTractTransaction]?
    let cellId = "AllTransactionsModel"
    private var saveEditedTransactionSubscriber: AnyCancellable?
    private var saveNewTransactionSubscriber: AnyCancellable?
    private var select_subscriber : AnyCancellable?
    var tempCategory : Category?
    var compareCategory : Category?
    var state : AllTransactionsModelState
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(AllTransactionsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        ViewController?.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = true
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.translatesAutoresizingMaskIntoConstraints = true
        if let controller = ViewController {
            tableView.pin(to: controller.view)
        }
        return tableView
    }()
    
    
    init(ViewController : UIViewController, data : [OnTractTransaction], tempCategory : Category?, tableViewEnable : Bool, state : AllTransactionsModelState) {
        self.ViewController = ViewController
        self.data = data
        self.tempCategory = tempCategory
        self.compareCategory = tempCategory
        self.state = state
        super.init()
        self.tableView.isScrollEnabled = tableViewEnable
        handleSaveEditedTransaction()
        handleSaveNewTransaction()
        handleSelectCategorySubscriber()
        activateView()
        CustomProperties.shared.navigationControllerProperties(ViewController: ViewController, title: "All transaction")
        navigationControllerProperties()
        
    }
    

    func activateView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    //Mark handle save publisher
    func handleSaveEditedTransaction(){
        let savePubisher = NotificationCenter.Publisher.init(center: .default, name: .saveEditedTransaction)
        saveEditedTransactionSubscriber = savePubisher.sink(receiveValue: {[weak self]result in
            if let value = result.object as? ViewTransaction, let position = value.index{
                if let data = self?.data?[position] {
                    DatabaseManager.shared.updateTransaction(value, transaction: data)
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
    //handle save new transaction Publisher
    func handleSaveNewTransaction(){
        let savePublisher = NotificationCenter.Publisher.init(center: .default, name: .saveNewTransaction)
        saveNewTransactionSubscriber = savePublisher.sink(receiveValue: {[weak self] result in
            if var value = result.object as? ViewTransaction {
                if let category = self?.tempCategory {
                    value.category = category
                }
           
                let transaction = DatabaseManager.shared.saveTransaction(value)
                if self?.compareCategory?.id == value.category?.id{
                    self?.data?.append(transaction)
                }
                if self?.tempCategory != nil && self?.compareCategory == nil {
                    self?.data?.append(transaction)
                }
                NotificationCenter.default.post(name: .reloadShowFullBudgetTableModel, object: nil)
                self?.tableView.reloadData()
            }
        })
    }
    
    func handleSelectCategorySubscriber (){
        let selectCategoryPublisher =  NotificationCenter.Publisher.init(center: .default, name: .select_subscriber)
        select_subscriber = selectCategoryPublisher.sink(receiveValue: { [weak self] result in
            if let value = result.object as? Category {
                self?.tempCategory = value
            }
        })
    }
    
    //Mark: set navigation controller title and right button
    func navigationControllerProperties(){
        ViewController?.navigationItem.rightBarButtonItem = .init(image: CustomProperties.shared.tintedColorImage, style: .plain, target: self, action: #selector(Addtransaction))
        ViewController?.navigationItem.rightBarButtonItem?.tintColor = CustomProperties.shared.animationColor
    }
    
    //Mark: transition to addTransaction controller
    @objc func Addtransaction( ){
        let vc = AddTransactionViewController()
        vc.dataSource = .init(transactionStatus: .addTransaction, index: nil, transaction: nil)
        vc.dataSource?.category = tempCategory
        
        let navbar: UINavigationController = UINavigationController(rootViewController: vc)
        navbar.navigationBar.backgroundColor = CustomProperties.shared.animationColor
        ViewController?.present(navbar, animated: true, completion: nil)
    }
    
    
}

extension AllTransactionsModel : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataValue = data?.count  else { return 0 }
        switch state {
            case .base:  CustomProperties.shared.emptyDatasource(data: dataValue, tableView: tableView, title: "You do not have any transactions yet", message: "Click the plus icon '+' to add a new transaction", textColor: CustomProperties.shared.whiteTextColor)
            case .showFullBudgetTableModel :  CustomProperties.shared.emptyDatasource(data: dataValue, tableView: tableView, title: "You do not have any transactions yet", message: "Your saved transactions will appear here", textColor: CustomProperties.shared.whiteTextColor)
        }
        return dataValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllTransactionsTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let transaction = data?[indexPath.row] {
            EditTransaction(transaction: transaction, index: indexPath.row)

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func configureCell(_ cell: AllTransactionsTableViewCell?, at indexPath: IndexPath) {
        cell?.selectedBackgroundView = CustomProperties.shared.cellBackgroundView
        cell?.data = data?[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualAction(forRowAt: indexPath)])
    }
    
    //MARK: - Contextual Actions
       private func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
           return UIContextualAction(style: .destructive, title: "Delete") { (action, swipeButtonView, completion) in
            let transaction =  self.data?[indexPath.row]
            if let transaction = transaction {
                DispatchQueue.main.async {
                    DatabaseManager.shared.deleteTransaction(transaction)
                }
                
                self.data?.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
           }
       }
    
    @objc func EditTransaction(transaction : OnTractTransaction , index : Int){
        let vc = AddTransactionViewController()
        vc.dataSource = .init(transactionStatus: .editSaved, index: index, transaction: nil)
        vc.dataSource?.onTransaction = transaction
        let navbar: UINavigationController = UINavigationController(rootViewController: vc)
        navbar.navigationBar.backgroundColor = CustomProperties.shared.animationColor
        ViewController?.present(navbar, animated: true, completion: nil)
    }
    
}
