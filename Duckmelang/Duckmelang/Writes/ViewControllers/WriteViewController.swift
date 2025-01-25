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
        
        // 네비게이션 바 타이틀 폰트 설정
        if let navigationController = self.navigationController {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont
                    .aritaSemiBoldFont(ofSize: 18)
            ]
        }
        
    }
    
    private lazy var writeView: WriteView = {
        let view = WriteView()
        return view
    }()

}
    
    
