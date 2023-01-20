//
//  UIView+Extension.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit

//MARK: View layer shadhow

extension UIView {
    func applyDefaultShadow() {
        shadow()
    }
    
    func shadow(color: UIColor = .black,
                cornerRadius: CGFloat = 8.0,
                shadowOpacity: Float = 0.12,
                shadowRadius: CGFloat = 5.0) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

//MARK: Loading indicator.

extension UIView {
    func showLoading() {
        guard self.viewWithTag(55555) == nil else { return }
    
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = self.center
        activityIndicatorView.tag = 55555
        activityIndicatorView.startAnimating()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addSubview(activityIndicatorView)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewWithTag(55555)?.removeFromSuperview()
        }
    }
}
