//
//  CurrencySelectionViewController.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit

class CurrencySelectionViewController: UIViewController {

    private let viewModel: CurrencySelectionViewModel

    // MARK: Initialization
    
    init(viewModel: CurrencySelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CurrencySelectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
}
