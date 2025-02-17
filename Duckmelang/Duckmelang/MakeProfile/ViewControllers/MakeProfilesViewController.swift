//
//  MakeProfilesViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import Moya

class MakeProfilesViewController: UIViewController {
    
    private let memberId: Int
    private let progressBarView = ProgressBarView()
    private let containerView = UIView()
    private let nextButtonView = NextButtonView()

    private var currentStep = 0
    private let stepVCs: [UIViewController]

    init(memberId: Int) {
        self.memberId = memberId
        self.stepVCs = [
            SetupNickBirthGenViewController(memberId: memberId),
            SelectFavoriteCelebViewController(),
            SelectEventViewController(),
            FilterKeywordsViewController()
        ]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        setupUI()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        view.addSubview(nextButtonView)

        progressBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(4)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButtonView.snp.top).offset(-20)
        }
        
        nextButtonView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
    }
    private func setupActions() {
        nextButtonView.nextButton.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func handleNextButtonTapped() {
        print("📌 nextButton 눌림 - 현재 step: \(currentStep)")

        // 현재 활성화된 VC가 요청 신호 보내도록 설정
        if let currentVC = stepVCs[currentStep] as? NextStepHandler {
            currentVC.handleNextStep { [weak self] in
                self?.nextStep() // 현재 VC가 요청을 완료하면 다음 단계로 이동
            }
        } else {
            print("❌ 현재 VC에서 NextStepHandler 프로토콜을 구현하지 않음")
        }
    }
    private func showStep(step: Int) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        let newStepVC = stepVCs[step]
        addChild(newStepVC)
        containerView.addSubview(newStepVC.view)
        newStepVC.view.translatesAutoresizingMaskIntoConstraints = false
        newStepVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        newStepVC.didMove(toParent: self)
    }

    @objc private func nextStep() {
        if currentStep < stepVCs.count - 1 {
            currentStep += 1
            showStep(step: currentStep)
            progressBarView.moveToNextStep()
        } else {
            navigateToNextScreen()
        }
    }

    private func navigateToNextScreen() {
        let splashViewController = BlueSplashViewController()
        splashViewController.modalPresentationStyle = .fullScreen
        splashViewController.modalTransitionStyle = .crossDissolve
        if let window = view.window {
            window.rootViewController = splashViewController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let baseViewController = BaseViewController()
                    let navigationController = UINavigationController(rootViewController: baseViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    window.rootViewController = navigationController
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            }
        }
    }
}

protocol NextStepHandler: AnyObject {
    func handleNextStep(completion: @escaping () -> Void)
}
