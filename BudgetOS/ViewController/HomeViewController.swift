//
//  ViewController.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-19.
//

import UIKit

class HomeViewController: UIViewController {

    
    //MARK : OUTLET
    //HomeView - ViewModel: manages views
    lazy var homeViewModel : HomeViewModelManager = {
        let homeViewModel = HomeViewModelManager(HomeViewContoller: self)
        return homeViewModel
    }()
    deinit {
        print("CategoryCollectionViewCell deint")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel = .init(HomeViewContoller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
   
    }
    
   
  
    
}




