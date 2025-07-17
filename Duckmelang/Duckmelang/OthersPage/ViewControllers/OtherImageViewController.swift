//
//  OtherProfileImageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 2/5/25.
//

import UIKit

class OtherImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let networkService = OtherPageService()
    
    private var profileImageData: [OtherImageData] = []
    
    var oppositeId: Int?
    var profileData: OtherProfileData?
    
    var isLoading = false   // 중복 로딩 방지
    var totalPage = 0       // 마지막 페이지 번호
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = otherImageView
        
        setupDelegate()
        setupNavigationBar()
        getOtherProfileImageAPI(startPage: 0)
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
    private func getOtherProfileImageAPI(startPage: Int) {
        Task {
            do {
                self.isLoading = true
                startLoading()
                guard let oppositeId = self.oppositeId else { return }
                
                let result = try await networkService.getOtherProfileImage(memberId: oppositeId, page: startPage)
                
                if (result.isFirst) {
                    self.profileImageData = result.profileImageList
                    self.totalPage = result.totalPage
                } else {
                    self.profileImageData.append(contentsOf: result.profileImageList)
                }
                self.currentPage = result.currentPage
                
                DispatchQueue.main.async {
                    self.otherImageView.imageTableView.reloadData()
                }
                
                stopLoading()
                isLoading = false
            }
            catch {
                stopLoading()
                isLoading = false
                print(error.localizedDescription)
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

        if offsetY > contentHeight - tableViewHeight {
            guard !isLoading, currentPage + 1 < totalPage else { return }
            getOtherProfileImageAPI(startPage: currentPage + 1)
        }
    }
}
