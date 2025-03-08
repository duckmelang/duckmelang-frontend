//
//  HomeView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/18/25.
//

import UIKit
import Then
import SnapKit

class HomeView: UIView {

    //FIXME: - 동적 데이터 바인딩으로 바꿔야됨
    let celebs = Celeb.dummy1()

    // 아이돌 이름 Label
    let celebNameLabel = UILabel().then {
        $0.text = "아이돌 이름"
        $0.font = .aritaSemiBoldFont(ofSize: 18)
        $0.isUserInteractionEnabled = true // 터치 가능하도록 설정
    }
    // Chevron 아이콘
    private let chevronIcon = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down") // 초기 상태 (닫힘)
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var celebStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
    }

    // 알림 아이콘
    let bellIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "bell"), for: .normal)
        button.tintColor = .grey600
        return button
    }()
    
    // 검색 아이콘
    let findIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "find"), for: .normal)
        button.tintColor = .grey600
        return button
    }()
    
    lazy var postsTableView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 106
        $0.isHidden = true
    }

    // 글쓰기 버튼
    let writeButton = UIButton().then {
        $0.backgroundColor = .dmrBlue
        $0.setTitle("글쓰기", for: .normal)
        $0.setTitleColor(.grey0, for: .normal)
        $0.titleLabel?.font = .ptdSemiBoldFont(ofSize: 14)
        $0.layer.cornerRadius = 23
        $0.setImage(UIImage(named: "Pencil"), for: .normal)
        $0.tintColor = .grey0
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        celebStack.addArrangedSubview(chevronIcon)
        celebStack.addArrangedSubview(celebNameLabel)
        
        [
            celebStack,
            bellIcon,
            findIcon,
            postsTableView,
            writeButton
        ].forEach {
            addSubview($0)
        }

        celebStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }

        chevronIcon.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
        
        // 아이콘 컨테이너 뷰 생성
        let iconStackView = UIStackView(arrangedSubviews: [bellIcon, findIcon])
        iconStackView.axis = .horizontal
        iconStackView.spacing = 16 // 아이콘 간 간격 조절

        addSubview(iconStackView)

        iconStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(celebNameLabel)
        }

        writeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.width.equalTo(100)
            $0.height.equalTo(44)
        }
        
        postsTableView.snp.makeConstraints {
            $0.top.equalTo(celebNameLabel.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    //Chevron 아이콘 업데이트 함수
    func updateChevronIcon(isExpanded: Bool) {
        chevronIcon.image = UIImage(
            systemName: isExpanded ? "chevron.up" : "chevron.down"
        )
    }
}
