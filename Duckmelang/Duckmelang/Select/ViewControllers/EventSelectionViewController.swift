//
//  EventSelectionViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

protocol EventSelectionDelegate: AnyObject {
    func didSelectEvent(_ event: Event)
}

class EventSelectionViewController: UIViewController, EventSelectionViewDelegate {

    weak var delegate: EventSelectionDelegate?
    var dismissCompletion: (() -> Void)?
    
    private var selectedEvent: Event?
    
    private lazy var eventSelectionView: EventSelectionView = {
        let view = EventSelectionView(selectedEvent: selectedEvent)
        view.delegate = self
        return view
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
        view.addSubview(eventSelectionView.view)
        addChild(eventSelectionView)
        eventSelectionView.didMove(toParent: self)

        eventSelectionView.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissCompletion?()
    }
}

// MARK: - EventSelectionDelegate
extension EventSelectionViewController: EventSelectionDelegate {
    func didSelectEvent(_ event: Event) {
        delegate?.didSelectEvent(event)
        dismiss(animated: true)
    }
}
