//
//  CartViewController.swift
//  MemoriesStore
//
//  Created by Arnold Giuseppe Dominguez Eusebio on 4/29/19.
//  Copyright © 2019 Arnold Giuseppe Dominguez Eusebio. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet var cartTableView: UITableView?
    var totalPayment = 0.0
    
    
    var items: [CartItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        items = StorageServices.shared.fetchItems()
        cartTableView?.register(UINib(nibName: "CartItemCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
    }
    
    /**
     This function takes a CartItem and populate the cell with
     */
    
    func configureCell(_ item: CartItem, forCell cell: CartItemCell) {
        let counter = Int(item.counter)
        let price = item.price
        let total = Double(counter) * price
        cell.productNameLabel?.text = item.name
        cell.productCounterLabel?.text = String(counter)
        cell.productPriceLabel?.text = String(price)
        cell.totalLabel?.text = String(total)
    }
    
    func applyPromo(_ item: CartItem, forCell cell: CartItemCell) {
        let counter = Int(item.counter)
        let price = item.price
        let total = Double(counter) * price
        if item.code == "TSHIRT" {
            if item.counter >= 3 {
                cell.discountLabel?.isHidden = false
                cell.promoLabel?.isHidden = false
                cell.discountLabel?.text = "+3 = 19"
                
                let totalDiscount = Double(counter) * 19.0
                
                cell.totalDiscountLabel?.isHidden = false
                cell.totalDiscountLabel?.text = String(totalDiscount)
                cell.textTotalLabel?.isHidden = false
                
                totalPayment += totalDiscount
            } else {
                totalPayment += total
            }
        } else if item.code == "VOUCHER" {
            let promos = counter / 2
            if promos >= 1 {
                cell.discountLabel?.isHidden = false
                cell.promoLabel?.isHidden = false
                cell.discountLabel?.text = "2x1"
                
                let rest = counter - (promos * 2)
                let discount = Double(promos) * price
                let totalDiscount = discount + (Double(rest) * price)
                
                cell.totalDiscountLabel?.isHidden = false
                cell.totalDiscountLabel?.text = String(totalDiscount)
                cell.textTotalLabel?.isHidden = false
                
                totalPayment += totalDiscount
            } else {
                totalPayment += total
            }
        } else {
            totalPayment += total
        }
    }
    
    func removePromo(_ item: CartItem, forCell cell: CartItemCell) {
        let counter = Int(item.counter)
        let price = item.price
        let total = Double(counter) * price
        if item.code == "TSHIRT" {
            // In order to remove any discount, we check if has a coupon applied
            if item.counter >= 3 {
                // if has a coupon applied, remove the total with discount
                let totalDiscount = Double(counter) * 19.0
                totalPayment -= totalDiscount
            } else {
                // if doesn't have a coupon applied, only remove the total of products
                totalPayment -= total
            }
        } else if item.code == "VOUCHER" {
            let promos = counter / 2
            if promos >= 1 {
                // if has a coupon applied, remove the total with discount
                let rest = counter - (promos * 2)
                let discount = Double(promos) * price
                let totalDiscount = discount + (Double(rest) * price)
                totalPayment -= totalDiscount
            } else {
                // if doesn't have a coupon applied, only remove the total of products
                totalPayment -= total
            }
        } else {
            // this case is for items that doesn't have any promotion
            totalPayment -= total
        }
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pay() {
        let message = String(totalPayment)
        let alert = UIAlertController(title: "Total", message:message , preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        let cartItem = items[indexPath.row]
        configureCell(cartItem, forCell: cell)
        applyPromo(cartItem, forCell: cell)
        return cell
    }
    
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cartItem = items[indexPath.row]
            let cell = cartTableView?.cellForRow(at: indexPath) as! CartItemCell
            removePromo(cartItem, forCell: cell)
            // delete object in database
            let success = StorageServices.shared.deleteItems(cartItem.code!, counter: Int(cartItem.counter))
            if success {
                // if success update view
                items.remove(at: indexPath.row)
                cartTableView?.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
