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
        
    
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var tableView = UITableView().then() {
        $0.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.identifier)
        $0.separatorStyle = .singleLine
    }
    
    private func addStack() {
        
    }
    
    private func setupView() {
       
    }
}
