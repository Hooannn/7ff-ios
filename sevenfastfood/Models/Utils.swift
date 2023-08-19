//
//  Utils.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 12/08/2023.
//

import Foundation
import Validator

struct ReturnValidationError: ValidationError {

    let message: String
    
    public init(_ message: String) {
        
        self.message = message
    }
}

final class Utils {
    
    public static let shared = Utils()
    
    func minLengthOf6Rule(for str: String) -> any ValidationRule {
        ValidationRuleLength(min: 6, error: ReturnValidationError("\(str) must be at least 6 characters"))
    }
    
    func minLengthOf1Rule(for str: String) -> any ValidationRule {
        ValidationRuleLength(min: 1, error: ReturnValidationError("\(str) must be at least 6 characters"))
    }
    
    func emailRule(for str: String = "Email") -> any ValidationRule {
        ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ReturnValidationError("\(str) must be valid"))
    }
    
    func dictionaryToJson(_ dict: [String: Any]?) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            debugPrint("Parsed error \(error)")
        }
        return nil
    }
}
