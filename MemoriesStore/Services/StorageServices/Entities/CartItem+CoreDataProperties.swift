//
//  CartItem+CoreDataProperties.swift
//  
//
//  Created by Arnold Giuseppe Dominguez Eusebio on 4/30/19.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var counter: Int32

}
