//
//  CategoryCollectionViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit
import Combine

class CategoryCollectionViewCell: UICollectionViewCell {
    var HomeViewContoller : UIViewController?
    let cellId = "HomeView_TableView_CellId"
    
    lazy var categoryLabel : UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = CustomProperties.shared.basicBoldTextFont
        categoryLabel.textColor = CustomProperties.shared.textColour
        categoryLabel.translatesAutoresizingMaskIntoConstraints = true
        contentView.addSubview(categoryLabel)
        categoryLabel.topAnchor(contentView.layoutMarginsGuide.topAnchor, 0)
        categoryLabel.leftAnchor(contentView.layoutMarginsGuide.leftAnchor, 0)
        categoryLabel.widthAnchor(contentView.widthAnchor, multiplier:0.5, 10)
        return categoryLabel
    }()
    
    
    lazy var newCategory: UIButton = {
        let newCategory = UIButton()
        newCategory.setImage(CustomProperties.shared.tintedColorImage, for: .normal)
        newCategory.addTarget(self, action: #selector(naviagenext), for: .touchUpInside)
        newCategory.translatesAutoresizingMaskIntoConstraints = true
        contentView.addSubview(newCategory)
        newCategory.titleLabel?.font = CustomProperties.shared.basicBoldTextFont
        newCategory.titleLabel?.textColor = CustomProperties.shared.textColour
        newCategory.topAnchor(contentView.layoutMarginsGuide.topAnchor, 0)
        newCategory.rightAnchor(contentView.layoutMarginsGuide.rightAnchor, 0)
        newCategory.widthAnchor(contentView.widthAnchor, multiplier:0.2, 10)

        return newCategory
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(HomeView_TableViewTableViewCell.self, forCellReuseIdentifier: cellId)
        contentView.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.topAnchor(newCategory.layoutMarginsGuide.bottomAnchor, 10)
        tableView.leftAnchor(contentView.layoutMarginsGuide.leftAnchor, 0)
        tableView.rightAnchor(contentView.layoutMarginsGuide.rightAnchor, 0)
        tableView.bottomAnchor(showMoreLable.layoutMarginsGuide.topAnchor, constant: 0)
        return tableView
    }()
    
    lazy var showMoreLable : UIButton = {
        let showMoreLable = UIButton()
        showMoreLable.backgroundColor = CustomProperties.shared.animationColor
        showMoreLable.setTitle("Show more", for: .normal)
        showMoreLable.titleLabel?.font = CustomProperties.shared.basicBoldTextFont
        showMoreLable.titleLabel?.textColor = CustomProperties.shared.textColour
        showMoreLable.translatesAutoresizingMaskIntoConstraints = true
        contentView.addSubview(showMoreLable)
        showMoreLable.layer.cornerRadius = 20
        showMoreLable.addTarget(self, action: #selector(showFullTable), for: .touchUpInside)
        showMoreLable.leftAnchor(contentView.layoutMarginsGuide.leftAnchor, 10)
        showMoreLable.bottomAnchor(contentView.bottomAnchor, constant:0)
        showMoreLable.rightAnchor(contentView.layoutMarginsGuide.rightAnchor, -10)
        return showMoreLable
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        newCategory.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        showMoreLable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setup(_ HomeViewContoller : UIViewController) {
        self.HomeViewContoller = HomeViewContoller
    }
    //show full category table
    @objc func showFullTable(){
        HomeViewContoller?.navigationController?.pushViewController(showFullCategoryTableViewController(), animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func naviagenext(){
        HomeViewContoller?.navigationController?.pushViewController(NextViewController(), animated: true)
    }
    
}
extension CategoryCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
   
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeView_TableViewTableViewCell
        cell.data = .init("testing \(indexPath.row)", 100, nil)
        return cell
        
        //use to calculate cell height
//        UIView.animate(withDuration: 0, animations: {
//        self.tableView.layoutIfNeeded()
//        }) { (complete) in
//            var heightOfTableView: CGFloat = 0.0
//            // Get visible cells and sum up their heights
//            let cells = self.tableView.visibleCells
//            for cell in cells {
//                heightOfTableView += cell.frame.height
//            }
//            // Edit heightOfTableViewConstraint's constant to update height of table view
//            self.heightOfTableViewConstraint.constant = heightOfTableView
//        }
    }
}
