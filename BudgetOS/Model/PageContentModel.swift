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
        default: ()
        }
    }
    
    
    
    func reloadDatasoruce(){
        let reloadPublsiher =  NotificationCenter.Publisher.init(center: .default, name: .reloadAnalytics)
        reloadtables = reloadPublsiher.sink(receiveValue: { value in
            self.dataSource()
        })

    }
    
    
}

