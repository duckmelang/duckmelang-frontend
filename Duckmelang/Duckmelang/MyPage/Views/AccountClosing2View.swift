//
//  AccountClosing2View.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class AccountClosing2View: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .mainColor
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var image = UIImageView(image: .logoWhite).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var text1 = Label(text: "언젠가 다시 만나요!", font: .aritaBoldFont(ofSize: 20), color: .grey800)
    
    private lazy var text2 = Label(text: "서비스를 이용해주셔서 감사합니다.", font: .ptdRegularFont(ofSize: 13), color: .grey800)
    
    lazy var outBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("로그인 페이지로", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 17), .foregroundColor: UIColor.grey0!]))
        $0.configuration = config
        $0.backgroundColor = .dmrBlue
        $0.layer.cornerRadius = 23
        $0.clipsToBounds = true
    }
    
    private lazy var textStack = Stack(axis: .vertical, spacing: 13, alignment: .center)
    
    private func addStack(){
        [text1, text2].forEach{textStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [image, textStack, outBtn].forEach{addSubview($0)}
        
        image.snp.makeConstraints{
            $0.top.equalToSuperview().inset(303)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(74)
        }
        
        textStack.snp.makeConstraints{
            $0.top.equalTo(image.snp.bottom).offset(64)
            $0.centerX.equalToSuperview()
        }
        
        outBtn.snp.makeConstraints{
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
    }
}
