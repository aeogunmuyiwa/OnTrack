//
//  AllBudgetTransactionModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-01.
//

import UIKit

class AllBudgetTransactionModel: NSObject {
    
    weak var controller : UIViewController?
    weak var  category : Category?
    
    lazy var height: CGFloat = {
        let height : CGFloat = CGFloat(category?.transactions?.count ?? 1 * 44) + 950
        return height
    }()
    
    lazy var scrollView: UIScrollView = {
       
        let frame = CGRect(x: 0, y: 0, width: controller?.view.frame.width ?? .zero, height: height)
        let scrollView = UIScrollView(frame: frame)
        scrollView.contentSize.height = height
        scrollView.showsVerticalScrollIndicator = false
        controller?.view.addSubview(scrollView)
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        scrollView.addSubview(stackView)
        return stackView
    }()
    
    lazy var budgetView: AllBudgetView = {
        let budgetView = AllBudgetView()
        budgetView.data = category
        stackView.addArrangedSubview(budgetView)
        budgetView.translatesAutoresizingMaskIntoConstraints = false
        if let controller = controller {
            budgetView.heightAnchor(200)
            budgetView.leftAnchor(scrollView.layoutMarginsGuide.leftAnchor, 10)
            budgetView.rightAnchor(scrollView.layoutMarginsGuide.rightAnchor, -10)
          //  budgetView.widthAnchor(controller.view.frame.width - 100 )
        }
       // budgetView.layer.cornerRadius = 10
        budgetView.backgroundColor = .clear
        return  budgetView
    }()
    
    
    lazy var alltransactionView: UIView = {
        let alltransactionView = UIView(frame: .zero)
        stackView.addArrangedSubview(alltransactionView)
        alltransactionView.translatesAutoresizingMaskIntoConstraints = false
        alltransactionView.topAnchor(budgetView.bottomAnchor, 0)
        if let controller = controller{
            alltransactionView.widthAnchor(controller.view.frame.width)
          //  alltransactionView.bottomAnchor(scrollView.bottomAnchor, constant: 0)
            let vc = AllTransactionsViewController()
            vc.tableViewScrollEnable = false
            vc.tempCatgeory = category
            vc.data = category?.transactions?.array as? [OnTractTransaction]
            controller.addChild(vc)
            alltransactionView.addSubview(vc.view)
            vc.didMove(toParent: controller)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.topAnchor(alltransactionView.layoutMarginsGuide.topAnchor, 0)
            vc.view.leftAnchor(alltransactionView.layoutMarginsGuide.leftAnchor, 0)
            vc.view.rightAnchor(alltransactionView.layoutMarginsGuide.rightAnchor, 0)
            vc.view.bottomAnchor(scrollView.layoutMarginsGuide.bottomAnchor, constant: 0)
        }
        return alltransactionView
    }()
    
    init(_ controller : UIViewController , _ category : Category )   {
        self.controller = controller
        self.category = category
        super.init()
        activateViews()
        navigationControllerProperties()
    }
    
    //Mark: set navigation controller title and right button
    func navigationControllerProperties(){
        controller?.navigationItem.rightBarButtonItem = .init(image: CustomProperties.shared.trashImage, style: .plain, target: self, action: #selector(performDeleteBudget))
        controller?.navigationItem.rightBarButtonItem?.tintColor = CustomProperties.shared.animationColor
    }
    @objc func performDeleteBudget(){
    if let category = self.category{
        DatabaseManager.shared.deleteCategory(category)
    }
     controller?.navigationController?.popViewController(animated: true)
      
        
    }
    func activateViews(){
        if let controller = controller {
            scrollView.frame = controller.view.bounds
            stackView.frame = scrollView.frame
            budgetView.translatesAutoresizingMaskIntoConstraints = false
            alltransactionView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}
