//
//  StoreService.swift
//  MemoriesStore
//
//  Created by Arnold Giuseppe Dominguez Eusebio on 4/29/19.
//  Copyright © 2019 Arnold Giuseppe Dominguez Eusebio. All rights reserved.
//

import Foundation

/**
 This class make the web request using URLSession
 */

class NetworkServices {
    
    public static let shared = NetworkServices()
    
    func getStoreItems(completion callback: @escaping(_ result: Bool, _ description: [Product]) -> Void ) {
        guard let storeURL = URL(string: Constants.getStoreURL) else {
            callback(false, [])
            return
        }
        var urlRequest = URLRequest(url: storeURL)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                callback(false, [])
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                callback(false, [])
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                print(string)
            } else if let mimeType = httpResponse.mimeType, mimeType == "application/json", let data = data, let string = String(data: data, encoding:  .utf8) {
                // Parse response into model
                let response = Response(JSONString: string)
                let store: [Product] = response?.products ?? []
                callback(true, store)
            }
        }
        task.resume()
    }
}
