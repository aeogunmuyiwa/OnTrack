//
//  showFullCategoryTableModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit
import CoreData

class showFullCategoryTableModel: NSObject {
    var controller : UIViewController
    let cellId = "HomeView_TableView_CellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(HomeView_TableViewTableViewCell.self, forCellReuseIdentifier: cellId)
        DatabaseManager.shared.fetchedResultsController.delegate = self
        DatabaseManager.shared.performFetch()
        controller.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = true
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.pin(to: controller.view)
        return tableView
    }()
    
    init(_ controller : UIViewController) {
        self.controller = controller
        super.init()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationControllerProperties()
    }
    func navigationControllerProperties(){
        controller.view.backgroundColor = CustomProperties.shared.viewBackgroundColor
        controller.navigationController?.navigationBar.prefersLargeTitles = true
        controller.navigationItem.title = "Category"
        controller.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomProperties.shared.textColour]

    }

}
  

extension showFullCategoryTableModel: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = DatabaseManager.shared.fetchedResultsController.sections else { return 0   }
        return sections[0].numberOfObjects
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeView_TableViewTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }
    func configureCell(_ cell: HomeView_TableViewTableViewCell?, at indexPath: IndexPath) {
        if let cell = cell {
            cell.data = DatabaseManager.shared.fetchedResultsController.object(at: indexPath)
        }
    }
        
    
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
                    configureCell(tableView.cellForRow(at: indexPath) as? HomeView_TableViewTableViewCell, at: indexPath)
                }
            @unknown default:
                print("unknown default, will handle error")
            }
        
        
    }
}




