//
//  Utils.swift
//  TestLogin
//
//  Created by s3 on 2/25/21.
//

import Foundation

public struct UserModelLogin {
    var email: String?
    var password: String?
}
enum RuleCheckLogin: String {
    case atLeastOneUppercase = ".*[A-Z]+.*"
    case atLeastOneDigitcase = ".*[0-9]+.*"
    case atLeastOnelowercase = ".*[a-z]+.*"
}

class Utils {
    
    typealias T = AnyClass
    
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isMatchWithRule(_ value: String, regex: String) -> Bool {

        let valuelPred = NSPredicate(format:"SELF MATCHES %@", regex)
        return valuelPred.evaluate(with: value)
    }
    
    static func saveToLocal<T:Codable>(object: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedPerson")
        }
    }
    
    
}
