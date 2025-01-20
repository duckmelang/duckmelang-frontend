//
//  ProfileViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class ProfileViewController: UIViewController{
    var selectedTag: Int = 0
       
    let data1 = PostModel.dummy1()
    
    //reviewTabelView의 더미인데 일단 이렇게 해둠..
    let data2 = PostModel.dummy2()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileView
        
        navigationController?.isNavigationBarHidden = true
        
        setupAction()
        setupDelegate()
    }

    private lazy var profileView = ProfileView()
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    private func setupDelegate() {
        profileView.profileBottomView.uploadPostView.dataSource = self
        profileView.profileBottomView.uploadPostView.delegate = self
        
        profileView.profileBottomView.reviewTableView.dataSource = self
        profileView.profileBottomView.reviewTableView.delegate = self
    }
    
    private func setupAction() {
        profileView.profileTopView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        // segmentedControl
        profileView.profileBottomView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            profileView.profileBottomView.uploadPostView.isHidden = false
            profileView.profileBottomView.reviewTableView.isHidden = true
        } else {
            profileView.profileBottomView.uploadPostView.isHidden = true
            profileView.profileBottomView.reviewTableView.isHidden = false
        }
        
        let width = profileView.profileBottomView.segmentedControl.frame.width / CGFloat(profileView.profileBottomView.segmentedControl.numberOfSegments)
        let xPosition = profileView.profileBottomView.segmentedControl.frame.origin.x + (width * CGFloat(profileView.profileBottomView.segmentedControl.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2) {
            self.profileView.profileBottomView.underLineView.frame.origin.x = xPosition
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == profileView.profileBottomView.uploadPostView) {
            return data1.count
        } else if (tableView == profileView.profileBottomView.reviewTableView) {
            return data2.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if (tableView == profileView.profileBottomView.uploadPostView) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                    return UITableViewCell()
                }
                cell.configure(model: data1[indexPath.row])
                return cell
                
            } else if (tableView == profileView.profileBottomView.reviewTableView) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                    return UITableViewCell()
                }
                cell.configure(model: data2[indexPath.row])
                return cell
            }
            
            return UITableViewCell()
        }
    }
