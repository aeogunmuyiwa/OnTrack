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
