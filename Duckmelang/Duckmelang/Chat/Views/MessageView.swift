//
//  MessageView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/27/25.
//

import UIKit

class MessageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var detailChatroomResponse: DetailChatroomResponse? {
        didSet {
            if let detailData = detailChatroomResponse {
                print("detailData 변경됨: \(detailData)")
                updateUI(with: detailData)
            }
        }
    }
    
    var myPostDetail: MyPostDetailResponse? {
        didSet {
            if let myPostDetail = myPostDetail {
                updateUI(with: myPostDetail)
            }
        }
    }
    
    func updateUI(with data: DetailChatroomResponse) {
        if let postImageUrl = URL(string: data.postImage) {
            self.topMessageView.postImage.kf.setImage(with: postImageUrl, placeholder: UIImage())
        }
        self.topMessageView.postTitle.text = data.postTitle
        
        switch data.applicationStatus {
        case "PENDING":
            if !data.postOwner {
                // 진행 중인데 내가 쓴 글이 아님 -> 동행요청 버튼 활성화
                topMessageView.confirmBtn.isHidden = false
                topMessageView.reviewBtn.isHidden = true
                
                topMessageView.postTitle.snp.makeConstraints {
                    $0.trailing.equalTo(topMessageView.confirmBtn.snp.leading).offset(-8)
                }
            } else {
                // 진행 중인데 내가 쓴 글임 -> 아무버튼도 띄우지 않음
                topMessageView.confirmBtn.isHidden = true
                topMessageView.reviewBtn.isHidden = true
                
                topMessageView.postTitle.snp.makeConstraints {
                    $0.trailing.equalToSuperview().offset(20)
                }
            }
            topMessageView.inProgress.text = "진행 중"
            topMessageView.isHidden = false
            bottomMessageView.setupIncompleteView()
            
            messageCollectionView.snp.makeConstraints {
                $0.top.equalTo(topMessageView.snp.bottom).offset(5)
            }
        case "SUCCEED":
            if (data.reviewId == -1) {
                // 성공 후 리뷰x -> 리뷰버튼을 띄움
                topMessageView.confirmBtn.isHidden = true
                topMessageView.reviewBtn.isHidden = false
                
                messageCollectionView.snp.makeConstraints {
                    $0.top.equalTo(topMessageView.snp.bottom).offset(5)
                }
                
                topMessageView.postTitle.snp.makeConstraints {
                    $0.trailing.equalTo(topMessageView.confirmBtn.snp.leading).offset(-8)
                }
            } else {
                // 종료 후 리뷰o -> 탑뷰를 띄우지 않음
                topMessageView.isHidden = true
                
                messageCollectionView.snp.makeConstraints {
                    $0.top.equalTo(safeAreaLayoutGuide).offset(5)
                }
            }
            topMessageView.inProgress.text = "종료"
            bottomMessageView.setupCompleteView()
        default:
            // 실패한 경우 -> 탑뷰를 띄우지 않음
            topMessageView.isHidden = true
            bottomMessageView.setupCompleteView()
            
            messageCollectionView.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide).offset(5)
            }
        }
    }
    
    func updateUI(with data: MyPostDetailResponse) {
        guard let imageURL = data.postImageUrl.first else { return }
        if let postImageUrl = URL(string: imageURL) {
            self.topMessageView.postImage.kf.setImage(with: postImageUrl, placeholder: UIImage())
        }
        self.topMessageView.postTitle.text = data.title
        
        // 진행 중인데 내가 쓴 글이 아님 -> 동행요청 버튼 활성화
        topMessageView.confirmBtn.isHidden = false
        topMessageView.reviewBtn.isHidden = true
        
        topMessageView.postTitle.snp.makeConstraints {
            $0.trailing.equalTo(topMessageView.confirmBtn.snp.leading).offset(-8)
        }
        
        topMessageView.inProgress.text = "진행 중"
        topMessageView.isHidden = false
        bottomMessageView.setupIncompleteView()
        
        messageCollectionView.snp.makeConstraints {
            $0.top.equalTo(topMessageView.snp.bottom).offset(5)
        }
    }
    
    let topMessageView = TopMessageView()
    
    let messageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .init(width: 375, height: 58)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
    }).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.register(
            MyMessageCell.self,
            forCellWithReuseIdentifier: MyMessageCell.identifier
        )
        $0.register(
            OtherMessageCell.self,
            forCellWithReuseIdentifier: OtherMessageCell.identifier
        )
        $0.register(
            MessageHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MessageHeaderCell.identifier
        )
    }
    
    let bottomMessageView = BottomMessageView()
    
    private func setupView() {
        [
            topMessageView,
            messageCollectionView,
            bottomMessageView,
        ].forEach {
            addSubview($0)
        }
        
        topMessageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(-5)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        messageCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomMessageView.snp.top)
        }
        
        bottomMessageView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(-5)
            $0.trailing.equalToSuperview().offset(5)
            $0.height.equalTo(60)
        }
    }

}
