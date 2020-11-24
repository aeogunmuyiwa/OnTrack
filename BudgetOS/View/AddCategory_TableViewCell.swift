//
//  AddCategory_TableViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-21.
//

import UIKit
import Combine

class AddCategory_TableViewCell: UITableViewCell {
    let cellId = "AddCategory_TableViewCell"
    var viewController : UIViewController?
    private var CategoryStruct_subscriber : AnyCancellable?
    private lazy var CategoryStruct_publisher = PassthroughSubject<CategoryStruct, Never>()
    lazy var CategoryStruct_publisherAction = CategoryStruct_publisher.eraseToAnyPublisher()
    
    
    
    
    lazy var newTransaction: UIButton = {
        let newTransaction = UIButton()
        newTransaction.setImage(CustomProperties.shared.tintedColorImage, for: .normal)
        newTransaction.addTarget(self, action: #selector(Addtransaction), for: .touchUpInside)
        newTransaction.translatesAutoresizingMaskIntoConstraints = true
        contentView.addSubview(newTransaction)
        newTransaction.titleLabel?.font = CustomProperties.shared.basicBoldTextFont
        newTransaction.titleLabel?.textColor = CustomProperties.shared.textColour
        newTransaction.topAnchor(contentView.layoutMarginsGuide.topAnchor, 0)
        newTransaction.rightAnchor(contentView.rightAnchor, 0)
        return newTransaction
    }()
    
    //MARK : Base card view for adding a new category
    lazy var addCategory_baseCard : AddCategory_baseCard = {
        let addCategory_baseCard = AddCategory_baseCard.init(AddCategoryModel: CategoryStruct_publisher)
        addCategory_baseCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addCategory_baseCard)
        addCategory_baseCard.topAnchor(newTransaction.layoutMarginsGuide.bottomAnchor, 20)
        addCategory_baseCard.leftAnchor(contentView.layoutMarginsGuide.leftAnchor, 0)
        addCategory_baseCard.rightAnchor(contentView.layoutMarginsGuide.rightAnchor, 0)
        addCategory_baseCard.bottomAnchor(contentView.layoutMarginsGuide.bottomAnchor, constant: 0)
        return addCategory_baseCard
    }()
    
    //handle publisher envents and set datasource
    func handlePublisherSubscriber(){
        CategoryStruct_subscriber = CategoryStruct_publisherAction
            .sink(receiveValue: { [weak self] (receiveValue) in
                
                
                if ( receiveValue.category == nil || receiveValue.category == "" ){
                    self?.viewController?.navigationItem.rightBarButtonItem?.isEnabled = false
                }else{
                    self?.viewController?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
               // self?.datasource = receiveValue
            })
    }
    
    //Mark:  reference viewController
    func setup(_ viewController : UIViewController , datasource : CategoryStruct? ){
        self.viewController = viewController
    }
    
    func setupdataSourceToUI(datasource : CategoryStruct){
        
    }


    //init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: cellId)
        newTransaction.translatesAutoresizingMaskIntoConstraints = false
        addCategory_baseCard.translatesAutoresizingMaskIntoConstraints = false
        handlePublisherSubscriber()
        self.backgroundColor = .clear
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Mark: transition to addTransaction controller
    @objc func Addtransaction( ){
        let vc = AddTransactionViewController()
        vc.dataSource = .init(transactionStatus: .new, index: nil, transaction: nil)
        //vc.categoryDatasource = datasource
        let navbar: UINavigationController = UINavigationController(rootViewController: vc)
        navbar.navigationBar.backgroundColor = CustomProperties.shared.animationColor
        
        viewController?.present(navbar, animated: true, completion: nil)
    }
    
    

}

