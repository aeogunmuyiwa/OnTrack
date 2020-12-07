//
//  NextViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-19.
//

import UIKit

class NextViewController: UIViewController {

 
    lazy var addCategoryModel: AddBudgetModel? = {
        let addCategoryModel = AddBudgetModel(self)
        return addCategoryModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
   
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        addCategoryModel = .init(self)
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
