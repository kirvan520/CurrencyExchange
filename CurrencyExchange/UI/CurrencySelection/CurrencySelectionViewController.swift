//
//  CurrencySelectionViewController.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit
import Combine

class CurrencySelectionViewController: UIViewController {
    
    @IBOutlet weak var currencySelectionContainer: UIView!
    @IBOutlet weak var baseCurrencyContainer: UIView!
    @IBOutlet weak var targetCurrencyContainer: UIView!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var amountInputTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    private var cancellables: Set<AnyCancellable> = []
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
        
        setupView()
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupView() {
        currencySelectionContainer.applyDefaultShadow()
        baseCurrencyContainer.applyDefaultShadow()
        targetCurrencyContainer.applyDefaultShadow()
        calculateButton.applyDefaultShadow()
    }
    
    private func setupBindings() {
        
        viewModel.getSupportedCurrencyCodes()
        
        // show/hide loading indicator.
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .isLoading:
                    self.view.showLoading()
                case .isFinished:
                    self.view.hideLoading()
                case .failed(let error):
                    print(error)
                }
            }.store(in: &cancellables)
        
        // Update base currency.
        viewModel.$baseCurrency.sink { [weak self] baseCurrency in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.baseCurrencyLabel.text = baseCurrency
            }
        }.store(in: &cancellables)
        
        // Update target currency.
        viewModel.$targetCurrency.sink { [weak self] targetCurrency in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.targetCurrencyLabel.text = targetCurrency
            }
        }.store(in: &cancellables)
        
        //Show currency selection picker
        viewModel.showCurrencySelectionPickerView.sink { [weak self] in
            guard let self = self else { return }
            
            self.showCurrencyPickerView()
        }
        .store(in: &cancellables)
    }
    
    // MARK: UIButton action methods
    
    @IBAction func baseCurrencyArrowButtonAction(_ sender: Any) {
        viewModel.isBaseCurrencySelected = true
    }
    
    @IBAction func targetCurrencyArrowButtonAction(_ sender: Any) {
        viewModel.isBaseCurrencySelected = false
    }
    
    @IBAction func calculateButtonAction(_ sender: Any) {
    }
    
}

// MARK: Showing UIPickerView

extension CurrencySelectionViewController {
    func showCurrencyPickerView() {
        let size = CGSize(width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height / 2)
        
        let viewController = UIViewController()
        viewController.preferredContentSize = size
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        picker.dataSource = self
        picker.delegate = self

        picker.selectRow(viewModel.selectedCurrencyRow, inComponent: 0, animated: false)

        viewController.view.addSubview(picker)
        picker.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Currency", message: "", preferredStyle: .actionSheet)
        alert.setValue(viewController, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UIPickerViewDataSource

extension CurrencySelectionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.supportedCurrencyCodes.count
    }
}

// MARK: UIPickerViewDelegate

extension CurrencySelectionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 30))
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        let currency = viewModel.supportedCurrencyCodes[row]
        if let fullName = currency.last, let code = currency.first {
            label.text = "\(fullName) -- \(code)"
        }
        label.sizeToFit()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.pickerViewSelectedRow = row
    }
}
