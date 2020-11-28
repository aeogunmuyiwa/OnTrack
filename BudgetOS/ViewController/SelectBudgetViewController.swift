//
//  SelectBudgetViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-28.
//

import UIKit

class SelectBudgetViewController: UIViewController {

    lazy var selectBudgetModel : SelectBudgetModel = {
       let selectBudgetModel = SelectBudgetModel(self)
        return selectBudgetModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        selectBudgetModel = .init(self)

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
