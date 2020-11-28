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
    private weak var HomeViewContoller : UIViewController?
    var defaultHeight : CGFloat = 100
    //Homedashboard
    

    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
        collectionView.isScrollEnabled = true
        collectionView.register(HomeView_Dashboard_1_CollectionViewCell.self, forCellWithReuseIdentifier: dashboardID)
        collectionView.register(BudgetCollectionViewCell.self, forCellWithReuseIdentifier: categoryId)
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
       // DatabaseManager.shared.deleteAllCategory()
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeight), name: .updateHomeViewModelManagerHeight, object: nil)
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
       // nextVC.delegate = CategoryCollectionViewCell.self as! AddCategoryDelegate
        HomeViewContoller?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
   @objc func updateHeight(notification: NSNotification){
        if let height = notification.object as? CGFloat {
            print("default height \(height)")
            defaultHeight = height
          //  collectionView.reloadData()
        }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryId, for: indexPath) as! BudgetCollectionViewCell
            cell.layer.cornerRadius = 20
            cell.backgroundColor = CustomProperties.shared.blackTextColor
            if let HomeViewContoller = HomeViewContoller {
                cell.setup(HomeViewContoller)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if (indexPath.section == 0) {
            return CGSize(width: collectionView.frame.width , height: 310)
        }
        return CGSize(width: collectionView.frame.width, height: defaultHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
             return 30
    }
    
    
}
