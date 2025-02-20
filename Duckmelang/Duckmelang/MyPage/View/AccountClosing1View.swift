//
//  AccountClosingView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class AccountClosing1View: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    private lazy var title = Label(text: "계정 탈퇴", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var text1 = Label(text: "회원 탈퇴(이용약관 동의 철회)시", font: .ptdSemiBoldFont(ofSize: 16), color: .grey800)
    
    private lazy var text2 = Label(text: "아래 내용을 확인해주세요", font: .ptdSemiBoldFont(ofSize: 16), color: .grey800)
    
    private lazy var view = UIScrollView().then {
        $0.layer.cornerRadius = 7
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        $0.verticalScrollIndicatorInsets = .zero
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    private lazy var contentView = UIView()
    
    private lazy var text3 = Label(text: """
    회원 탈퇴 안내사항

    회원 탈퇴를 진행하시기 전에 아래 내용을 반드시 확인해 주세요.

    1. 탈퇴 후 계정 복구 불가
       - 회원 탈퇴가 완료되면 계정을 다시 복구할 수 없습니다.
       - 같은 이메일로 재가입하더라도 기존 데이터는 복구되지 않습니다.

    2. 게시글 및 댓글 유지
       - 탈퇴 후에도 작성하신 게시글과 댓글은 삭제되지 않으며, 익명 처리됩니다.
       - 삭제를 원하실 경우, 탈퇴 전에 직접 삭제해 주세요.

    3. 보유 중인 데이터 소멸
       - 마이페이지에 저장된 프로필 정보, 관심 목록, 설정 값 등이 모두 삭제됩니다.
       - 데이터 복구는 불가능합니다.

    4. 로그인 및 서비스 이용 제한
       - 탈퇴 후 해당 계정으로 로그인이 불가능하며, 모든 서비스 이용이 제한됩니다.
       - 재가입 시 새로운 계정으로 가입해야 합니다.

    5. 결제 및 환불 관련 안내
       - 탈퇴 후에는 기존 결제 내역 확인이 불가능하며, 진행 중인 환불이 있다면 처리 완료 후 탈퇴를 권장합니다.
       - 환불이 필요한 경우 고객센터로 문의해 주세요.

    탈퇴를 원하시면 **회원 탈퇴** 버튼을 눌러 진행해 주세요.
    탈퇴 후에는 복구가 어려우니 신중하게 결정해 주세요.
    """, font: .ptdRegularFont(ofSize: 14), color: .grey500).then {
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        
        // ✅ 볼드 스타일 적용
        let boldFont = UIFont.boldSystemFont(ofSize: 14)
    
        let boldTexts = ["회원 탈퇴 안내사항", "1. 탈퇴 후 계정 복구 불가", "2. 게시글 및 댓글 유지",
                             "3. 보유 중인 데이터 소멸", "4. 로그인 및 서비스 이용 제한", "5. 결제 및 환불 관련 안내"]

        let attributedString = NSMutableAttributedString(string: $0.text!)
        for boldText in boldTexts {
            let range = ($0.text! as NSString).range(of: boldText)
            attributedString.addAttribute(.font, value: boldFont, range: range)
        }
        
        $0.attributedText = attributedString
    }
    
    private lazy var text4 = Label(text: "회원 탈퇴(이용약관 동의 철회)를 하시겠습니까?", font: .ptdSemiBoldFont(ofSize: 16), color: .grey800)
    
    lazy var outBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("회원 탈퇴", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 17), .foregroundColor: UIColor.grey0!]))
        $0.configuration = config
        $0.backgroundColor = .dmrBlue
        $0.layer.cornerRadius = 23
        $0.clipsToBounds = true
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private lazy var textStack = Stack(axis: .vertical, spacing: 5, alignment: .leading)
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
        [text1, text2].forEach{textStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, textStack, view, text4, outBtn].forEach{addSubview($0)}
        view.addSubview(contentView)
        contentView.addSubview(text3)
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        textStack.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.snp.makeConstraints{
            $0.top.equalTo(textStack.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(topStack.snp.width).inset(11)
            $0.height.equalTo(400)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(550)
        }
        
        text3.snp.makeConstraints{
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalTo(contentView).inset(12)
        }
        
        text4.snp.makeConstraints{
            $0.top.equalTo(view.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(16)
        }
        
        outBtn.snp.makeConstraints{
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
    }
}
