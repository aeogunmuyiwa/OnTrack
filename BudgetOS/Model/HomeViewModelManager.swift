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
    let transactionId = "transactionId"
    private weak var HomeViewContoller : UIViewController?
    var defaultHeight : CGFloat = 300
    var TransactionTableHeight : CGFloat = 0
    //Homedashboard
    

    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
        collectionView.isScrollEnabled = true
        collectionView.register(HomeView_Dashboard_1_CollectionViewCell.self, forCellWithReuseIdentifier: dashboardID)
        collectionView.register(BudgetCollectionViewCell.self, forCellWithReuseIdentifier: categoryId)
        collectionView.register(TransactionCollectionViewCell.self, forCellWithReuseIdentifier: transactionId)
        collectionView.delegate = self
        collectionView.dataSource = self
        HomeViewContoller?.view.addSubview(collectionView)
        if let HomeViewContoller = HomeViewContoller {
            collectionView.pin(to: HomeViewContoller.view)
        }
        return collectionView
     }()
    
    
    init(HomeViewContoller : UIViewController) {
        self.HomeViewContoller = HomeViewContoller
        super.init()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        CustomProperties.shared.navigationControllerProperties(ViewController: HomeViewContoller, title: "OnTrack")
        navigationControllerProperties()
    }
   

    
    //Mark: set navigation controller title and right button
    func navigationControllerProperties(){
        HomeViewContoller?.navigationItem.rightBarButtonItem = .init(image: CustomProperties.shared.tintedColorImage, style: .plain, target: self, action: #selector(naviagenext))
        HomeViewContoller?.navigationItem.rightBarButtonItem?.tintColor = CustomProperties.shared.animationColor
    }
    
    //Mark : right button action
    @objc func naviagenext(){
        let nextVC = NextViewController()
        HomeViewContoller?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}


extension HomeViewModelManager : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dashboardID, for: indexPath) as! HomeView_Dashboard_1_CollectionViewCell
            if let controller = HomeViewContoller {
                cell.setUp(controller)
            }
           
            return cell
        }
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: transactionId, for: indexPath) as! TransactionCollectionViewCell
            cell.layer.cornerRadius = 20
            if let HomeViewContoller = HomeViewContoller {
                cell.setup(colour: CustomProperties.shared.blackTextColor, ViewController: HomeViewContoller)
            }
          
            cell.backgroundColor = CustomProperties.shared.whiteTextColor
            return cell
        }
        if indexPath.section == 2  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryId, for: indexPath) as! BudgetCollectionViewCell
            cell.layer.cornerRadius = 20
            cell.backgroundColor = CustomProperties.shared.whiteTextColor
            if let HomeViewContoller = HomeViewContoller {
                cell.setup(HomeViewContoller, color: CustomProperties.shared.blackTextColor)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if (indexPath.section == 0) {
            return CGSize(width: collectionView.frame.width , height: 310)
        } else if (indexPath.section == 1 || indexPath.section == 2){
            return CGSize(width: collectionView.frame.width, height: defaultHeight )
        }
        return .zero
    }
    
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//             return 30
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
//    }
    
}
