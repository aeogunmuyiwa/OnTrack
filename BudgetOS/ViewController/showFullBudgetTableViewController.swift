//
//  showFullCategoryTableViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit

class showFullBudgetTableViewController: UIViewController {

    //showFullCategoryTableModel - ViewModel: manages views
    lazy var ShowFullBudgetTableModel : showFullBudgetTableModel = {
        let ShowFullBudgetTableModel = showFullBudgetTableModel(self)
        return ShowFullBudgetTableModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowFullBudgetTableModel = .init(self)
        navigationControllerProperties()
        // Do any additional setup after loading the view.
    }
    
    
    
    //Mark: set navigation controller title and right button
    func navigationControllerProperties(){
        self.navigationItem.rightBarButtonItem = .init(image: CustomProperties.shared.tintedColorImage, style: .plain, target: self, action: #selector(naviagenext))
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = CustomAssisbilityLabel.budgetList.goBack
        self.navigationItem.rightBarButtonItem?.tintColor = CustomProperties.shared.animationColor
    }
    
    //Mark : right button action
    @objc func naviagenext(){
        let nextVC = NextViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
