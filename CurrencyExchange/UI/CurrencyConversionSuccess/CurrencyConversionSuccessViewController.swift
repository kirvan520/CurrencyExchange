//
//  CurrencyConversionSuccessViewController.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit
import Combine

class CurrencyConversionSuccessViewController: UIViewController {
    
    @IBOutlet weak var successMessageLabel: UILabel!
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: CurrencyConversionSuccessViewModel
    
    // MARK: Initialization
    
    init(viewModel: CurrencyConversionSuccessViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CurrencyConversionSuccessViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        let rightBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        viewModel.$successMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                
                self.successMessageLabel.text = text
            }.store(in: &cancellables)
    }
    
    @objc private func doneButtonAction(_ sender: UIBarButtonItem) {
        viewModel.showCurrencySelectionScreen.send()
    }
}
