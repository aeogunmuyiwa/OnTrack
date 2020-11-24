//
//  HomeViewModelManager.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit
import Combine

class HomeViewModelManager: NSObject {
    let dashboardID = "dashboardID"
    let categoryId = "categoryId"
    var HomeViewContoller : UIViewController
    var defaultHeight : CGFloat = 600
    //Homedashboard
    

    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.translatesAutoresizingMaskIntoConstraints = true
       // collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
        collectionView.isScrollEnabled = true
        collectionView.register(HomeView_Dashboard_1_CollectionViewCell.self, forCellWithReuseIdentifier: dashboardID)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: categoryId)
        collectionView.delegate = self
        collectionView.dataSource = self
        HomeViewContoller.view.addSubview(collectionView)
        return collectionView
     }()
    
    init(HomeViewContoller : UIViewController) {
        self.HomeViewContoller = HomeViewContoller
        super.init()
        collectionView.pin(to: HomeViewContoller.view)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        navigationControllerProperties()
       
    }
    
    
    //Mark: set navigation controller title and right button
    func navigationControllerProperties(){
        HomeViewContoller.view.backgroundColor = CustomProperties.shared.viewBackgroundColor
        HomeViewContoller.navigationController?.navigationBar.prefersLargeTitles = true
        HomeViewContoller.navigationItem.title = "OnTrack"
        HomeViewContoller.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomProperties.shared.textColour]
        HomeViewContoller.navigationItem.rightBarButtonItem = .init(image: CustomProperties.shared.tintedColorImage, style: .plain, target: self, action: #selector(naviagenext))
        HomeViewContoller.navigationItem.rightBarButtonItem?.tintColor = CustomProperties.shared.animationColor
    }
    
    //Mark : right button action
    @objc func naviagenext(){
        HomeViewContoller.navigationController?.pushViewController(NextViewController(), animated: true)
    }
    
}


extension HomeViewModelManager : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dashboardID, for: indexPath) as! HomeView_Dashboard_1_CollectionViewCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryId, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(HomeViewContoller)
            return cell
        }
       
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        if (indexPath.section == 0) {
            return CGSize(width: collectionView.frame.width , height: 310)
        }else{
            return CGSize(width: collectionView.frame.width, height: defaultHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
             return 30
    }
    
    
}
