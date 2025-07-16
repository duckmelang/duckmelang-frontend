//
//  WarningViewController.swift
//  Duckmelang
//
//  Created by nau on 6/30/25.
//

import Foundation
import UIKit

class WarningViewController: UIViewController {
    let networkService = ReportService()
    
    var postId: Int?
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = warningView
        setupBtnActions()
    }
    
    private var selectedReason: ReportReason? {
        didSet {
            updateUISelectedReason()
        }
    }
    
    private lazy var warningView = WarningView().then {
        $0.warningBtn.addTarget(self, action: #selector(warningBtnDidTap), for: .touchUpInside)
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    private func setupBtnActions() {
        warningView.advert.addTarget(self, action: #selector(reasonBtnTapped(_:)), for: .touchUpInside)
        warningView.inappr.addTarget(self, action: #selector(reasonBtnTapped(_:)), for: .touchUpInside)
        warningView.sexual.addTarget(self, action: #selector(reasonBtnTapped(_:)), for: .touchUpInside)
        warningView.fraud.addTarget(self, action: #selector(reasonBtnTapped(_:)), for: .touchUpInside)
        warningView.insult.addTarget(self, action: #selector(reasonBtnTapped(_:)), for: .touchUpInside)
        warningView.etc.addTarget(self, action: #selector(reasonBtnTapped(_:)), for: .touchUpInside)
    }
    
    @objc
    private func warningBtnDidTap() {
        guard let reason = selectedReason, let postId = postId else { return }
        
        report(id: postId, reason: reason.rawValue)
        
        let popupVC = WarningPopupViewController()
        popupVC.nickname = self.nickname
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            popupVC.dismiss(animated: false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func report(id: Int, reason: String, dtype: String = "POST") {
        _Concurrency.Task {
            do {
                try await networkService.postReport(request: ReportRequest(id : id, reason: reason, dtype: dtype))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func reasonBtnTapped(_ sender: UIButton) {
        [warningView.advert, warningView.inappr, warningView.sexual, warningView.fraud, warningView.insult, warningView.etc].forEach{
            $0.backgroundColor = .clear
        }
        
        sender.backgroundColor = .bgcPrimary
        
        switch sender {
        case warningView.advert: selectedReason = .advert
        case warningView.inappr: selectedReason = .inappr
        case warningView.sexual: selectedReason = .sexual
        case warningView.fraud:  selectedReason = .fraud
        case warningView.insult: selectedReason = .insult
        case warningView.etc:    selectedReason = .etc
        default: break
        }
    }
    
    private func updateUISelectedReason() {
        if selectedReason != nil {
            warningView.warningBtn.backgroundColor = UIColor.dmrBlue
        } else {
            warningView.warningBtn.backgroundColor = UIColor.grey400
        }
    }
}

enum ReportReason: String {
    case advert = "ADVERT"
    case inappr = "INAPPR"
    case sexual = "SEXUAL"
    case fraud = "FRAUD"
    case insult = "INSULT"
    case etc = "ETC"
}
