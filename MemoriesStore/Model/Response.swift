//
//  Item.swift
//  MemoriesStore
//
//  Created by Arnold Giuseppe Dominguez Eusebio on 4/29/19.
//  Copyright © 2019 Arnold Giuseppe Dominguez Eusebio. All rights reserved.
//

import Foundation
import ObjectMapper

class Response: Mappable {
    
    var products: [Product]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        products <- map["products"]
    }
    
}
