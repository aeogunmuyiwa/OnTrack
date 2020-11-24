//
//  showFullCategoryTableViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit

class showFullCategoryTableViewController: UIViewController {

    //showFullCategoryTableModel - ViewModel: manages views
    lazy var ShowFullCategoryTableModel : showFullCategoryTableModel = {
        let ShowFullCategoryTableModel = showFullCategoryTableModel(self)
        return ShowFullCategoryTableModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowFullCategoryTableModel = .init(self)
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
