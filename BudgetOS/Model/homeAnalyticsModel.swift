//
//  homeAnalyticsModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-02.
//

import UIKit

import Combine
import CoreData

class homeAnalyticsModel: NSObject {
    private weak var HomeViewController : UIViewController?
    private lazy var pageController: UIPageViewController =  {
       let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.backgroundColor = .clear

        if let HomeViewController = HomeViewController {
            HomeViewController.addChild(pageController)
            HomeViewController.view.addSubview(pageController.view)
            pageController.view.pin(to: HomeViewController.view)
            let initialVC = PageContentViewController(with: pages[0])
            pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
            pageController.didMove(toParent: HomeViewController)
        }
        return pageController
    }()
    
    private var pages: [AnalyticsPages] = AnalyticsPages.allCases
    private var currentIndex: Int = 0
    
    private func setupPageController() {
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(HomeViewController : UIViewController) {
        self.HomeViewController = HomeViewController
        super.init()
        setupPageController()
    }
    

}








extension homeAnalyticsModel : UIPageViewControllerDelegate ,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? PageContentViewController else {
            return nil
        }
        var index = currentVC.page.index
        
        if index == 0 {
            return nil
        }
        index -= 1
        let vc: PageContentViewController = PageContentViewController(with: pages[index])
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PageContentViewController else {
            return nil
        }
        var index = currentVC.page.index
        if index >= self.pages.count - 1 {
            return nil
        }
        index += 1
        let vc: PageContentViewController = PageContentViewController(with: pages[index])
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
}













