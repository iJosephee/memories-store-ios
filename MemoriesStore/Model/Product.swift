//
//  Product.swift
//  MemoriesStore
//
//  Created by Arnold Giuseppe Dominguez Eusebio on 4/29/19.
//  Copyright © 2019 Arnold Giuseppe Dominguez Eusebio. All rights reserved.
//

import Foundation
import ObjectMapper

class Product: Mappable {
    
    var code: String?
    var name: String?
    var price: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
        price <- map["price"]
    }
    
}
