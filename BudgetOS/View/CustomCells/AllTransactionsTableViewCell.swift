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
        transactionName.text = "ssss"
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
        transactionDate.text = "test"
        transactionDate.textColor = CustomProperties.shared.lightGray
        transactionDate.font = CustomProperties.shared.basicTextfontStandard
        contentView.addSubview(transactionDate)
        transactionDate.translatesAutoresizingMaskIntoConstraints = true
        transactionDate.topAnchor(transactionName.bottomAnchor, 0)
        transactionDate.leftAnchor(contentView.leftAnchor, 0)
        return transactionDate
    }()
    private lazy var transactionAmount : UILabel = {
        let transactionAmount = UILabel()
        transactionAmount.text = "ssss"
        transactionAmount.textColor = CustomProperties.shared.whiteTextColor
        transactionAmount.font = CustomProperties.shared.basicTextfontStandard
        contentView.addSubview(transactionAmount)
        transactionAmount.translatesAutoresizingMaskIntoConstraints = true
        transactionAmount.centerYAnchor(contentView.centerYAnchor, 0)
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
