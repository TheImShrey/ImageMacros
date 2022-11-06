//
//  UIViewController + Ext.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import UIKit


extension UIViewController {
    
    @discardableResult
    func showToast(message : String, font: UIFont = .systemFont(ofSize: 14, weight: .semibold), duration: Double = 3) -> UIView {
        
        let toastLabel = UILabel()
        toastLabel.numberOfLines = 0
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        
        let toastView = UIView()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastView.alpha = 1.0
        toastView.layer.cornerRadius = 10;
        toastView.clipsToBounds = true
        
        toastView.addSubview(toastLabel)
        view.addSubview(toastView)
        
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        toastView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.centerYAnchor.constraint(equalTo: toastView.centerYAnchor).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: toastView.centerXAnchor).isActive = true
        toastLabel.heightAnchor.constraint(equalTo: toastView.heightAnchor, constant: -20).isActive = true
        toastLabel.widthAnchor.constraint(equalTo: toastView.widthAnchor, constant: -20).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveEaseOut, animations: {[weak toastView] in
                toastView?.alpha = 0.0
            }, completion: {[weak toastView] (isCompleted) in
                toastView?.removeFromSuperview()
            })
        }
        
        return toastView
    }
}
