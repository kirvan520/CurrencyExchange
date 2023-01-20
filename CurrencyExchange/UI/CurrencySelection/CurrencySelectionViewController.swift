//
//  CurrencySelectionViewController.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit

class CurrencySelectionViewController: UIViewController {

    @IBOutlet weak var currencySelectionContainer: UIView!
    @IBOutlet weak var baseCurrencyContainer: UIView!
    @IBOutlet weak var targetCurrencyContainer: UIView!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var amountInputTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
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
    }
    
    // MARK: Private methods
    
    private func setupView() {
        currencySelectionContainer.applyDefaultShadow()
        baseCurrencyContainer.applyDefaultShadow()
        targetCurrencyContainer.applyDefaultShadow()
        calculateButton.applyDefaultShadow()
    }
    
    
    // MARK: UIButton action methods

    @IBAction func baseCurrencyArrowButtonAction(_ sender: Any) {
        showCurrencyPickerView()
    }
    
    @IBAction func targetCurrencyArrowButtonAction(_ sender: Any) {
        showCurrencyPickerView()
    }
    
    @IBAction func calculateButtonAction(_ sender: Any) {
    }
    
}

var supportedCodes = [
    ["AED", "UAE Dirham"],
    ["AFN", "Afghan Afghani"],
    ["ALL","Albanian Lek"],
    ["AMD","Armenian Dram"],
    ["ANG","Netherlands Antillian Guilder"],
    ["AOA","Angolan Kwanza"],
    ["ARS","Argentine Peso"],
    ["AUD","Australian Dollar"],
    ["AWG","Aruban Florin"]
]

extension CurrencySelectionViewController {
    func showCurrencyPickerView() {
        let size = CGSize(width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height / 2)
        
        let viewController = UIViewController()
        viewController.preferredContentSize = size
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        picker.dataSource = self
        picker.delegate = self
                
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

extension CurrencySelectionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        supportedCodes.count
    }
}

extension CurrencySelectionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 30))
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        let currency = supportedCodes[row]
        if let fullName = currency.last, let code = currency.first {
            label.text = "\(fullName) -- \(code)"
        }
        label.sizeToFit()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
