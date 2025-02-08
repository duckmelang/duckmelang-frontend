//
//  PostDetailViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

//버튼 상태
enum PostProgressState {
    case inProgress
    case progressTap(progressing: Bool) // 진행 중이면 true, 완료 상태면 false
    case completed
}


class PostDetailViewController: UIViewController {

    var data = PostDetailAccompanyModel.dummy()
    
    private var currentState: PostProgressState = .inProgress
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = postDetailView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        
        updateButtonVisibility(state: .inProgress) // 초기 상태 설정
    }
    
    private lazy var postDetailView = PostDetailView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.postDetailTopView.progressBtn.addTarget(self, action: #selector(progressBtnDidTap), for: .touchUpInside)
        $0.postDetailTopView.progressTapBtn.addTarget(self, action: #selector(topTitleDidTap), for: .touchUpInside)//버튼의 title 클릭시 topTitleDidTap()작동, subtitle 클릭시 bottomTitleDidTap()작동
        $0.postDetailTopView.endBtn.addTarget(self, action: #selector(endBtnDidTap), for: .touchUpInside)
        
        // 진행 Tap 버튼에 터치 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnProgressTapBtn(_:)))
        $0.postDetailTopView.progressTapBtn.addGestureRecognizer(tapGesture)
    }

    private var buttons: [UIButton] {
        return [postDetailView.postDetailTopView.progressBtn,
                postDetailView.postDetailTopView.progressTapBtn,
                postDetailView.postDetailTopView.endBtn]
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    // 버튼 상태 업데이트 함수
    private func updateButtonVisibility(state: PostProgressState) {
        buttons.forEach { $0.isHidden = true }
        
        currentState = state
        
        switch state {
        case .inProgress:
            postDetailView.postDetailTopView.progressBtn.isHidden = false
        case .progressTap(let progressing):
            postDetailView.postDetailTopView.progressTapBtn.isHidden = false
            updateProgressTapButtonStyle(progressing: progressing)
        case .completed:
            postDetailView.postDetailTopView.endBtn.isHidden = false
        }
    }
    
    // 진행 Tap 버튼을 눌렀을 때 터치 위치 판별 (윗쪽/아랫쪽)
    @objc private func handleTapOnProgressTapBtn(_ sender: UITapGestureRecognizer) {
        let button = postDetailView.postDetailTopView.progressTapBtn
        let touchPoint = sender.location(in: button) // 터치한 위치 가져오기
        
        // 진행 중일 때 클릭 시 완료 버튼이 아래, 완료일 때 클릭 시 진행 중 버튼이 아래
        switch currentState {
        case .progressTap(let progressing):
            if touchPoint.y <= (button.bounds.height / 2) {
                updateButtonVisibility(state: progressing ? .inProgress : .completed)
            } else {
                updateButtonVisibility(state: progressing ? .completed : .inProgress)
            }
        default:
            break
        }
    }
  
    // 진행 Tap 버튼 스타일 업데이트 (진행 중 vs 완료 상태에 따라 변경)
    private func updateProgressTapButtonStyle(progressing: Bool) {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        if progressing {
            // 진행 중 상태일 때 → 완료가 아래쪽
            config.attributedTitle = AttributedString("진행 중", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey800!]))
            config.attributedSubtitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey500!]))
        } else {
            // 완료 상태일 때 → 진행 중이 아래쪽
            config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey800!]))
            config.attributedSubtitle = AttributedString("진행 중", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey500!]))
        }
        
        config.titleAlignment = .center
        config.titlePadding = 12
        postDetailView.postDetailTopView.progressTapBtn.configuration = config
    }
    
    @objc private func progressBtnDidTap() {
        updateButtonVisibility(state: .progressTap(progressing: true))
    }
    
    
    @objc
    private func topTitleDidTap() {
        updateButtonVisibility(state: .inProgress)
    }
    
    @objc
    private func endBtnDidTap() {
        updateButtonVisibility(state: .progressTap(progressing: false))
    }

    private func setupDelegate() {
        postDetailView.postDetailBottomView.tableView.delegate = self
        postDetailView.postDetailBottomView.tableView.dataSource = self
    }
}

extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailAccompanyCell.identifier, for: indexPath) as? PostDetailAccompanyCell else {
            return UITableViewCell()
        }
        
        cell.configure(model: data[indexPath.row])
        
        return cell
    }
}
