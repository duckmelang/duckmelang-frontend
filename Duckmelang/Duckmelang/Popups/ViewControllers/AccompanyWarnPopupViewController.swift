//
//  AccompanyWarnPopupViewController.swift
//  Duckmelang
//
//  Created by nau on 7/17/25.
//

import UIKit

class AccompanyWarnPopupViewController: UIViewController {

    var targetId: Int?
    var nickname: String?
    
    let networkService = ReportService()
    
    private let firstReason = "사유를 선택해주세요."
    private let reasons = ["상업적 광고 및 판매", "음란물/불건전한 만남 및 대화", "욕설/비방", "유출/사칭/사기", "욕설/비하", "기타"]

    private var isDropDown = false
    
    var onReportSelected: ((String) -> Void)?
    
    let accompanyWarnPopupView = AccompanyWarnPopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = accompanyWarnPopupView
        
        setupDelegate()
        setupAction()
    }
    
    private var selectedReason: String? {
        didSet {
            accompanyWarnPopupView.reasonLabel.text = selectedReason ?? firstReason
            accompanyWarnPopupView.tableView.isHidden = true
            isDropDown = false
        }
    }
    
    private func setupDelegate() {
        accompanyWarnPopupView.tableView.delegate = self
        accompanyWarnPopupView.tableView.dataSource = self
    }
    
    private func setupAction() {
        accompanyWarnPopupView.toggleBtn.addTarget(self, action: #selector(toggleBtnDidTapped), for: .touchUpInside)
        accompanyWarnPopupView.panel.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
    }
    
    @objc private func reportTapped() {
        guard let selectedReason = selectedReason else { return }
        dismiss(animated: true) {
            self.onReportSelected?(selectedReason)
        }
    }
    
    @objc private func closeModal() {
        dismiss(animated: false)
    }
    
    @objc private func toggleBtnDidTapped() {
        let shouldExpand = accompanyWarnPopupView.tableView.isHidden
        toggleDropdown(isExpanded: shouldExpand)
    }
    
    private func toggleDropdown(isExpanded: Bool) {
        let height = isExpanded ? reasons.count * 44 : 44

        self.accompanyWarnPopupView.tableView.isHidden = false
        self.accompanyWarnPopupView.tableViewHeightConstraint?.update(offset: height)

        UIView.animate(withDuration: 0.3, animations: {
            self.accompanyWarnPopupView.layoutIfNeeded()
        }, completion: { _ in
            self.accompanyWarnPopupView.tableView.isHidden = !isExpanded
        })
    }
    
    private func report(reason: String) {
        guard let targetId = targetId else { return }
        
        _Concurrency.Task {
            do {
                let code = reportReasonCode(for: reason)
                try await networkService.postReport(request: ReportRequest(id: targetId, reason: code, dtype: "REVIEW"))
                
                DispatchQueue.main.async {
                    self.showReportCompletedPopup()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func showReportCompletedPopup() {
        let popupVC = WarningPopupViewController()
        popupVC.nickname = self.nickname
        popupVC.reportTargetType = .review
        popupVC.modalPresentationStyle = .overFullScreen
    
        self.accompanyWarnPopupView.isHidden = true
        present(popupVC, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            popupVC.dismiss(animated: false)
            self.dismiss(animated: false)
        }
    }
}

extension AccompanyWarnPopupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReasonCell.identifier, for: indexPath) as? ReasonCell else {
            return UITableViewCell()
        }
        
        let reason = reasons[indexPath.row]
        cell.configure(with: reason, isSelected: false) {
            print("신고사유 선택됨: \(reason)")
            self.report(reason: reason)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReason = reasons[indexPath.row]
    }
}

private func reportReasonCode(for label: String) -> String {
    switch label {
    case "음란물/불건전한 만남 및 대화": return "INAPPR"
    case "욕설/비방": return "INSULT"
    case "유출/사칭/사기": return "FRAUD"
    case "욕설/비하": return "SEXUAL"
    case "기타": return "ETC"
    default: return "ETC"
    }
}
