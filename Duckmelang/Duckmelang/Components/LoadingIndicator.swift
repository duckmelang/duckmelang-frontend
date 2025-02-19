//
//  LoadingIndicator.swift
//  Duckmelang
//
//  Created by 주민영 on 2/19/25.
//

import UIKit

class LoadingIndicator: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        self.addSubview(activityIndicator)
        activityIndicator.center = self.center
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        self.isHidden = false
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        self.isHidden = true
    }
}
