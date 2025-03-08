//
//  DateSelectionView.swift
//  Duckmelang
//
//  Created by 주민영 on 3/8/25.
//

import UIKit

class DateSelectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
        $0.minimumDate = Date()
    }
    
    let completeButton = smallFilledCustomBtn(title: "완료")
    
    private func setupView() {
        addSubview(datePicker)
        addSubview(completeButton)
        
        datePicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.height.equalTo(168)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
