//
//  PushNotificationViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

/*import UIKit

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
}*/

import UIKit
import Moya

class PushNotificationViewController: UIViewController {
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]) // ✅ Moya API Provider

    private let notificationTitles = [
        "채팅 알림",
        "동행 확정 요청 수신 알림",
        "후기작성 알림",
        "북마크 알림"
    ]

    /// ✅ API에서 가져온 알림 설정 값 저장
    private var notificationSettings: NotificationsSettingResponse? {
        didSet {
            DispatchQueue.main.async {
                self.pushNotificationView.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = pushNotificationView
        navigationController?.isNavigationBarHidden = true
        setupDelegate()
        fetchNotificationSettings()  // ✅ API 요청 (알림 설정 가져오기)
    }

    private lazy var pushNotificationView = PushNotificationView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }

    @objc private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }

    /// ✅ 알림 설정 변경 처리 (CustomToggleButton이 눌릴 때)
    @objc private func toggleChanged(_ sender: CustomToggleButton) {
        guard let settings = notificationSettings else { return }

        var parameters: [String: Bool] = [:]

        // ✅ 변경된 값만 추가하여 PATCH 요청
        switch sender.tag {
        case 0: parameters["chatNotificationEnabled"] = sender.isOn
        case 1: parameters["requestNotificationEnabled"] = sender.isOn
        case 2: parameters["reviewNotificationEnabled"] = sender.isOn
        case 3: parameters["bookmarkNotificationEnabled"] = sender.isOn
        default: return
        }

        // ✅ PATCH 요청 실행
        provider.request(.patchNotificationsSetting(parameters)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<NotificationsSettingResponse>.self)
                    if decodedResponse.isSuccess {
                        print("✅ 알림 설정 변경 성공")

                        // ✅ PATCH 요청 후 GET 요청을 다시 실행하여 최신 데이터 반영
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.fetchNotificationSettings()
                        }

                    } else {
                        print("❌ 알림 설정 변경 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
            }
        }
    }


    private func setupDelegate() {
        pushNotificationView.tableView.delegate = self
        pushNotificationView.tableView.dataSource = self
        pushNotificationView.tableView.register(PushNotificationCell.self, forCellReuseIdentifier: PushNotificationCell.identifier)
    }
    
    private func fetchNotificationSettings() {
        provider.request(.getNotificationsSetting) { result in
            switch result {
            case .success(let response):
                if let responseString = String(data: response.data, encoding: .utf8) {
                    print("📌 [DEBUG] 서버 응답 JSON: \(responseString)") // ✅ 서버 응답 직접 확인
                }
                do {
                    let decodedResponse = try response.map(ApiResponse<NotificationsSettingResponse>.self)
                    if decodedResponse.isSuccess {
                        self.notificationSettings = decodedResponse.result
                    } else {
                        print("❌ 알림 설정 가져오기 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
            }
        }
    }

}

extension PushNotificationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = pushNotificationView.tableView.dequeueReusableCell(
            withIdentifier: PushNotificationCell.identifier, for: indexPath
        ) as? PushNotificationCell else {
            return UITableViewCell()
        }

        guard let settings = notificationSettings else { return cell }

        let isOn: Bool
        switch indexPath.row {
        case 0: isOn = settings.chatNotificationEnabled
        case 1: isOn = settings.requestNotificationEnabled
        case 2: isOn = settings.reviewNotificationEnabled
        case 3: isOn = settings.bookmarkNotificationEnabled
        default: isOn = false
        }

        cell.configure(
            title: notificationTitles[indexPath.row],
            isOn: isOn,
            tag: indexPath.row,
            target: self,
            action: #selector(toggleChanged(_:))
        )

        return cell
    }
}
