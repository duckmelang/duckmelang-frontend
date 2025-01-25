//
//  EventSelectionView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit
import SnapKit

protocol EventSelectionViewDelegate: AnyObject {
    func didSelectEvent(_ event: Event)
}

class EventSelectionView: UIViewController {

    weak var delegate: EventSelectionViewDelegate?
    
    private var selectedEvent: Event?
    
    private lazy var eventStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    let completeButton = smallFilledCustomBtn(title: "완료").then{
        $0.addTarget(self,action: #selector(didTapCompleteButton),for: .touchUpInside)
    }

    init(selectedEvent: Event?) {
        self.selectedEvent = selectedEvent
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupEventTags()

        // 완료 버튼 추가
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20) // 하단 고정
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }
    }

    private func setupEventTags() {
        let allTags = EventTag.allCases
        var buttons: [smallStorkeCustomBtn] = []

        for tag in allTags {
            let button = smallStorkeCustomBtn(
                borderColor: selectedEvent?.tag == tag ? UIColor.grey400!.cgColor : UIColor.dmrBlue!.cgColor,
                title: tag.rawValue,
                titleColor: selectedEvent?.tag == tag ? .grey400! : .dmrBlue!,
                radius: 10,
                isEnabled: true
            )
            button
                .addTarget(
                    self,
                    action: #selector(didTapTagButton(_:)),
                    for: .touchUpInside
                )
            button.tag = EventTag.allCases.firstIndex(of: tag) ?? 0
            buttons.append(button)
            view.addSubview(button)
        }

        // 버튼 위치 설정 (한 줄에 2개씩 배치)
        for (index, button) in buttons.enumerated() {
            button.snp.makeConstraints {
                if index % 2 == 0 { // 왼쪽 버튼
                    $0.leading.equalToSuperview().inset(20)
                } else { // 오른쪽 버튼
                    let prevButton = buttons[index - 1]
                    $0.leading.equalTo(prevButton.snp.trailing).offset(10)
                }
                
                if index < 2 { // 첫 번째 줄
                    $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
                } else if index % 2 == 0 { // 새로운 줄 (왼쪽 버튼)
                    let prevRowButton = buttons[index - 2]
                    $0.top.equalTo(prevRowButton.snp.bottom).offset(10)
                } else { // 오른쪽 버튼은 왼쪽 버튼과 같은 Y축
                    let prevButton = buttons[index - 1]
                    $0.top.equalTo(prevButton.snp.top)
                }
                
                $0.width.equalTo(140)
                $0.height.equalTo(44)
            }
        }
    }

    @objc private func didTapTagButton(_ sender: UIButton) {
        let tag = EventTag.allCases[sender.tag]
        selectedEvent = Event(tag: tag)

        for case let button as smallStorkeCustomBtn in view.subviews where button is smallStorkeCustomBtn {
            button.borderColor = UIColor.grey400!
            button.setTitleColor(UIColor.grey400, for: .normal)
        }

        // 선택된 버튼만 파란색으로 변경
        if let selectedButton = sender as? smallStorkeCustomBtn {
            selectedButton.borderColor = UIColor.dmrBlue!
            selectedButton.setTitleColor(UIColor.dmrBlue, for: .normal)
        }
    }

    @objc private func didTapCompleteButton() {
        guard let selectedEvent = selectedEvent else { return }
        delegate?.didSelectEvent(selectedEvent)
        dismiss(animated: true)
    }
}
