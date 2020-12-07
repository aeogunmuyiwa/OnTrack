//
//  PageViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-03.
//

import UIKit
import CareKit
import Combine

class PageContentViewController: UIViewController {

    var page: AnalyticsPages
    var pageContentModel : PageContentModel?
    init(with page: AnalyticsPages) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
        pageContentModel = .init(page: page, controller: self)
      
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
       
       // reloadDatasoruce()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
}



