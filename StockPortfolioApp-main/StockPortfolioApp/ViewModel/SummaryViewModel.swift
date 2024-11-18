//
//  SummaryViewModel.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 17/11/24.
//

import UIKit

protocol SummaryViewModelType {
    var currentValueText: String { get }
    var totalInvestmentText: String { get }
    var totalPNLText: String { get }
    var todaysPNLText: String { get }
    var todaysPNLColor: UIColor { get }
    var totalPNLColor: UIColor { get }
}

struct SummaryViewModel: SummaryViewModelType {
    private let currentValue: Double
    private let totalInvestment: Double
    private let totalPNL: Double
    private let todaysPNL: Double
    
    init(currentValue: Double, totalInvestment: Double, totalPNL: Double, todaysPNL: Double) {
        self.currentValue = currentValue
        self.totalInvestment = totalInvestment
        self.totalPNL = totalPNL
        self.todaysPNL = todaysPNL
    }

    var currentValueText: String {
        return formatCurrency(currentValue)
    }

    var totalInvestmentText: String {
        return formatCurrency(totalInvestment)
    }

    var totalPNLText: String {
        let percentage = totalInvestment != 0 ? (totalPNL / totalInvestment * 100) : 0
        return "\(formatCurrency(totalPNL)) (\(String(format: "%.2f", percentage))%)"
    }

    var todaysPNLText: String {
        return formatCurrency(todaysPNL)
    }

    var todaysPNLColor: UIColor {
        return todaysPNL >= 0 ? .green : .red
    }

    var totalPNLColor: UIColor {
        return totalPNL >= 0 ? .green : .red
    }

    private func formatCurrency(_ value: Double) -> String {
        return "₹\(String(format: "%.2f", value))"
    }
}
