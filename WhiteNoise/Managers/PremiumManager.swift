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

protocol PremiumProtocol  {
    func premiumPurchased()
}

final class PremiumManager {
    
    static let shared = PremiumManager()
    
    private var products: [Product] = []
    private lazy var productIds: [String] = PremiumSubscribe.allCases.map { $0.rawValue }
    private var entitiesWithPremium = Array<PremiumProtocol>()
    
    /// Check if shop available
    func isAvailable() async -> Bool {
        guard let products = try? await Product.products(for: productIds) else { return false }
        return !(products.isEmpty)
    }
    
    /// Loads products
    func loadProducts() {
        Task.init {
            products = try await Product.products(for: productIds)
        }
    }
    
    ///Purchase subscribtion
    func purchase(premiumSubscribe: PremiumSubscribe, completion: @escaping (Product.PurchaseResult)->() = {_ in }) {
        Task.init {
            for product in products {
                if product.id == premiumSubscribe.rawValue {
                    guard let result = try? await product.purchase() else { return }
                    completion(result)
                }
            }
        }
    }
    
    /// Check if premium subscribed
    func isPremiumExist() async -> Bool {
        guard let products = try? await Product.products(for: productIds) else { return false }
        guard !products.isEmpty else { return false }
        guard let state = await products.first?.currentEntitlement else { return false }
        
        switch state {
        case .verified( _):
            print(".verifed")
            return true
        case .unverified( _, _):
            print(".unverified")
            return true
        }
    }
    
    /// Returns all available products
    func getProducts() -> [Product] {
        return products
    }
    
    /// Returns product price
    func getPrice(for subscribe: PremiumSubscribe) -> String? {
        for product in products {
            if product.id == subscribe.rawValue {
                return product.price.formatted()
            }
        }
        return nil
    }
    // Sets entity conformed to PremiumProtocol
    func setEntityForPremium(entity: PremiumProtocol) {
        entitiesWithPremium.append(entity)
    }
    
    ///Refreshes all entities conformed to PremiumProtocol
    func refreshEntities() {
        entitiesWithPremium.forEach { premiumEntity in
            premiumEntity.premiumPurchased()
        }
    }
}
