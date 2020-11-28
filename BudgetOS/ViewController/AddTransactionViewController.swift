//
//  AddTransactionViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-22.
//

import UIKit

class AddTransactionViewController: UIViewController {
    var dataSource : ViewTransaction?
    lazy var addTransactionModel :  AddTransactionModel = {
        let addTransactionModel = AddTransactionModel(self, dataSource)
        return addTransactionModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addTransactionModel = .init(self, dataSource)
//        addTransactionModel.viewController = self
//        addTransactionModel.datasource = dataSource
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
