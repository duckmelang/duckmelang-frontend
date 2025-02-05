//
//  SignupViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit

class SignupViewController: UIViewController {
    
    private let progressBarView = ProgressBarView()
    private let containerView = UIView()
    private let nextButton = UIButton()

    private var currentStep = 0
    private let stepViews: [UIView] = [
        MakeProfileView(),
        SelectFavoriteCelebView(),
        SelectEventView(),
        FilterKeywordsView()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        setupUI()
        showStep(step: 0)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
            
        self.navigationItem.title = "회원가입"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)
        ]
            
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(progressBarView)
        view.addSubview(containerView)
        view.addSubview(nextButton)
        
        progressBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(4)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .lightGray
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
    }
    
    private func showStep(step: Int) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        let newStepView = stepViews[step]
        containerView.addSubview(newStepView)
        
        newStepView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func nextStep() {
        if currentStep < stepViews.count - 1 {
            currentStep += 1
            showStep(step: currentStep)
            progressBarView.moveToNextStep()
        } else {
            let splashViewController = BlueSplashViewController()
            splashViewController.modalPresentationStyle = .fullScreen
            splashViewController.modalTransitionStyle = .crossDissolve

            if let window = view.window {
                window.rootViewController = splashViewController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { _ in
                    // 1.5초 후 BaseViewController로 전환
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        let baseViewController = BaseViewController()
                        let navigationController = UINavigationController(rootViewController: baseViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        navigationController.modalTransitionStyle = .crossDissolve

                        window.rootViewController = navigationController
                        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                    }
                }
            }
        }
    }
}
