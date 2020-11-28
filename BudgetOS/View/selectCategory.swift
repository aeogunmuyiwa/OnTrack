//
//  selectCategory.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-28.
//

import UIKit

class selectCategory: UIView {

    
    weak var controller : UIViewController?
    lazy var categoryImage: UIImageView = {
        let categoryImage = UIImageView()
        categoryImage.image = CustomProperties.shared.categoryImagePlain
        self.addSubview(categoryImage)
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.centerYAnchor(self.centerYAnchor, 0)
        categoryImage.leftAnchor(self.layoutMarginsGuide.leftAnchor, 0)
        return categoryImage
    }()
    
    lazy var category: UILabel = {
        let category = UILabel()
        category.text = "Category"
        category.font = CustomProperties.shared.basicTextFont
        category.textColor = CustomProperties.shared.textColour
        category.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(category)
        category.centerYAnchor(self.centerYAnchor, 0)
        category.leftAnchor(categoryImage.rightAnchor, 10)
        return category
    }()
    
    private lazy var showFullTable: UIButton = {
        let showFullTable = UIButton()
        showFullTable.setImage(CustomProperties.shared.chevronRight, for: .normal)
        showFullTable.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
        showFullTable.tintColor = .black
        showFullTable.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(showFullTable)
        showFullTable.titleLabel?.font = CustomProperties.shared.basicBoldTextFont
        showFullTable.titleLabel?.textColor = CustomProperties.shared.textColour
        showFullTable.centerYAnchor(self.centerYAnchor, 0)
        showFullTable.rightAnchor(self.layoutMarginsGuide.rightAnchor, 0)
        return showFullTable
    }()
    
    lazy var categoryData: UILabel = {
        let categoryData = UILabel()
        categoryData.text = "Select category"
        categoryData.font = CustomProperties.shared.basicTextfontStandard
        categoryData.textColor = CustomProperties.shared.textColour
        categoryData.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(categoryData)
        self.bringSubviewToFront(categoryData)
        categoryData.centerYAnchor(self.centerYAnchor, 0)
        categoryData.rightAnchor(showFullTable.leftAnchor, -10)
        return categoryData
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        category.translatesAutoresizingMaskIntoConstraints = false
        categoryData.translatesAutoresizingMaskIntoConstraints = false
        showFullTable.translatesAutoresizingMaskIntoConstraints = false
    }
    //Mark: transition to addTransaction controller
    @objc func selectCategory( ){
        let vc = SelectBudgetViewController()
        let navbar: UINavigationController = UINavigationController(rootViewController: vc)
        navbar.navigationBar.backgroundColor = CustomProperties.shared.animationColor
        if let controller = controller  {
            CustomProperties.shared.navigateToController(to: vc, from: controller)
        }
    }
    
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
