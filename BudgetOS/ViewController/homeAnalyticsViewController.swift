//
//  homeAnalyticsViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-02.
//

import UIKit
import CoreData

class homeAnalyticsViewController: UIViewController {
  
    var homeAnalyticsModel : homeAnalyticsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        homeAnalyticsModel = .init(HomeViewController: self)
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



