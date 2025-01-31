//
//  WriteViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

class WriteViewController: UIViewController, WriteViewDelegate, CelebSelectionDelegate, EventSelectionDelegate {

    private var selectedCeleb: Celeb?
    private var selectedEvent: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
    }
    
    private lazy var writeView: WriteView = {
        let view = WriteView()
        
        view.delegate = self
        view.idolSelectButton.addTarget(self, action: #selector(didTapIdolSelectButton), for: .touchUpInside)
        view.eventTypeSelectButton.addTarget(self, action: #selector(didTapEventTypeSelectButton), for: .touchUpInside)
        view.eventDateSelectButton.addTarget(self, action: #selector(didTapEventDateSelectButton), for: .touchUpInside)
        
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "글쓰기"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)
        ]
        
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapIdolSelectButton() {
        let selectVC = CelebSelectionViewController(
            celebs: Celeb.sampleCelebs,
            selectedCeleb: selectedCeleb
        )
        selectVC.delegate = self
        presentBottomSheet(selectVC)
    }
    
    @objc func didTapEventTypeSelectButton() {
        let selectVC = EventSelectionViewController(
            selectedEvent: selectedEvent
        )
        selectVC.delegate = self
        presentBottomSheet(selectVC)
    }
    
    @objc func didTapEventDateSelectButton() {
        showDatePicker()
    }
    
    private func presentBottomSheet(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(viewController, animated: true)
    }
    
    private func showDatePicker() {
        let alertController = UIAlertController(title: "날짜 선택", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.frame = CGRect(x: 10, y: 50, width: 260, height: 150)

        alertController.view.addSubview(datePicker)

        let selectAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.updateSelectedDate(datePicker.date)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    /// ✅ 날짜 선택 후 버튼 업데이트 메서드 (VC에 구현)
    private func updateSelectedDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let selectedDate = dateFormatter.string(from: date)

        writeView.eventDateSelectButton.setTitle(selectedDate, for: .normal)
        writeView.eventDateSelectButton.setTitleColor(.black, for: .normal)
        writeView.eventDateSelectButton.layer.borderColor = UIColor.black!.cgColor
    }

    func didSelectCeleb(_ celeb: Celeb) {
        selectedCeleb = celeb
        writeView.idolSelectButton.setTitle(celeb.name, for: .normal)
        writeView.idolSelectButton.setTitleColor(.black, for: .normal)
        writeView.idolSelectButton.layer.borderColor = UIColor.black!.cgColor
    }
    
    func didSelectEvent(_ event: Event) {
        selectedEvent = event
        writeView.eventTypeSelectButton.setTitle(event.tag.rawValue, for: .normal)
        writeView.eventTypeSelectButton.setTitleColor(.black, for: .normal)
        writeView.eventTypeSelectButton.layer.borderColor = UIColor.black!.cgColor
    }
}
