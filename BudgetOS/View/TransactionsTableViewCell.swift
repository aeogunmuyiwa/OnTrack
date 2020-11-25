//
//  TransactionsTableViewCell.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-22.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    let cellId = "TransactionsTableViewCell"
  
    lazy var customAccessoryView: UIButton = {
        let customAccessoryView = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        customAccessoryView.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        customAccessoryView.tintColor = CustomProperties.shared.animationColor
        return customAccessoryView
    }()
    
//    var data : Transaction? {
//        didSet {
//            //set data
//            if let data = data{
//                self.textLabel?.textColor = CustomProperties.shared.textColour
//                self.detailTextLabel?.textColor = CustomProperties.shared.subtextColor
//                self.textLabel?.text = data.transactionDescription
//                if let amount = data.amount{
//                    self.detailTextLabel?.text = "$\(amount)"
//                }
//
//            }
//            self.accessoryType = .disclosureIndicator
//        }
//    }
    var data : OnTractTransaction? {
        didSet {
            //set data
            if let data = data{
                self.textLabel?.textColor = CustomProperties.shared.textColour
                self.detailTextLabel?.textColor = CustomProperties.shared.subtextColor
                self.textLabel?.text = data.transactionDescription
                if let amount = data.amount{
                    self.detailTextLabel?.text = "$\(amount)"
                }
               
            }
            self.accessoryType = .disclosureIndicator
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier:cellId )
        self.accessoryView = customAccessoryView
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

}
