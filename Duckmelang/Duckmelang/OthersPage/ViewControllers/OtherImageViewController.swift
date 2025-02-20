//
//  OtherProfileImageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 2/5/25.
//

import UIKit
import Moya

class OtherImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let provider = MoyaProvider<OtherPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var profileImageData: [OtherImageData] = []
    
    var oppositeId: Int?
    var profileData: OtherProfileData?
    
    var isLoading = false   // 중복 로딩 방지
    var isLastPage = false  // 마지막 페이지인지 여부
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = otherImageView
        
        setupDelegate()
        setupNavigationBar()
        getOtherProfileImageAPI()
    }
    
    private lazy var otherImageView: OtherImageView = {
        let view = OtherImageView()
        return view
    }()

    private func setupDelegate() {
        otherImageView.imageTableView.delegate = self
        otherImageView.imageTableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - 프로필 이미지 목록 가져오기
    private func getOtherProfileImageAPI() {
        guard !isLoading && !isLastPage else { return } // 중복 호출 & 마지막 페이지 방지
        isLoading = true
        otherImageView.loadingIndicator.startLoading()
        
        provider.request(.getOtherProfileImage(memberId: self.oppositeId!, page: currentPage)) { result in
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    let response = try? response.map(ApiResponse<OtherImageResponse>.self)
                    guard let result = response?.result?.profileImageList else { return }
                    guard let isLast = response?.result?.isLast else { return }
                    self.profileImageData.append(contentsOf: result)
                    print("다른 사람 이미지: \(self.profileImageData)")
                    
                    DispatchQueue.main.async {
                        self.isLastPage = isLast
                        self.isLoading = false
                        self.otherImageView.loadingIndicator.stopLoading()
                        self.otherImageView.imageTableView.reloadData()
                        
                        if isLast {
                            self.otherImageView.imageTableView.tableFooterView = nil
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.otherImageView.loadingIndicator.stopLoading()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileImageData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageCell.identifier, for: indexPath) as? ProfileImageCell else {
            return UITableViewCell()
        }
        cell.configure(profileData: self.profileData!, model: self.profileImageData[indexPath.section])
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
                getOtherProfileImageAPI()
            }
        }
    }
}
