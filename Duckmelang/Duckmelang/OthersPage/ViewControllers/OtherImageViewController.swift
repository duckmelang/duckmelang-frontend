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

    private func getOtherProfileImageAPI() {
        provider.request(.getOtherProfileImage(memberId: self.oppositeId!, page: 0)) { result in
            switch result {
            case .success(let response):
                self.profileImageData.removeAll()
                let response = try? response.map(ApiResponse<OtherImageResponse>.self)
                guard let result = response?.result?.profileImageList else { return }
                self.profileImageData = result
                print("다른 사람 이미지: \(self.profileImageData)")
                
                DispatchQueue.main.async {
                    self.otherImageView.imageTableView.reloadData()
                }
            case .failure(let error):
                print(error)
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
}
