//
//  HoldingCellViewModelTests.swift
//  StockPortfolioAppTests
//
//  Created by Raj Shekhar on 17/11/24.
//

import XCTest
@testable import StockPortfolioApp

class HoldingCellViewModelTests: XCTestCase {
    
    var viewModel: HoldingCellViewModel!
    
    override func setUp() {
        super.setUp()
        let dictionary = ["symbol": "symbol", "quantity": 0, "ltp": 0.0, "avgPrice": 0.0, "close": 0.0] as [String : Any]
        let holding = Holding(dictionary: dictionary)
        viewModel = HoldingCellViewModel(holding: holding!)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialValues() {
        XCTAssertEqual(viewModel.symbolLabelText, "symbol")
        XCTAssertEqual(viewModel.quantityLabelText, "NET QTY: 0")
        XCTAssertEqual(viewModel.ltpLabelText, "LTP: ₹0.00")
    }
}
