//
//  AllTransactionsViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-27.
//

import UIKit

class AllTransactionsViewController: UIViewController {
    var data : [OnTractTransaction]?
    var tempCatgeory : Category?
    lazy var allTransactionsModel : AllTransactionsModel = {
        let allTransactionsModel = AllTransactionsModel(ViewController: self, data: data ?? .init(), tempCategory: tempCatgeory)
        return allTransactionsModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        allTransactionsModel = .init(ViewController: self, data: data ?? .init(), tempCategory: tempCatgeory)
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
