//
//  SearchFilterView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/21/25.
//

import UIKit

class SearchFilterView: UIView {

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
    
    private lazy var title = Label(text: "게시글 필터링 변경", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.dmrBlue!]))
        $0.configuration = config
        $0.setTitleColor(.dmrBlue, for: .normal)
        $0.backgroundColor = .clear
    }
    
    var postFilterTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(PostFilterCell.self, forCellReuseIdentifier: "PostFilterCell")
        $0.register(GenderSelectionCell.self, forCellReuseIdentifier: "GenderSelectionCell")
        $0.register(AgeSelectionCell.self, forCellReuseIdentifier: "AgeSelectionCell")
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.estimatedRowHeight = 50
        $0.sectionHeaderHeight = 44
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, postFilterTableView].forEach{addSubview($0)}
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        postFilterTableView.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(400)
        }
    }
}
