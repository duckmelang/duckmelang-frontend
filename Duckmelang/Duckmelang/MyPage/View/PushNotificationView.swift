//
//  PushNotificationView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class PushNotificationView: UIView {

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
    
    private lazy var title = Label(text: "푸시알림", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.rowHeight = 56
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, tableView].forEach{addSubview($0)}
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
        
    }

}
