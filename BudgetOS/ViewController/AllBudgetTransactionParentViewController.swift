//
//  AllBudgetTransactionParentViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-29.
//

import UIKit

class AllBudgetTransactionParentViewController: UIViewController {
    
    weak var  category : Category?
    var allBudgetTransactionModel : AllBudgetTransactionModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let category = category else { return }
        allBudgetTransactionModel = .init(self, category)
    }

    
}
