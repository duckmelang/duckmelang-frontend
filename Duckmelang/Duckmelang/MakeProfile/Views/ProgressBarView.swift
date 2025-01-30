//
//  ProgressBarView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit

class ProgressBarView: UIView {
    
    private let totalSteps = 4
    private var currentStep: Int = 0 {
        didSet {
            updateProgress()
        }
    }
    
    private var stepViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProgressBar() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        for _ in 0..<totalSteps {
            let stepView = UIView()
            stepView.backgroundColor = UIColor.grey200
            stepView.layer.cornerRadius = 4
            stackView.addArrangedSubview(stepView)
            stepViews.append(stepView)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        updateProgress()
    }
    
    private func updateProgress() {
        for (index, view) in stepViews.enumerated() {
            view.backgroundColor = index <= currentStep ? UIColor.bgcThird : UIColor.grey200
        }
    }
    
    func moveToNextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
        }
    }
}
