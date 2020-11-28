//
//  AllTransactionsModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-27.
//

import UIKit
import CoreData
class AllTransactionsModel: NSObject {
    private weak var ViewController : UIViewController?
    var data : [OnTractTransaction]?
    let cellId = "AllTransactionsModel"
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
    
    
    init(ViewController : UIViewController, data : NSOrderedSet) {
        self.ViewController = ViewController
        self.data = data.array as? [OnTractTransaction]
        self.data?.sort(by: {(item_1, item_2) in
            item_1.date.isLess(than: item_2.date)
        })
        super.init()
        activateView()
        CustomProperties.shared.navigationControllerProperties(ViewController: ViewController, title: "All transaction")
        
    }
    

    func activateView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    
    func configureCell(_ cell: AllTransactionsTableViewCell?, at indexPath: IndexPath) {
        cell?.data = data?[indexPath.row]
    }
    
    
}
