//
//  WriteViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

class WriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        self.title = "글쓰기"
        
        // 네비게이션 바 스타일 설정
        configureNavigationBar()
    }
    
    private lazy var writeView: WriteView = {
        let view = WriteView()
        return view
    }()
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .grey200
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)
        ]
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.compactAppearance = appearance
        }
    }
}
