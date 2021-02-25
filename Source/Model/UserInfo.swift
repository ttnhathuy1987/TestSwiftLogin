//
//  UserInfo.swift
//  TestLogin
//
//  Created by s3 on 2/25/21.
//

import Foundation
import ObjectMapper

public class UserInfo: Mappable, Codable {
    var userName: String?
    var userId: Int = 0
    var created_at: Date?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        //2020-12-07T04:30:49.822Z
        
        userName    <- map["userName"]
        userId      <- map["userId"]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        if let dateString = map["created_at"].currentValue as? String, let _date = dateFormatter.date(from: dateString) {
            created_at = _date
        }
        
    }
    
    
}


