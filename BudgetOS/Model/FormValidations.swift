//
//  FormValidations.swift
//  BudgetOS
//
//  Created by Adebayo  Ogunmuyiwa on 2020-11-23.
//

import UIKit
import Combine



enum Validation : LocalizedError {
    case failure
}


    typealias ValidationPublisher = AnyPublisher<Validation, Never>
    typealias ValidationErrorClosure = () -> Validation

class FormValidations {
    
    static let shared = FormValidations()
  
    func ValidateTransaction (_ amount : Money?, _ text : String? , invalidAmount : @escaping( ErrorMessages) -> Void, invalidText : @escaping( ErrorMessages) -> Void) -> Future <(Money, String) , Never>{
        return Future() { [weak self] promise in
         
            let validateAmount_ =  self?.validateAmount(amount: amount, errorMessage: ErrorMessages.InvalidAmount)
            let validateText_ = self?.validateText(text: text)
            if let validateText = validateText_ , let validateAmount = validateAmount_ {
                let  combinedValidator = Publishers.Zip(validateAmount, validateText)
                combinedValidator.sink(receiveCompletion: { errorMessage in
                    switch errorMessage {
                    case .failure(.InvalidAmount): invalidAmount(.InvalidAmount)
                    case.failure(.InvalidText) : invalidText(.InvalidText)
                    case .finished : ()
                    }
                }, receiveValue: { result in
                    promise(.success(result))
                })
          
            }
           
        }
        
    
        
        
    }
    
    
    //Mark : amount validator
    func validateAmount( amount : Money?, errorMessage : ErrorMessages ) -> Future < Money , ErrorMessages>{
        return Future(){
            promise in
            
            if var amount = amount {
                var result = Money()
                NSDecimalRound(&result, &amount, CustomProperties.shared.decimalScale, .plain)
                promise(.success(result))
                
            }
            //amount is nill
            promise(.failure(.InvalidAmount))
        }
    }
        
    //Mark text validator
        func validateText (text  : String?) -> Future <String , ErrorMessages> {
            return Future () { promise in
                if let text = text {
                    if text.isEmpty {
                        promise(.failure(.InvalidText))
                    }
                    promise(.success(text))
                }
                promise(.failure(.InvalidText))
               
            }
        }
}



