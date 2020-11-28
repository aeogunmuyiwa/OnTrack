//
//  TransactionCollectionViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-28.
//

import UIKit
import CoreData

class TransactionCollectionViewCell: UICollectionViewCell {
    let cellId = "AllTransactionsModel"
    weak var textcolor : UIColor?
    weak var viewController : UIViewController?
    
    private lazy var transactionLabel : UILabel = {
        let transactionLabel = UILabel()
        transactionLabel.text = "Transactions"
        transactionLabel.font = CustomProperties.shared.basicBoldTextFont
        transactionLabel.textColor = CustomProperties.shared.whiteTextColor
        transactionLabel.translatesAutoresizingMaskIntoConstraints = true
        contentView.addSubview(transactionLabel)
        transactionLabel.topAnchor(contentView.layoutMarginsGuide.topAnchor, 0)
        transactionLabel.leftAnchor(contentView.layoutMarginsGuide.leftAnchor, 0)
        transactionLabel.widthAnchor(contentView.layoutMarginsGuide.widthAnchor, multiplier:0.5, 10)
        return transactionLabel
    }()
    
    
    private lazy var showFullTable: UIButton = {
        let showFullTable = UIButton()
        showFullTable.setImage(CustomProperties.shared.chevronRight, for: .normal)
        showFullTable.addTarget(self, action: #selector(showAllTransactions), for: .touchUpInside)
        showFullTable.tintColor = CustomProperties.shared.animationColor
        showFullTable.translatesAutoresizingMaskIntoConstraints = true
        contentView.addSubview(showFullTable)
        showFullTable.titleLabel?.font = CustomProperties.shared.basicBoldTextFont
        showFullTable.titleLabel?.textColor = CustomProperties.shared.textColour
        showFullTable.topAnchor(contentView.layoutMarginsGuide.topAnchor, 0)
        showFullTable.rightAnchor(contentView.layoutMarginsGuide.rightAnchor, 20)
        showFullTable.widthAnchor(contentView.layoutMarginsGuide.widthAnchor, multiplier:0.2, 10)
        return showFullTable
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(AllTransactionsTableViewCell.self, forCellReuseIdentifier: cellId)
        DatabaseManager.shared.fetchedTransactionResultsController.delegate = self
        DatabaseManager.shared.performTransactionFetch()
        tableView.separatorStyle = .none
        contentView.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = true
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.topAnchor(showFullTable.layoutMarginsGuide.bottomAnchor, 20)
        tableView.leftAnchor(contentView.layoutMarginsGuide.leftAnchor, 0)
        tableView.rightAnchor(contentView.layoutMarginsGuide.rightAnchor, 0)
        tableView.bottomAnchor(contentView.layoutMarginsGuide.bottomAnchor)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        transactionLabel.translatesAutoresizingMaskIntoConstraints = false
        showFullTable.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    func setup(colour : UIColor, ViewController : UIViewController){
        textcolor = colour
        transactionLabel.textColor = colour
        viewController = ViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showAllTransactions(){
        let vc = AllTransactionsViewController()
        vc.data = DatabaseManager.shared.fetchedTransactionResultsController.fetchedObjects
        if let From = viewController{
            CustomProperties.shared.navigateToController(to: vc, from: From)
        }
    }
    
}

extension TransactionCollectionViewCell : UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = DatabaseManager.shared.fetchedTransactionResultsController.sections else { return 0   }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllTransactionsTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }

    func configureCell(_ cell: AllTransactionsTableViewCell?, at indexPath: IndexPath) {
        cell?.setup(textColor: textcolor)
        cell?.data = DatabaseManager.shared.fetchedTransactionResultsController.object(at: indexPath)
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
                    configureCell(tableView.cellForRow(at: indexPath) as? AllTransactionsTableViewCell, at: indexPath)
                }
            @unknown default:
                print("unknown default, will handle error")
            }
    }
    
}
