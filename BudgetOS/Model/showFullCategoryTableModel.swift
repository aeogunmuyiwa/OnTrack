//
//  showFullCategoryTableModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit

class showFullCategoryTableModel: NSObject {
    var controller : UIViewController
    let cellId = "HomeView_TableView_CellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(HomeView_TableViewTableViewCell.self, forCellReuseIdentifier: cellId)
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
extension showFullCategoryTableModel : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeView_TableViewTableViewCell
        cell.data = .init("testing \(indexPath.row)", 100, nil)
        return cell
    }
    
    
}
