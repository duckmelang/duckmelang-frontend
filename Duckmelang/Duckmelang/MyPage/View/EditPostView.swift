//
//  PostModifyView.swift
//  Duckmelang
//
//  Created by nau on 7/16/25.
//

import UIKit
import PhotosUI
import SnapKit
import Then

protocol EditPostViewDelegate: AnyObject {
    func didTapIdolSelectButton()
    func didTapEventTypeSelectButton()
    func didTapEventDateSelectButton()
    func didTapSelectedImageButton()
}

class EditPostView: UIView, UITextViewDelegate {
    
    weak var delegate: EditPostViewDelegate?
    
    // MARK: - UI Components
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
    }

    let contentView = UIView()
    
    lazy var navibar = CustomNavigationBar(title: "게시글 수정하기", leftImageName: "back").then {
        $0.backgroundColor = .white
    }

    let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        $0.minimumLineSpacing = 0
    }).then {
        $0.backgroundColor = .grey200
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.register(WriteImageCell.self, forCellWithReuseIdentifier: WriteImageCell.identifier)
    }

    let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .black
        $0.hidesForSinglePage = true
    }

    let imageCountLabel = UILabel().then {
        $0.text = "0/10"
        $0.textColor = .gray
        $0.font = .ptdRegularFont(ofSize: 12)
    }

    let uploadImageView = UIButton().then {
        $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        $0.tintColor = .lightGray
    }

    let titleTextField = UITextField().then {
        $0.placeholder = "게시글 제목"
        $0.borderStyle = .none
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.font = .ptdRegularFont(ofSize: 16)
        $0.textColor = .black
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        $0.autocapitalizationType = .none
        $0.returnKeyType = .done
    }

    let contentTextView = UITextView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.text = ""
    }

    private let companionInfoLabel = UILabel().then {
        $0.text = "동행 정보"
        $0.font = .ptdSemiBoldFont(ofSize: 17)
        $0.textColor = .black
    }

    let idolSelectButton = smallStorkeCustomBtn(title: "선택").then {
        $0.borderColor = .grey400
        $0.titleColor = .grey400
    }

    let eventTypeSelectButton = smallStorkeCustomBtn(title: "선택").then {
        $0.borderColor = .grey400
        $0.titleColor = .grey400
    }

    let eventDateSelectButton = smallStorkeCustomBtn(title: "선택").then {
        $0.borderColor = .grey400
        $0.titleColor = .grey400
    }

    private let selectedCelebLabel = UILabel().then {
        $0.text = "아이돌"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .grey600
    }

    private let eventTypeLabel = UILabel().then {
        $0.text = "행사 종류"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .systemGray
    }

    private let eventDateLabel = UILabel().then {
        $0.text = "행사 날짜"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .systemGray
    }

    let uploadButton = longCustomBtn(title: "수정하기", isEnabled: true)

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    
    private func setupView() {
        [scrollView, navibar].forEach { addSubview($0)}
        scrollView.addSubview(contentView)

        [
            imageCollectionView, pageControl, uploadImageView, imageCountLabel,
            titleTextField, contentTextView,
            companionInfoLabel, companionStackView,
            uploadButton
        ].forEach {
            contentView.addSubview($0)
        }

        setupConstraints()
    }

    private lazy var companionStackView = UIStackView(arrangedSubviews: [
        UIStackView(arrangedSubviews: [selectedCelebLabel, idolSelectButton]),
        UIStackView(arrangedSubviews: [eventTypeLabel, eventTypeSelectButton]),
        UIStackView(arrangedSubviews: [eventDateLabel, eventDateSelectButton])
    ]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }

    // MARK: - Constraints

    private func setupConstraints() {
        navibar.snp.makeConstraints {
            $0.top.equalTo(safeAreaInsets)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.frameLayoutGuide.snp.top)
            $0.edges.centerX.equalToSuperview()
            $0.bottom.equalTo(uploadButton.snp.bottom).offset(10)
        }

        imageCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width)
        }

        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(imageCollectionView.snp.bottom).offset(-8)
            $0.centerX.equalToSuperview()
        }

        uploadImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(imageCollectionView)
            $0.width.height.equalTo(80)
        }

        imageCountLabel.snp.makeConstraints {
            $0.top.equalTo(uploadImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        titleTextField.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(16)
        }

        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(150)
        }

        companionInfoLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(16)
        }

        companionStackView.snp.makeConstraints {
            $0.top.equalTo(companionInfoLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(16)
        }

        uploadButton.snp.makeConstraints {
            $0.top.equalTo(companionStackView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}
