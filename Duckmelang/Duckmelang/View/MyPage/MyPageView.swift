//
//  MyPageView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Then
import SnapKit

class MyPageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var myPageTopView = MyPageTopView()
    
    public lazy var tableView = UITableView().then() {
        $0.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.identifier)
        $0.separatorStyle = .singleLine
    }
    
    private func addStack() {
        
    }
    
    private func setupView() {
        [myPageTopView].forEach{addSubview($0)}
        
        myPageTopView.snp.makeConstraints{
            $0.height.equalTo(200)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
