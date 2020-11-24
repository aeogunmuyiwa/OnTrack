//
//  FormValidations.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-23.
//

import UIKit
import Combine



enum Validation : Error {
    case success (value : Any)
    case failure(message: String)
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
    typealias ValidationPublisher = AnyPublisher<Validation, Never>
    typealias ValidationErrorClosure = () -> Validation

class FormValidations {
    

    static func validateAmount( amount : Money?, errorMessage : String ) -> Future < Validation, Never>{
        return Future(){
            promise in
            
          
            
            if amount == nil {
                promise(.success(.failure(message: errorMessage)))
            }else{
               
             
                promise(.success(.success(value: amount)))
            }
        }
                
    }
    
//        let formatter = NumberFormatter()
//        formatter.allowsFloats = true // Default is true, be explicit anyways
//        if formatter.number(from: number) != nil {
//            print(number)
//            return true
//        }
//        print("false")
//        return false // couldn't turn string into a valid number
//      }
}
