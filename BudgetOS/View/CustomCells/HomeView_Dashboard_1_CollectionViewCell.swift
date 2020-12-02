//
//  HomeView_Dashboard_1_CollectionViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit

class HomeView_Dashboard_1_CollectionViewCell: UICollectionViewCell {
    weak var controller : UIViewController?
//    lazy var homeDashboard : HomeView_DashboardView =  {
//        let dashboard = HomeView_DashboardView()
//        self.addSubview(dashboard)
//        dashboard.pin(to: contentView)
//        dashboard.backgroundColor = .red
//        return dashboard
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
     //   homeDashboard.translatesAutoresizingMaskIntoConstraints = false
        
    }
    func setUp(_ controller : UIViewController) {
        self.controller = controller
        let pageVc = homeAnalyticsViewController()
        controller.addChild(pageVc)
        self.addSubview(pageVc.view)
        pageVc.didMove(toParent: controller)
        pageVc.view.pin(to: self)
        self.bringSubviewToFront(pageVc.view)
       
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
