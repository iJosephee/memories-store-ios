//
//  DetailItemViewController.swift
//  MemoriesStore
//
//  Created by Arnold Giuseppe Dominguez Eusebio on 4/29/19.
//  Copyright © 2019 Arnold Giuseppe Dominguez Eusebio. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var product: Product?
    var counter = 0
    
    @IBOutlet var codeLabel: UILabel?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var priceLabel: UILabel?
    @IBOutlet var stepper: UIStepper?
    @IBOutlet var counterField: UITextField?
    @IBOutlet var addButton: UIButton?
    
    
    override func viewDidLoad() {
        counterField?.text = String(counter)
        if let item = product {
            codeLabel?.text = item.code
            nameLabel?.text = item.name
            priceLabel?.text = String(item.price!)
        }
    }
    
    @IBAction func stepperChanged() {
        if let stepper = stepper {
            print(stepper.value)
            let intValue = Int(stepper.value)
            counterField?.text = String(intValue)
            counter = intValue
            if intValue > 0 {
                addButton?.isEnabled = true
            } else {
                addButton?.isEnabled = false
            }
        }
    }
    
    @IBAction func addTapped() {
        // save items
        if let item = product {
            StorageServices.shared.saveProduct(item.code!, name: item.name!, price: item.price!, counter: counter)
        }
        
        let storyboard = UIStoryboard(name: "CartModule", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "cartNav") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
}
