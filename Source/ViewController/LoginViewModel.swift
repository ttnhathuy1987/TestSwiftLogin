//
//  LoginViewModel.swift
//  TestLogin
//
//  Created by s3 on 2/25/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

enum TypeField: String {
    case email = "email"
    case password = "password"
    case alert = "alert"
}

protocol LoginViewModelProtocol {
    func showAlertLogin(meessae: String, type: TypeField)
    func validAtField(type: TypeField)
}

extension LoginViewModelProtocol {
    func showAlertLogin(meessae: String, type: TypeField) {
        
    }
    
    func validAtField(type: TypeField) {
        
    }
}

class LoginViewModel:LoginViewModelProtocol {
    
    var owner: LoginViewModelProtocol?
    
    var userLogin = UserModelLogin()
    
    func checkInvalidEmail(email: String?) {
        guard email != nil else {
            alertErro(meessae: "Email or Password must have value",type: .email)
            return
        }
        
        guard Utils.isEmailValid(email!) else {
            alertErro(meessae: "Email is invalid",type: .email)
            return
        }
        owner?.validAtField(type: .email)
        userLogin.email = email
    }
    
    func checkInvalidPassword(password: String?) {
        guard password!.count < 17, password!.count > 2 else {
            alertErro(meessae: "Password must have 3-16 charater", type: .password)
            return
        }
        
        guard Utils.isMatchWithRule(password!, regex: RuleCheckLogin.atLeastOneUppercase.rawValue), Utils.isMatchWithRule(password!, regex: RuleCheckLogin.atLeastOnelowercase.rawValue), Utils.isMatchWithRule(password!, regex: RuleCheckLogin.atLeastOneDigitcase.rawValue) else {
            alertErro(meessae: "Password must have at least 1 uppercase, 1 digit number, 1 lowercase", type: .password)
            return
        }
        owner?.validAtField(type: .password)
        userLogin.password = password
    }
    
    func callApiWithData() {
        
        let dicData = ["email":userLogin.email ?? "", "password": userLogin.password ?? ""]
        
        let url = URL(string: "http://imaginato.mocklab.io/login")
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONSerialization.data(withJSONObject: dicData, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        
        AF.request(request).responseJSON { [weak self] response in
                            // do whatever you want here
            print(response.response ?? "")
            if let status = response.response?.statusCode {
                switch(status){
                case 201,200:
                    print("example success")
                    if let json = response.data {
                        do{
                            if let jsonData = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] {
                                if let str = jsonData["data"] as? [String: Any], let valueUser = str["user"] as? [String : Any] {
                                    if let userReturn = Mapper<UserInfo>().map(JSON: valueUser) {
                                        // Save User to User Default
                                        Utils.saveToLocal(object: userReturn)
                                        self?.owner?.showAlertLogin(meessae: "Login successful!", type: .alert)
                                    }
                                }
                            }
                        }
                        catch{
                            print("JSON Error")
                        }
                    }
                default:
                    print("error with response status: \(status)")
                    self?.owner?.showAlertLogin(meessae: "Login fail!", type: .alert)
                }
            }
        }
    }
    
    func alertErro(meessae: String, type: TypeField) {
        owner?.showAlertLogin(meessae: meessae,type: type)
    }
}
