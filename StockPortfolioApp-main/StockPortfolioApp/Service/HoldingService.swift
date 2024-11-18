//
//  HoldingService.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 17/11/24.
//

import Foundation

protocol HoldingsServiceType {
    func fetchHoldings(completion: @escaping (Result<[Holding], Error>) -> Void)
}

final class HoldingsService: HoldingsServiceType {
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
    
    func fetchHoldings(completion: @escaping (Result<[Holding], Error>) -> Void) {
        guard let url = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        networkManager.makeRequest(url: url) { (result: Result<HoldingsData, Error>) in
            switch result {
            case .success(let holdingsData):
                // Save to cache before returning
                self.saveToCache(holdingsData.data.userHolding)
                completion(.success(holdingsData.data.userHolding))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Save data to cache
    private func saveToCache(_ holdings: [Holding]) {
        do {
            let data = try JSONEncoder().encode(holdings)
            UserDefaults.standard.set(data, forKey: "userHoldingsCache")
        } catch {
            print("Failed to cache holdings: \(error.localizedDescription)")
        }
    }

    // Load data from cache
    private func loadFromCache() -> [Holding]? {
        guard let data = UserDefaults.standard.data(forKey: "userHoldingsCache") else {
            return nil
        }
        do {
            let cachedHoldings = try JSONDecoder().decode([Holding].self, from: data)
            return cachedHoldings
        } catch {
            print("Failed to load cached holdings: \(error.localizedDescription)")
            return nil
        }
    }
}
