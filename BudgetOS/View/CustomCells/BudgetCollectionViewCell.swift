//
//  CategoryCollectionViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit
import Combine
import CoreData

class BudgetCollectionViewCell: UICollectionViewCell {
    var HomeViewContoller : UIViewController?
  
    let cellId = "HomeView_TableView_CellId"
    private lazy var categoryLabel : UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.text = "Budgets"
        categoryLabel.font = CustomProperties.shared.basicBoldTextFont
        categoryLabel.textColor = CustomProperties.shared.whiteTextColor
        categoryLabel.translatesAutoresizingMaskIntoConstraints = true
        contentView.addSubview(categoryLabel)
        categoryLabel.topAnchor(contentView.layoutMarginsGuide.topAnchor, 0)
        categoryLabel.leftAnchor(contentView.layoutMarginsGuide.leftAnchor, 0)
        categoryLabel.widthAnchor(contentView.widthAnchor, multiplier:0.5, 10)
        return categoryLabel
    }()
    
    
    private lazy var showFullTable: UIButton = {
        let newCategory = UIButton()
        newCategory.setImage(CustomProperties.shared.chevronRight, for: .normal)
        newCategory.addTarget(self, action: #selector(showFullTableAction), for: .touchUpInside)
        newCategory.tintColor = CustomProperties.shared.animationColor
        newCategory.translatesAutoresizingMaskIntoConstraints = true
        contentView.addSubview(newCategory)
        newCategory.titleLabel?.font = CustomProperties.shared.basicBoldTextFont
        newCategory.titleLabel?.textColor = CustomProperties.shared.textColour
        newCategory.topAnchor(contentView.layoutMarginsGuide.topAnchor, 0)
        newCategory.rightAnchor(contentView.layoutMarginsGuide.rightAnchor, 20)
        newCategory.widthAnchor(contentView.widthAnchor, multiplier:0.2, 10)
        return newCategory
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(Budget_CustomTableViewCell.self, forCellReuseIdentifier: cellId)
        DatabaseManager.shared.fetchedResultsController.delegate = self
        DatabaseManager.shared.performFetch()
        contentView.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.topAnchor(showFullTable.layoutMarginsGuide.bottomAnchor, 10)
        tableView.leftAnchor(contentView.layoutMarginsGuide.leftAnchor, 0)
        tableView.rightAnchor(contentView.layoutMarginsGuide.rightAnchor, 0)
       // tableView.heightAnchor(50)
        tableView.bottomAnchor(contentView.layoutMarginsGuide.bottomAnchor, constant: 0)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        showFullTable.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NotificationCenter.default.addObserver(self, selector: #selector(addObservertoTable), name: .reloadCategoryTable, object: nil)
      }
    
    @objc func addObservertoTable(){
        DatabaseManager.shared.performFetch()
        tableView.reloadData()
    }
    func setup(_ HomeViewContoller : UIViewController, color : UIColor) {
        self.HomeViewContoller = HomeViewContoller
        categoryLabel.textColor = color
    }
    //show full category table
    @objc func showFullTableAction(){
        HomeViewContoller?.navigationController?.pushViewController(showFullBudgetTableViewController(), animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

extension BudgetCollectionViewCell: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = DatabaseManager.shared.fetchedResultsController.sections else { return 0   }
        return sections[section].numberOfObjects
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.tableView.deselectRow(at: indexPath, animated: true)
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
            let item =  DatabaseManager.shared.fetchedResultsController.object(at: indexPath).transactions
            let vc = AllTransactionsViewController()
            vc.data = item?.array as? [OnTractTransaction]
            if let From = HomeViewContoller {
                CustomProperties.shared.navigateToController(to: vc, from: From)
            }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Budget_CustomTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }
    func configureCell(_ cell: Budget_CustomTableViewCell?, at indexPath: IndexPath) {
        if let cell = cell, let HomeViewContoller = HomeViewContoller {
            cell.setUp(HomeViewContoller, textColor: CustomProperties.shared.blackTextColor)
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
                    configureCell(tableView.cellForRow(at: indexPath) as? Budget_CustomTableViewCell, at: indexPath)
                }
            @unknown default:
                print("unknown default, will handle error")
            }
    }
}




