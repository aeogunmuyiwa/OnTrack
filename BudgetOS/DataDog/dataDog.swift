//
//  dataDog.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-06.
//

import UIKit
import Datadog

class dataDog: NSObject {

    static let shared = dataDog()
    let ClientToken = "pubbb989c80064dd0ab81f61de4cdd9fdc0"
    var logger : Logger? = nil
    var span : OTSpan? = nil
    func dataDogInit(){
       
        Datadog.initialize(appContext: .init(),configuration: Datadog.Configuration.builderUsing(clientToken: ClientToken, environment: "OnTrack").set(serviceName: "OnTrack").trackUIKitActions(true).enableTracing(true).enableLogging(true).build())
        Datadog.verbosityLevel = .error
        logger = Logger.builder
         .sendNetworkInfo(true)
         .sendLogsToDatadog(true)
         .printLogsToConsole(true, usingFormat: .shortWith(prefix: "[iOS App] "))
         .build()
        Global.sharedTracer = Tracer.initialize(
            configuration: Tracer.Configuration(
                sendNetworkInfo: true
            )
        )
        Global.rum = RUMMonitor.initialize()
       
        logger?.addAttribute(forKey: "device-model", value: UIDevice.current.model)
        logger?.notice("app delegate lunch")

    }
    
    func startSpanc(operationName : String){
        span  = Global.sharedTracer.startSpan(operationName: operationName)
    }
    
    
    func startView(ViewController : UIViewController){
        Global.rum.startView(viewController: ViewController)
    }
    
    func stopView(ViewController : UIViewController){
        Global.rum.stopView(viewController: ViewController)
    }
    
    func rumErrorMessage(message : String){
        Global.rum.addViewError(message: message, source: .source)
    }
    
  

}
