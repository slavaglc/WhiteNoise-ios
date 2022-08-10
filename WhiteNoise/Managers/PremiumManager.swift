//
//  PremiumManager.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 09.08.2022.
//

import Foundation
import StoreKit

enum PremiumSubscribe: String, CaseIterable {
    case monthly = "whitepointnoise.premium_month"
    case yearly = "whitepointnoise.premium_year"
}

final class PremiumManager {
    static let shared = PremiumManager()
    
    private var products: [Product] = []
    
    func loadProducts() {
        Task.init {
            let productIds: [String] = PremiumSubscribe.allCases.map { $0.rawValue }
            products = try await Product.products(for: productIds)
            print(products)
        }
    }
    
    func purchase(premiumSubscribe: PremiumSubscribe) {
        Task.init {
            for product in products {
                if product.id == premiumSubscribe.rawValue {
                    let result = try! await product.purchase()
                    
                    switch result {
                        
                    case .success(_):
                        print("sucess")
                    case .userCancelled:
                        print("userCancelled")
                    case .pending:
                        print("pending")
                    @unknown default:
                        print("error")
                    }
//                    print(result)
                }
            }
        }
    }
    
    func getProducts() -> [Product] {
        return products
    }
    
    func getPrice(for subscribe: PremiumSubscribe) -> String? {
        for product in products {
            if product.id == subscribe.rawValue {
                return product.price.formatted()
        }
        }
        return nil
    }
    
    
}
