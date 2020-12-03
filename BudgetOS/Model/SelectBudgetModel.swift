//
//  SelectBudgetModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-28.
//

import UIKit
import CoreData

class SelectBudgetModel: NSObject {
    weak var controller : UIViewController?
    let cellId = "HomeView_TableView_CellId"
    
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
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(dismissView))
        controller.navigationItem.leftBarButtonItem = backButton
        controller.navigationItem.leftBarButtonItem?.tintColor = .black
        CustomProperties.shared.navigationControllerProperties(ViewController: controller, title: "Select budget")
    }
    
    @objc func dismissView(){
        controller?.navigationController?.popViewController(animated: true)
    }
}

extension SelectBudgetModel: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = DatabaseManager.shared.fetchedResultsController.sections else { return 0   }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            let item =  DatabaseManager.shared.fetchedResultsController.object(at: indexPath)
            NotificationCenter.default.post(name: .select_subscriber, object: item)
            self.controller?.navigationController?.popViewController(animated: true)
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Budget_CustomTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        return UISwipeActionsConfiguration(actions: [makeDeleteContextualAction(forRowAt: indexPath)])
//    }
    
    func configureCell(_ cell: Budget_CustomTableViewCell?, at indexPath: IndexPath) {
        if let cell = cell , let controller = controller {
            cell.setUp(controller, textColor: CustomProperties.shared.whiteTextColor)
            cell.data = DatabaseManager.shared.fetchedResultsController.object(at: indexPath)
        }
    }
//    //MARK: - Contextual Actions
//       private func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
//           return UIContextualAction(style: .destructive, title: "Delete") { (action, swipeButtonView, completion) in
//            DatabaseManager.shared.deleteCategory(DatabaseManager.shared.fetchedResultsController.object(at: indexPath))
//           // self.tableView.reloadData()
//           }
//       }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
      
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
       
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
