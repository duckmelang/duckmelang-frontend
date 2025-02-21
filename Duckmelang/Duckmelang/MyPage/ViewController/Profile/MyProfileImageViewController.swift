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
    
    var isLoading = false   // 중복 로딩 방지
    var isLastPage = false  // 마지막 페이지인지 여부
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = myProfileImageView
        
        setupDelegate()
        setupNavigationBar()
        getMyProfileImageAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true) // ✅ 현재 뷰에서만 보이도록 설정
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true) // ✅ 원래 상태로 복구
    }
    
    private lazy var myProfileImageView = MyProfileImageView().then {
        _ in
    }

    private func setupDelegate() {
        myProfileImageView.imageTableView.delegate = self
        myProfileImageView.imageTableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getMyProfileImageAPI() {
        guard !isLoading && !isLastPage else { return } // 중복 호출 & 마지막 페이지 방지
        isLoading = true
        myProfileImageView.loadingIndicator.startLoading()
        
        provider.request(.getMyProfileImage(page: currentPage)) { result in
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    let response = try? response.map(ApiResponse<myProfileImageResponse>.self)
                    guard let result = response?.result?.profileImageList else { return }
                    guard let isLast = response?.result?.isLast else { return }
                    self.profileImageData.append(contentsOf: result)
                    print("이미지: \(self.profileImageData)")
                    
                    DispatchQueue.main.async {
                        self.isLastPage = isLast
                        self.isLoading = false
                        self.myProfileImageView.loadingIndicator.stopLoading()
                        self.myProfileImageView.imageTableView.reloadData()
                        
                        if isLast {
                            self.myProfileImageView.imageTableView.tableFooterView = nil
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.myProfileImageView.loadingIndicator.stopLoading()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight * 2 {
            if !isLoading && !isLastPage {
                currentPage += 1
                getMyProfileImageAPI()
            }
        }
    }
}

