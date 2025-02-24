//
//  MyProfileImageViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/21/25.
//

import UIKit
import Moya

class MyProfileImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let provider = MoyaProvider<MyPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

    private var profileImageData: [ProfileImageData] = []
    
    var oppositeId: Int?
    var profileData: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = myProfileImageView
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        getProfileDataAPI()
    }
    
    private lazy var myProfileImageView = MyProfileImageView().then {
        $0.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }

    private func setupDelegate() {
        myProfileImageView.imageTableView.delegate = self
        myProfileImageView.imageTableView.dataSource = self
    }

    @objc private func goBack() {
        self.dismiss(animated: true)
    }

    private func getProfileDataAPI() {
        provider.request(.getProfile) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<ProfileData>.self)
                    if decodedResponse.isSuccess, let profileData = decodedResponse.result {
                        self.profileData = profileData
                        print("✅ 프로필 데이터 가져오기 성공: \(profileData)")

                        // ✅ 프로필 데이터를 성공적으로 가져오면 이미지 API 호출
                        self.getMyProfileImageAPI()
                    } else {
                        print("❌ 프로필 데이터를 가져오는 데 실패했습니다: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ 프로필 데이터 JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 프로필 데이터 요청 실패: \(error.localizedDescription)")
            }
        }
    }

    
    private func getMyProfileImageAPI() {
        provider.request(.getMyProfileImage(page: 0)) { result in
            switch result {
            case .success(let response):
                self.profileImageData.removeAll()
                do {
                    let decodedResponse = try response.map(ApiResponse<myProfileImageResponse>.self)
                    guard let imageList = decodedResponse.result?.sortedProfileImageList, !imageList.isEmpty else {
                        print("❌ 프로필 이미지 없음")
                        return
                    }
                    
                    self.profileImageData = imageList
                    print("✅ 최신순 정렬된 이미지 리스트: \(self.profileImageData)")

                    DispatchQueue.main.async {
                        self.myProfileImageView.imageTableView.reloadData()
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 프로필 이미지 리스트 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileImageData.isEmpty ? 0 : profileImageData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageCell.identifier, for: indexPath) as? ProfileImageCell else {
            return UITableViewCell()
        }
        
        guard let profileData = self.profileData else {
            print("❌ profileData가 nil입니다. 기본 데이터를 설정합니다.")
            return UITableViewCell() // 빈 셀 반환하여 크래시 방지
        }

        // ✅ 데이터 전달 시 nil 방지
        cell.configure(profileData: profileData, model: self.profileImageData[indexPath.section])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = .grey200
        return spacerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
}

