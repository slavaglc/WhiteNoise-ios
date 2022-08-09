//
//  PremiumManager.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 09.08.2022.
//

import Foundation
import StoreKit

final class PremiumManager {
    static let shared = PremiumManager()
    
    enum PremiumSubscribe: String, CaseIterable {
        case mothly = "whitepointnoise.premium_month"
        case yearly = "whitepointnoise.premium_year"
    }
    
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
//                    switch result {
//                    case .success(let cer)
//                    }
                    print(result)
                }
            }
        }
    }
    
    func getProducts() -> [Product] {
        return products
    }
}
