//
//  DateSelectionViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 3/8/25.
//

import UIKit

protocol DateSelectionViewControllerDelegate: AnyObject {
    func updateSelectedDate(_ date: Date)
}

class DateSelectionViewController: UIViewController {
    weak var delegate: DateSelectionViewControllerDelegate?
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = dateSelectionView
        
        if let selectedDate = selectedDate {
            dateSelectionView.datePicker.setDate(selectedDate, animated: false)
        }
    }
    
    private lazy var dateSelectionView: DateSelectionView = {
        let view = DateSelectionView()
        view.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        view.completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return view
    }()
    
    @objc private func dateChanged() {
        selectedDate = dateSelectionView.datePicker.date
    }
    
    @objc private func didTapCompleteButton() {
        delegate?.updateSelectedDate(selectedDate!)
        dismiss(animated: true)
    }
}
