//
//  WriteViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

class WriteViewController: UIViewController, WriteViewDelegate, CelebSelectionDelegate, EventSelectionDelegate {

    private var selectedCeleb: Celeb? // 선택된 아이돌 정보
    private var selectedEvent: Event? // 선택된 이벤트 정보

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white // 원래 HomeViewController의 네비게이션 바 색상
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
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
    
    // MARK: - WriteViewDelegate (선택 버튼 클릭)
    func didTapIdolSelectButton() {
        let selectVC = CelebSelectionViewController(
            celebs: Celeb.sampleCelebs, // 샘플 아이돌 목록 사용
            selectedCeleb: selectedCeleb
        )
        selectVC.delegate = self
        selectVC.modalPresentationStyle = .pageSheet
        
        if let sheet = selectVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(selectVC, animated: true)
    }
    
    func didTapeventTypeSelectButton() {
        let selectVC = EventSelectionViewController(
            selectedEvent: selectedEvent // 선택된 이벤트 전달
        )
        selectVC.delegate = self
        selectVC.modalPresentationStyle = .pageSheet
        
        if let sheet = selectVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(selectVC, animated: true)
    }
    
    // MARK: - CelebSelectionDelegate (아이돌 선택 완료)
    func didSelectCeleb(_ celeb: Celeb) {
        selectedCeleb = celeb // 선택된 아이돌 정보 업데이트
        writeView.updateSelectedCeleb(celeb) // WriteView에 반영
    }
    
    // MARK: - EventSelectionDelegate (이벤트 선택 완료)
        func didSelectEvent(_ event: Event) {
            selectedEvent = event // 선택된 이벤트 정보 업데이트
            writeView.updateSelectedEvent(event) // WriteView에 반영하는 함수 추가
        }
}
