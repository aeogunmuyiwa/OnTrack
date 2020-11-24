//
//  HomeView_Dashboard_1_CollectionViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit

class HomeView_Dashboard_1_CollectionViewCell: UICollectionViewCell {
    
    lazy var homeDashboard : HomeView_Dashboard_1 =  {
        let dashboard = HomeView_Dashboard_1()
        self.addSubview(dashboard)
        dashboard.pin(to: contentView)
        return dashboard
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        homeDashboard.translatesAutoresizingMaskIntoConstraints = false
        homeDashboard.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
