//
//  ViewController.swift
//  MemoriesStore
//
//  Created by Arnold Giuseppe Dominguez Eusebio on 4/29/19.
//  Copyright © 2019 Arnold Giuseppe Dominguez Eusebio. All rights reserved.
//

import UIKit

/**
 This class is the first that is shown in the app
 */

class MarketViewController: UIViewController {
    
    var items: [Product] = []
    @IBOutlet var itemsTable: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch items to populate the table view
        NetworkServices.shared.getStoreItems { (success, response) in
            if success {
                self.items = response
                DispatchQueue.main.async {
                    self.itemsTable?.reloadData()
                }
            } else {
                // Present error alert
                let alert = UIAlertController(title: "Error", message: NSLocalizedString("ERROR.Store.Products", comment: ""), preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(actionOK)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cartButtonTapped() {
        let storyboard = UIStoryboard(name: "CartModule", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "cartNav") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }

}

extension MarketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "itemCell")
        }
        cell?.textLabel?.text = items[indexPath.row].name
        return cell!
    }
}

extension MarketViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ProductDetailModule", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ItemDetail") as! ProductDetailViewController
        controller.product = items[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
