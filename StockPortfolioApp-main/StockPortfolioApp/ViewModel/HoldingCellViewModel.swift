//
//  HoldingCellViewModel.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 17/11/24.
//

import UIKit

protocol HoldingCellViewModelType {
    var symbolLabelText: String { get }
    var quantityLabelText: String { get }
    var ltpLabelText: String { get }
    var pnlLabelAttributedText: NSAttributedString { get }
}

struct HoldingCellViewModel: HoldingCellViewModelType {
    private let holding: Holding
    
    init(holding: Holding) {
        self.holding = holding
    }
    
    var symbolLabelText: String {
        holding.symbol
    }
    
    var quantityLabelText: String {
        "NET QTY: \(holding.quantity)"
    }
    
    var ltpLabelText: String {
        "LTP: ₹\(String(format: "%.2f", holding.ltp))"
    }
    
    var pnlLabelAttributedText: NSAttributedString {
        let pnl = (holding.ltp - holding.avgPrice) * Double(holding.quantity)
        let pnlText = String(format: "₹%.2f", pnl)
        let fullPnlText = "P&L: \(pnlText)"
        
        let attributedText = NSMutableAttributedString(string: fullPnlText)
        let pnlColor: UIColor = pnl >= 0 ? .green : .red
        if let pnlRange = fullPnlText.range(of: pnlText) {
            let nsRange = NSRange(pnlRange, in: fullPnlText)
            attributedText.addAttribute(.foregroundColor, value: pnlColor, range: nsRange)
        }
        return attributedText
    }
}
