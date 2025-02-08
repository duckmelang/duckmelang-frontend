//
//  OtherProfileModifyViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class OtherProfileViewController: UIViewController {

    var selectedTag: Int = 0
       
    let data1 = PostModel.dummy1()

    let data2 = ReviewModel.dummy()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = otherProfileView
        
        navigationController?.isNavigationBarHidden = true
        otherProfileView.otherProfileBottomView.cosmosView.isHidden = true
        otherProfileView.otherProfileBottomView.cosmosStack.isHidden = true
        
        setupAction()
        setupDelegate()
    }

    private lazy var otherProfileView = OtherProfileView()
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    /*
    @objc
    private func setBtnDidTap() {
        otherProfileView.otherProfileTopView.setBtnImage.isHidden = false
    }
    
    // setBtn 창 떠 있는 상태에서 다른 뷰를 누를때
    @objc
    private func viewDidTap() {
        if otherProfileView.otherProfileTopView.setBtnImage.isHidden == false {
            otherProfileView.otherProfileTopView.setBtnImage.isHidden = true
        }
    }*/

    private func setupDelegate() {
        otherProfileView.otherProfileBottomView.uploadPostView.dataSource = self
        otherProfileView.otherProfileBottomView.uploadPostView.delegate = self
        
        otherProfileView.otherProfileBottomView.reviewTableView.dataSource = self
        otherProfileView.otherProfileBottomView.reviewTableView.delegate = self
    }
    
    private func setupAction() {
        otherProfileView.otherProfileTopView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        // segmentedControl
        otherProfileView.otherProfileBottomView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
        /*otherProfileView. otherProfileTopView.setBtn.addTarget(self, action: #selector(setBtnDidTap), for: .touchUpInside)
        
        let setBtnDidTap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        setBtnDidTap.numberOfTapsRequired = 1 // 단일 탭, 횟수 설정
        profileView.addGestureRecognizer(setBtnDidTap)
        
        let feedManagementDidTap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        profileView.profileTopView.setBtnImage.addGestureRecognizer(feedManagementDidTap)*/
    }
    
    /*@objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        // 터치한 위치 가져오기
        let touchPoint = sender.location(in: tappedView)
        
        // 이미지를 절반으로 나누기
        let halfHeight = tappedView.bounds.height / 2
        
        if touchPoint.y <= halfHeight {
            // 윗부분 터치
            let profileModifyVC = UINavigationController(rootViewController: ProfileModifyViewController())
            profileModifyVC.modalPresentationStyle = .fullScreen
            present(profileModifyVC, animated: false)
            profileView.profileTopView.setBtnImage.isHidden = true
        } else {
            // 아랫부분 터치
            let feedVC = UINavigationController(rootViewController: FeedManagementViewController())
            feedVC.modalPresentationStyle = .fullScreen
            present(feedVC, animated: false)
            profileView.profileTopView.setBtnImage.isHidden = true
        }
    }*/
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            otherProfileView.otherProfileBottomView.uploadPostView.isHidden = false
            otherProfileView.otherProfileBottomView.reviewTableView.isHidden = true
            otherProfileView.otherProfileBottomView.cosmosView.isHidden = true
            otherProfileView.otherProfileBottomView.cosmosStack.isHidden = true
        } else {
            otherProfileView.otherProfileBottomView.uploadPostView.isHidden = true
            otherProfileView.otherProfileBottomView.reviewTableView.isHidden = false
            otherProfileView.otherProfileBottomView.cosmosView.isHidden = false
            otherProfileView.otherProfileBottomView.cosmosStack.isHidden = false
        }
        
        let width = otherProfileView.otherProfileBottomView.segmentedControl.frame.width / CGFloat(otherProfileView.otherProfileBottomView.segmentedControl.numberOfSegments)
        let xPosition = otherProfileView.otherProfileBottomView.segmentedControl.frame.origin.x + (width * CGFloat(otherProfileView.otherProfileBottomView.segmentedControl.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2) {
            self.otherProfileView.otherProfileBottomView.underLineView.frame.origin.x = xPosition
        }
    }
}

extension OtherProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == otherProfileView.otherProfileBottomView.uploadPostView) {
            return data1.count
        } else if (tableView == otherProfileView.otherProfileBottomView.reviewTableView) {
            return data2.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if (tableView == otherProfileView.otherProfileBottomView.uploadPostView) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                    return UITableViewCell()
                }
                cell.configure(model: data1[indexPath.row])
                return cell
                
            } else if (tableView == otherProfileView.otherProfileBottomView.reviewTableView) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {

                    return UITableViewCell()
                }
                cell.configure(model: data2[indexPath.row])
                return cell
            }
            
            return UITableViewCell()
        }
}
