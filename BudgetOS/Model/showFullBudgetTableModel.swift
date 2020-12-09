//
//  showFullCategoryTableModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit
import CoreData
import Combine

class showFullBudgetTableModel: NSObject {
    weak var controller : UIViewController?
    let cellId = "HomeView_TableView_CellId"
    private var reloadShowFullBudgetTableModel : AnyCancellable?
    
    lazy var totalBudgetView: UIView = {
        let totalBudgetView = UIView()
        totalBudgetView.translatesAutoresizingMaskIntoConstraints = false
        totalBudgetView.layer.cornerRadius = 10
        return totalBudgetView
    }()
    
    lazy var totalBuget: UILabel = {
        let totalBuget = UILabel()
        totalBuget.textColor = CustomProperties.shared.whiteTextColor
        totalBuget.font = CustomProperties.shared.basicBoldTextFont
        totalBuget.text = "Your budget total is $"
        totalBudgetView.addSubview(totalBuget)
        totalBuget.translatesAutoresizingMaskIntoConstraints = false
        totalBuget.topAnchor(totalBudgetView.layoutMarginsGuide.topAnchor, 5)
        totalBuget.rightAnchor(totalBudgetView.rightAnchor, 0)
        totalBuget.leftAnchor(totalBudgetView.leftAnchor, 0)
        return totalBuget
    }()
  
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(Budget_CustomTableViewCell.self, forCellReuseIdentifier: cellId)
        DatabaseManager.shared.fetchedResultsController.delegate = self
        DatabaseManager.shared.performFetch()
        tableView.separatorStyle = .none
        controller?.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = true
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = true
        
        if let controller = controller {
            tableView.pin(to: controller.view)
        }
        
        return tableView
    }()
    
    init(_ controller : UIViewController) {
        self.controller = controller
        super.init()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        if let amount = DatabaseManager.shared.fetchedResultsController.fetchedObjects?.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
            x.adding(y.budget ?? 0)
        }){
            totalBuget.text = "Your budget total is $\(amount)"
        }
        CustomProperties.shared.navigationControllerProperties(ViewController: controller, title: "Budgets")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadShowTable), name: .reloadShowFullBudgetTableModel, object: nil)
    }
    
       @objc func reloadShowTable(){
            DatabaseManager.shared.performFetch()
            tableView.reloadData()
        }
}
  

extension showFullBudgetTableModel: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let data = DatabaseManager.shared.fetchedResultsController.fetchedObjects?.count
        if data != 0 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        totalBudgetView.frame  =  CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        totalBudgetView.addSubview(totalBuget)
        let data = DatabaseManager.shared.fetchedResultsController.fetchedObjects?.count
        if data != 0 {
            return totalBudgetView
        }
        return UIView()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = DatabaseManager.shared.fetchedResultsController.sections else { return 0   }
        let data = sections[section].numberOfObjects
        CustomProperties.shared.emptyDatasource(data: data, tableView: tableView, title: "You do not have any budget yet", message: "Click the plus icon '+' to add a new budget", textColor: CustomProperties.shared.whiteTextColor)
       
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            if let From = self.controller{
                let parent = AllBudgetTransactionParentViewController()
                parent.category = DatabaseManager.shared.fetchedResultsController.object(at: indexPath)
                CustomProperties.shared.navigationControllerProperties(ViewController: parent, title: "Budgets")
                CustomProperties.shared.navigateToController(to: parent, from: From)
            }
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Budget_CustomTableViewCell
        cell.selectedBackgroundView = CustomProperties.shared.cellBackgroundView
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualAction(forRowAt: indexPath)])
    }
    
    func configureCell(_ cell: Budget_CustomTableViewCell?, at indexPath: IndexPath) {
        if let cell = cell , let controller = controller {
            cell.setUp(controller, textColor: CustomProperties.shared.whiteTextColor)
            cell.data = DatabaseManager.shared.fetchedResultsController.object(at: indexPath)
        }
    }
    //MARK: - Contextual Actions
       private func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
           return UIContextualAction(style: .destructive, title: "Delete") { (action, swipeButtonView, completion) in
            DatabaseManager.shared.deleteCategory(DatabaseManager.shared.fetchedResultsController.object(at: indexPath))
            self.tableView.reloadData()
           }
       }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
      
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let amount = DatabaseManager.shared.fetchedResultsController.fetchedObjects?.reduce( NSDecimalNumber(integerLiteral: 0 ), {x,y in
            x.adding(y.budget ?? 0)
        }){
            totalBuget.text = "Your budget adds up to $\(amount)"
        }
            switch type {
                case .insert :
                    if let newIndexPath = newIndexPath {
                        tableView.insertRows(at: [newIndexPath], with: .fade)
                    }
            case .delete :
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case .move :
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
                
            case .update :
                if let indexPath = indexPath {
                    configureCell(tableView.cellForRow(at: indexPath) as? Budget_CustomTableViewCell, at: indexPath)
                }
            @unknown default:
                print("unknown default, will handle error")
            }
    }
}




