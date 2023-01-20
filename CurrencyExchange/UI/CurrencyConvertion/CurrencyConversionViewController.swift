//
//  CurrencyConversionViewController.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit
import Combine

class CurrencyConversionViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: CurrencyConversionViewModel
    
    // MARK: Initialization
    
    init(viewModel: CurrencyConversionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CurrencyConversionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupView() {
        containerView.applyDefaultShadow()
        baseCurrencyLabel.applyDefaultShadow()
        targetCurrencyLabel.applyDefaultShadow()
        convertButton.applyDefaultShadow()
    }
    
    private func setupBindings() {
        
        viewModel.$timeLeftLabelText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                
                self.timeLeftLabel.text = text
            }.store(in: &cancellables)
        
        viewModel.$timeLeftLabelColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] textColor in
                guard let self = self else { return }
                
                self.timeLeftLabel.textColor = textColor
            }.store(in: &cancellables)
        
        viewModel.showTimeoutAlert
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.showTimeOutError()
            }.store(in: &cancellables)
        
        viewModel.$timeLeftLabelColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] textColor in
                guard let self = self else { return }
                
                self.timeLeftLabel.textColor = textColor
            }.store(in: &cancellables)
        
        viewModel.$baseCurrencyLabelText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                
                self.baseCurrencyLabel.text = value
            }.store(in: &cancellables)
        
        viewModel.$targetCurrencyLabelText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                
                self.targetCurrencyLabel.text = value
            }.store(in: &cancellables)
    }
    
    private func showTimeOutError() {
        let alert = UIAlertController(title: nil,
                                      message: "Session has expired. Please start again!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: false)
    }
    
    // MARK: UIButton action methods
    
    @IBAction func convertButtonAction(_ sender: Any) {
        viewModel.handleConvertAction()
    }
    
}
