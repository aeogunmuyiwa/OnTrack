//
//  PageContentModel.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-03.
//

import UIKit
import Combine
import CareKit
class PageContentModel: NSObject {

    var page: AnalyticsPages
    private var reloadtables: AnyCancellable?
    weak var controller : UIViewController?
    lazy var chartView: OCKCartesianChartView = {
        let chartView = OCKCartesianChartView(type: .bar)
        if let controller = controller {
            controller.view.addSubview(chartView)
            chartView.translatesAutoresizingMaskIntoConstraints = false
            chartView.pin(to: controller.view)
        }
        
        return chartView
    }()
    
    init(page : AnalyticsPages, controller : UIViewController) {
        self.page = page
        self.controller = controller
        super.init()
        self.chartView.translatesAutoresizingMaskIntoConstraints = false
        dataSource()
        reloadDatasoruce()
    }
    
    func dataSource(){
        switch page {
        case .pageZero , .pageOne:
            if let data  = page.data as? analytics_sortbyweekday {
                chartView.graphView.horizontalAxisMarkers = data.horizontalAxisMarker
                chartView.headerView.titleLabel.text = page.name
                let values = CustomProperties.shared.convertWeekdayNSdecimalToFloat(data.data)
                chartView.graphView.dataSeries = [
                    OCKDataSeries(values:  values, title: data.headerTitle, size: 14, color: data.color)
    
                ]
                chartView.graphView.yMinimum = values.min()
                chartView.graphView.yMaximum = values.max()
            }
        case .pageTwo :
            if let data = page.data as? BudgetVSTransaction {
                var budget = data.budgetValues
                var actual = data.actualValues
                var horizintalAxis = data.horizontalAxisMarker
                if data.horizontalAxisMarker.count < 2 {
                    budget.append(0)
                    actual.append(0)
                    horizintalAxis.append("")
                }
                
            
                    horizintalAxis =  horizintalAxis.map({item in
                    
                       let firstCharacter = item.prefix(1)
                            return String(firstCharacter)
                    })
                
                chartView.graphView.horizontalAxisMarkers = horizintalAxis
                chartView.headerView.titleLabel.text = page.name
                chartView.graphView.dataSeries = [
                    OCKDataSeries(values: actual, title: "Transactions", size: 10, color: CustomProperties.shared.animationColor),
                    OCKDataSeries(values: budget, title: "Budget", size: 14, color: CustomProperties.shared.lightGray)
                ]
                if budget.min() ?? 0 < actual.min() ?? 0 {
                    chartView.graphView.yMinimum = budget.min() ?? 0
                }else{
                    chartView.graphView.yMinimum = actual.min() ?? 0
                }
                if actual.max() ?? 0 > budget.max() ?? 0{
                    chartView.graphView.yMaximum = actual.max()
                }else{
                    chartView.graphView.yMaximum = budget.max()
                }
            }
        }
    }
    
    
    
    func reloadDatasoruce(){
        let reloadPublsiher =  NotificationCenter.Publisher.init(center: .default, name: .reloadAnalytics)
        reloadtables = reloadPublsiher.sink(receiveValue: { value in
            self.dataSource()
        })

    }
    
    
}

