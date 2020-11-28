//
//  AllTransactionsTableViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-27.
//

import UIKit

class AllTransactionsTableViewCell: UITableViewCell {
    private lazy var transactionName : UILabel = {
        let transactionName = UILabel()
        transactionName.textColor = CustomProperties.shared.whiteTextColor
        transactionName.font = CustomProperties.shared.basicTextfontStandard
        contentView.addSubview(transactionName)
        transactionName.translatesAutoresizingMaskIntoConstraints = true
        transactionName.topAnchor(contentView.topAnchor, 0)
        transactionName.leftAnchor(contentView.leftAnchor, 0)
        return transactionName
    }()
    
    private lazy var transactionDate : UILabel = {
        let transactionDate = UILabel()
        transactionDate.textColor = CustomProperties.shared.lightGray
        transactionDate.font = CustomProperties.shared.basicTextfontStandard
        contentView.addSubview(transactionDate)
        transactionDate.translatesAutoresizingMaskIntoConstraints = true
        transactionDate.topAnchor(transactionAmount.bottomAnchor, 0)
        transactionDate.rightAnchor(contentView.rightAnchor, 0)
        return transactionDate
    }()
    
    private lazy var transactionCategory : UILabel = {
        let transactionCategory = UILabel()
        transactionCategory.text = "Uncategorized"
        transactionCategory.textColor = CustomProperties.shared.lightGray
        transactionCategory.font = CustomProperties.shared.basicTextfontStandard
        contentView.addSubview(transactionCategory)
        transactionCategory.translatesAutoresizingMaskIntoConstraints = true
        transactionCategory.topAnchor(transactionName.bottomAnchor, 0)
        transactionCategory.leftAnchor(contentView.leftAnchor, 0)
        return transactionCategory
    }()
    
    private lazy var transactionAmount : UILabel = {
        let transactionAmount = UILabel()
        transactionAmount.textColor = CustomProperties.shared.whiteTextColor
        transactionAmount.font = CustomProperties.shared.basicTextfontStandard
        contentView.addSubview(transactionAmount)
        transactionAmount.translatesAutoresizingMaskIntoConstraints = true
        //transactionAmount.centerYAnchor(contentView.centerYAnchor, 0)
        transactionAmount.topAnchor(contentView.topAnchor, 0)
        transactionAmount.rightAnchor(contentView.rightAnchor, 0)
        return transactionAmount
    }()
    
    var data : OnTractTransaction? {
        didSet {
            transactionName.text = data?.transactionDescription
            if let date = data?.date{
                transactionDate.text = CustomProperties.shared.dateFormatter.string(from: Date(timeIntervalSince1970: date))
            }
            if let amount = data?.amount{
                transactionAmount.text = CustomProperties.shared.displayMoney(amount)
            }
            let category = data?.category?.categoryDescription
            if category?.isEmpty == false {
                transactionCategory.text = data?.category?.categoryDescription
            }
            
        }
    }
    
    func setup(textColor : UIColor?){
        if let textColor = textColor {
            transactionName.textColor = textColor
            transactionAmount.textColor = textColor
        }

    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        transactionName.translatesAutoresizingMaskIntoConstraints = false
        transactionDate.translatesAutoresizingMaskIntoConstraints = false
        transactionAmount.translatesAutoresizingMaskIntoConstraints = false
        transactionCategory.translatesAutoresizingMaskIntoConstraints = false
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

}
