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
    let celebs = Celeb.sampleCelebs

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

    // 알림 아이콘
    let bellIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "bell"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // 검색 아이콘
    let findIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "find"), for: .normal)
        button.tintColor = .black
        return button
    }()

    // 글쓰기 버튼
    let writeButton = smallFilledCustomBtn(title: "글쓰기")

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(chevronIcon)
        addSubview(celebNameLabel)
        addSubview(bellIcon)
        addSubview(findIcon)
        addSubview(writeButton)

        chevronIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(celebNameLabel)
            $0.width.height.equalTo(18)
        }
        
        celebNameLabel.snp.makeConstraints {
            $0.leading.equalTo(chevronIcon.snp.trailing).offset(8)
            $0.top.equalToSuperview().offset(65)
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
            $0.height.equalTo(44)
        }
    }
    //Chevron 아이콘 업데이트 함수
    func updateChevronIcon(isExpanded: Bool) {
        chevronIcon.image = UIImage(
            systemName: isExpanded ? "chevron.up" : "chevron.down"
        )
    }
}
