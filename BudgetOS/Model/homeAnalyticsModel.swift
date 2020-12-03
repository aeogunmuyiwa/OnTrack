//
//  homeAnalyticsModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-02.
//

import UIKit
import CareKit
import Combine
import CoreData

class homeAnalyticsModel: NSObject {
    private weak var HomeViewController : UIViewController?
    private lazy var pageController: UIPageViewController =  {
       let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.backgroundColor = .clear
        DatabaseManager.shared.fetchedResultsController.delegate = self
        DatabaseManager.shared.fetchedTransactionResultsController.delegate = self
        DatabaseManager.shared.performTransactionFetch()
        DatabaseManager.shared.performFetch()
        if let HomeViewController = HomeViewController {
            HomeViewController.addChild(pageController)
            HomeViewController.view.addSubview(pageController.view)
            pageController.view.pin(to: HomeViewController.view)
            let initialVC = PageVC(with: pages[0])
            pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
            pageController.didMove(toParent: HomeViewController)
        }
        return pageController
    }()
    
    private var pages: [Pages] = Pages.allCases
    private var currentIndex: Int = 0
    
    private func setupPageController() {
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(HomeViewController : UIViewController) {
        self.HomeViewController = HomeViewController
        super.init()
        setupPageController()
        guard let transactions = DatabaseManager.shared.fetchedTransactionResultsController.fetchedObjects else { return }
        pages[0].setdata(<#T##data: Any##Any#>, <#T##expression: Pages##Pages#>) = sortingFile.init().sortingByWeekday(sortby: transactions)
        
       
    }
    
    lazy var transactions: [weekdays: [OnTractTransaction]] = {
        let transaction  : [weekdays: [OnTractTransaction]] = [weekdays: [OnTractTransaction]]()
        return transaction
    }()

}

extension homeAnalyticsModel : UIPageViewControllerDelegate ,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? PageVC else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        let vc: PageVC = PageVC(with: pages[index])
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? PageVC else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index >= self.pages.count - 1 {
            return nil
        }
        
        index += 1
        
        let vc: PageVC = PageVC(with: pages[index])
        
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
}

extension homeAnalyticsModel : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       
       
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       
  
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
       
            switch type {
                case .insert :
                    if let newIndexPath = newIndexPath {
                       
                    }
            case .delete :
                if let indexPath = indexPath {
                  
                }
            case .move :
                if let indexPath = indexPath {
                   
                }
                if let newIndexPath = newIndexPath {
                   
                }
                
            case .update :
                if let indexPath = indexPath {
                   
                }
            @unknown default:
                print("unknown default, will handle error")
            }
    }
}



enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    
    var name: String {
        switch self {
        case .pageZero:
            return "This week transaction summary "
        case .pageOne:
            return "This months budget summary"
        case .pageTwo:
            return "Weekly transactions"
        case .pageThree:
            return "This is page three"
        }
    }
    var data : Any {
        switch self {
        case .pageZero: return analytics_sortbyweekday.init()
        default: return analytics.self
        }
    }
    
    func setdata(_ dataValue : Any, _ expression : Pages) {
        switch expression {
        case .pageZero: data = dataValue
        default:
            return data
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        }
    }
}

class PageVC: UIViewController {
    
    
    lazy var chartView: OCKCartesianChartView = {
        let chartView = OCKCartesianChartView(type: .bar)
        self.view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.pin(to: view)
        chartView.graphView.horizontalAxisMarkers = ["M", "T"]
        chartView.headerView.titleLabel.text = page.name
        chartView.graphView.dataSeries = [
            OCKDataSeries(values: [1,3,4,5,6,8], title: "ddd", size: 30, color: .gray),
            OCKDataSeries(values: [0 ,1,2,3,4], title: "test", gradientStartColor: UIColor.red, gradientEndColor: UIColor.blue, size: 10)
            
            
        ]
        return chartView
    }()
    
    var page: Pages
    
    init(with page: Pages) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
        self.chartView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


struct analytics {
    let horizontalAxisMarker : [String]
    let dataValueStruct : [DataValueStruct]
    let headerTitle : String
    struct DataValueStruct {
        let title : String
        let value : [NSDecimalNumber]
    }
}



