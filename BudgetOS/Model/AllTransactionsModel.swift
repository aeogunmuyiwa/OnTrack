//
//  AllTransactionsModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-27.
//

import UIKit
import CoreData
import Combine
class AllTransactionsModel: NSObject {
    private weak var ViewController : UIViewController?
    var data : [OnTractTransaction]?
    let cellId = "AllTransactionsModel"
    private var saveEditedTransactionSubscriber: AnyCancellable?
    private var saveNewTransactionSubscriber: AnyCancellable?
    
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
    
    
    init(ViewController : UIViewController, data : [OnTractTransaction]) {
        self.ViewController = ViewController
        self.data = data
//        self.data?.sort(by: {(item_1, item_2) in
//            item_1.date.is(than: item_2.date)
//        })
        super.init()
        handleSaveEditedTransaction()
        handleSaveNewTransaction()
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
            if let value = result.object as? ViewTransaction {
                let transaction = DatabaseManager.shared.saveTransaction(value)
                self?.data?.append(transaction)
                self?.tableView.reloadData()
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
        //vc.categoryDatasource = datasource
        let navbar: UINavigationController = UINavigationController(rootViewController: vc)
        navbar.navigationBar.backgroundColor = CustomProperties.shared.animationColor
        ViewController?.present(navbar, animated: true, completion: nil)
    }
    
    
}

extension AllTransactionsModel : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
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
    
    func configureCell(_ cell: AllTransactionsTableViewCell?, at indexPath: IndexPath) {
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
                DatabaseManager.shared.deleteTransaction(transaction)
                self.data?.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            //DatabaseManager.shared.deleteCategory(DatabaseManager.shared.fetchedResultsController.object(at: indexPath))
           // self.tableView.reloadData()
           }
       }
    
    @objc func EditTransaction(transaction : OnTractTransaction , index : Int){
        let vc = AddTransactionViewController()
        vc.dataSource = .init(transactionStatus: .editSaved, index: index, transaction: nil)
        vc.dataSource?.onTransaction = transaction
        //vc.categoryDatasource = datasource
        let navbar: UINavigationController = UINavigationController(rootViewController: vc)
        navbar.navigationBar.backgroundColor = CustomProperties.shared.animationColor
        ViewController?.present(navbar, animated: true, completion: nil)
    }
    
    
    
}
