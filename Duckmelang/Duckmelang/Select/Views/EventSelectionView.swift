//
//  EventSelectionView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit
import SnapKit
//FIXME: - UI 수정 필요!!!
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
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return button
    }()

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
        view.addSubview(completeButton)
        
        eventStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(eventStackView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }
        
        setupEventTags()
    }
    
    private func setupEventTags() {
        for tag in EventTag.allCases {
            let button = createTagButton(for: tag)
            eventStackView.addArrangedSubview(button)
        }
    }
    
    private func createTagButton(for tag: EventTag) -> UIButton {
        let button = UIButton()
        button.setTitle(tag.rawValue, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.backgroundColor = selectedEvent?.tag == tag ? UIColor.lightGray : UIColor.clear
        button.addTarget(self, action: #selector(didTapTagButton(_:)), for: .touchUpInside)
        button.tag = EventTag.allCases.firstIndex(of: tag) ?? 0
        return button
    }
    
    @objc private func didTapTagButton(_ sender: UIButton) {
        let tag = EventTag.allCases[sender.tag]
        selectedEvent = Event(tag: tag)
        
        for case let button as UIButton in eventStackView.arrangedSubviews {
            button.backgroundColor = .clear
        }
        
        sender.backgroundColor = UIColor.lightGray
    }
    
    @objc private func didTapCompleteButton() {
        guard let selectedEvent = selectedEvent else { return }
        delegate?.didSelectEvent(selectedEvent)
        dismiss(animated: true)
    }
}
