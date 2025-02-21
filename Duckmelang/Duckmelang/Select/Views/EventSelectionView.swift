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
        stackView.alignment = .leading // ✅ 버튼을 가운데 정렬
        return stackView
    }()
    
    let completeButton = smallFilledCustomBtn(title: "완료").then {
        $0.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
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
        
        view.addSubview(eventStackView)
        eventStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        setupEventTags()

        // ✅ 완료 버튼 추가
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }
    }

    private func setupEventTags() {
        let allTags = EventTag.allCases

        for (index, tag) in allTags.enumerated() {
            let button = smallStorkeCustomBtn(
                borderColor: selectedEvent?.tag == tag ? UIColor.dmrBlue!.cgColor : UIColor.grey400!.cgColor,
                title: tag.rawValue,
                titleColor: selectedEvent?.tag == tag ? .dmrBlue! : .grey400!,
                radius: 10,
                isEnabled: true
            )

            button.tag = index // ✅ 버튼 태그 설정 (index와 동일하게)
            button.addTarget(self, action: #selector(didTapTagButton(_:)), for: .touchUpInside)

            // ✅ 버튼을 UIStackView에 추가
            eventStackView.addArrangedSubview(button)

            button.snp.makeConstraints {
                $0.width.equalTo(140)
                $0.height.equalTo(44)
            }
        }
    }

    @objc private func didTapTagButton(_ sender: UIButton) {
        let selectedTag = EventTag.allCases[sender.tag]
        selectedEvent = Event(id: sender.tag, tag: selectedTag)

        // ✅ 모든 버튼의 UI 초기화
        for case let button as smallStorkeCustomBtn in eventStackView.arrangedSubviews {
            button.borderColor = UIColor.grey400!
            button.setTitleColor(.grey400, for: .normal)
        }

        // ✅ 선택된 버튼 UI 변경
        if let selectedButton = sender as? smallStorkeCustomBtn {
            selectedButton.borderColor = UIColor.dmrBlue!
            selectedButton.setTitleColor(.dmrBlue, for: .normal)
        }
    }

    @objc private func didTapCompleteButton() {
        guard let selectedEvent = selectedEvent else {
            return
        }
        delegate?.didSelectEvent(selectedEvent)
        dismiss(animated: true)
    }
}
