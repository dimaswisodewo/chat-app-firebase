//
//  LoadingViewController.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 26/05/23.
//

import UIKit

class LoadingViewController: UIViewController {

    private let loadingActivityIndicator: UIActivityIndicatorView = {
       
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        
        indicator.startAnimating()
        
        indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        return indicator
    }()
    
    private let blurEffect: UIVisualEffectView = {
       
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        return visualEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        blurEffect.frame = view.bounds
        view.insertSubview(blurEffect, at: 0)
        
        loadingActivityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(loadingActivityIndicator)
    }
    
}
