//
//  WriteViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

class WriteViewController: UIViewController, WriteViewDelegate, CelebSelectionDelegate {

    private var selectedCeleb: Celeb? // 현재 선택된 아이돌 정보

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        self.title = "글쓰기"
        
        writeView.delegate = self
        configureNavigationBar()
    }
    
    private lazy var writeView: WriteView = {
        let view = WriteView()
        view.delegate = self
        return view
    }()
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .grey200
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    // MARK: - WriteViewDelegate (아이돌 선택 버튼 클릭)
    func didTapIdolSelectButton() {
        let celebSelectionVC = CelebSelectionViewController(
            celebs: Celeb.sampleCelebs, // ✅ 샘플 아이돌 목록 사용
            selectedCeleb: selectedCeleb
        )
        celebSelectionVC.delegate = self
        celebSelectionVC.modalPresentationStyle = .pageSheet
        
        if let sheet = celebSelectionVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(celebSelectionVC, animated: true)
    }
    
    // MARK: - CelebSelectionDelegate (아이돌 선택 완료)
    func didSelectCeleb(_ celeb: Celeb) {
        selectedCeleb = celeb // 선택된 아이돌 정보 업데이트
        writeView.updateSelectedCeleb(celeb) // WriteView에 반영
    }
}
