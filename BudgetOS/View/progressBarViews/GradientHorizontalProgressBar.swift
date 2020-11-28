//
//  GradientHorizontalProgressBar.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-26.
//

import UIKit
@IBDesignable
class GradientHorizontalProgressBar: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var color: UIColor = .gray {
         didSet { setNeedsDisplay() }
     }

     var progress: CGFloat = 0 {
         didSet { setNeedsDisplay() }
     }

     private let progressLayer = CALayer()
     private let backgroundMask = CAShapeLayer()

     override init(frame: CGRect) {
         super.init(frame: frame)
         setupLayers()
     }

     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setupLayers()
     }

     private func setupLayers() {
        layer.backgroundColor = CustomProperties.shared.lightGray.cgColor
        layer.addSublayer(progressLayer)
     }

     override func draw(_ rect: CGRect) {
       backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
       //  layer.mask = backgroundMask
//        if let progress = progress {
//            
//        }
      
      //  backgroundMask.path = UIBezierPath(rect: CGRect(origin: .zero, size: CGSize(width: rect.width, height: rect.height))).cgPath
        layer.mask = backgroundMask
         let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
         progressLayer.frame = progressRect
         progressLayer.backgroundColor = color.cgColor
     }

}
