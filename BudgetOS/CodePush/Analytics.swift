//
//  Analytics.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-02.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

class Analytics {

    static let shard = Analytics()
    
     func basicstart(){
        AppCenter.start(withAppSecret: "77c0669e-8963-4670-88d5-37d3bfa471ab", services:[
          Analytics.self,
          Crashes.self
        ])
    }
     func main(){
        AppCenter.start(withAppSecret: "77c0669e-8963-4670-88d5-37d3bfa471ab", services:[
          Crashes.self
        ])
    }
  
}
