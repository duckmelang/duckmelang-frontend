//
//  PushNotificationViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class PushNotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = pushNotificationView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
    }

    private lazy var pushNotificationView = PushNotificationView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let section = sender.tag / 100
        let row = sender.tag % 100
        notifications[section][row].isOn = sender.isOn
        print("'\(notifications[section][row].title)' 설정이 \(sender.isOn ? "켜짐" : "꺼짐")")
    }
    
    private func setupDelegate() {
        pushNotificationView.tableView.delegate = self
        pushNotificationView.tableView.dataSource = self
        pushNotificationView.tableView.register(PushNotificationCell.self, forCellReuseIdentifier: PushNotificationCell.identifier)
    }
    
}

extension PushNotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = pushNotificationView.tableView.dequeueReusableCell(withIdentifier: PushNotificationCell.identifier, for: indexPath) as? PushNotificationCell else {
            return UITableViewCell()
        }
        
        let setting = notifications[indexPath.section][indexPath.row]
        cell.configure(with: setting, section: indexPath.section, row: indexPath.row, target: self, action: #selector(switchChanged(_:)))
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "서비스 알림" : "광고성 정보 알림"
    }
    
    //커스텀 헤더 뷰 생성
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView().then {
            $0.backgroundColor = .clear
        }

        let titleLabel = Label(text: section == 0 ? "서비스 알림" : "광고성 정보 알림", font: .ptdSemiBoldFont(ofSize: 17), color: .grey400)
        
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    //셀 높이 조정 (셀 간격 추가)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56 // 원하는 높이 값 설정
    }
   
    //섹션 헤더 높이 조정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53 // 원하는 높이 값
    }
}
