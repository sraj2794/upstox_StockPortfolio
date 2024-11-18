//
//  HoldingsViewModel.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 17/11/24.
//

import Foundation

protocol HoldingsViewModelType {
    var holdings: [Holding] { get }
    var currentValue: Double { get }
    var totalInvestment: Double { get }
    var totalPNL: Double { get }
    var todaysPNL: Double { get }
    var holdingsCount: Int { get }
    
    func setHoldings(_ holdings: [Holding])
    func holding(at index: Int) -> HoldingCellViewModelType
    func fetchHoldings(completion: @escaping (Bool, Error?) -> Void)
}

final class HoldingsViewModel: HoldingsViewModelType {
    private(set) var holdings: [Holding] = []
    private let holdingsService: HoldingsServiceType
    
    init(holdingsService: HoldingsServiceType) {
        self.holdingsService = holdingsService
    }
    
    func setHoldings(_ holdings: [Holding]) {
        self.holdings = holdings
    }
    
    func fetchHoldings(completion: @escaping (Bool, Error?) -> Void) {
         holdingsService.fetchHoldings {[weak self] result in
             guard let self = self else { return }
             switch result {
             case .success(let holdings):
                 self.setHoldings(holdings)
                 completion(true, nil)
             case .failure(let error):
                 // Attempt to load cached data if API fails
                 if let cachedHoldings = self.loadFromCache() {
                     self.setHoldings(cachedHoldings)
                     print("Loaded cached data due to error: \(error.localizedDescription)")
                     completion(true, nil)
                 } else {
                     completion(false, error)
                 }
             }
         }
     }

     // Function to load data from cache
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
    
    var currentValue: Double {
        return holdings.reduce(0) { $0 + ($1.ltp * Double($1.quantity)) }
    }
    
    var totalInvestment: Double {
        return holdings.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
    }
    
    var totalPNL: Double {
        return currentValue - totalInvestment
    }
    
    var todaysPNL: Double {
        return holdings.reduce(0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
    }
    
    var holdingsCount: Int {
        return holdings.count
    }
    
    func holding(at index: Int) -> HoldingCellViewModelType {
        return HoldingCellViewModel(holding: holdings[index])
    }

}
