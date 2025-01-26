//
//  WriteView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit
import Then
import SnapKit

protocol WriteViewDelegate: AnyObject {
    func didTapIdolSelectButton()
    func didTapeventTypeSelectButton()
}

class WriteView: UIView {
    
    weak var delegate: WriteViewDelegate?
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
        
    private let contentView = UIView()
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .grey200
    }
    
    private let uploadImageView = UIButton().then {
        $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        $0.tintColor = .lightGray
        $0.backgroundColor = UIColor(white: 0.95, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let imageCountLabel = UILabel().then {
        $0.text = "0/10"
        $0.textColor = .gray
        $0.font = .ptdRegularFont(ofSize: 12)
    }
    
    private let titleTextField = UITextField().then {
        $0.placeholder = "게시글 제목"
        $0.borderStyle = .none
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray3.cgColor
        $0.font = .ptdRegularFont(ofSize: 16)
        $0.textColor = .black
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private let contentTextView = UITextView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray3.cgColor
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .black
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    private let placeholderLabel = UILabel().then {
        $0.text = "본문"
        $0.textColor = UIColor.systemGray3
        $0.font = .ptdRegularFont(ofSize: 15)
    }
    
    private let companionInfoLabel = UILabel().then {
        $0.text = "동행 정보"
        $0.font = .ptdSemiBoldFont(ofSize: 17)
        $0.textColor = .black
    }
    
    private let selectedCelebLabel = UILabel().then {
        $0.text = "아이돌"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .grey600
    }
    
    private let eventTypeLabel = UILabel().then {
        $0.text = "행사 종류"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .systemGray
    }
    
    private let eventDateLabel = UILabel().then {
        $0.text = "행사 날짜"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .systemGray
    }

    private let idolSelectButton = smallStorkeCustomBtn(title: "선택").then {
        $0.borderColor = .grey400
        $0.titleColor = .grey400
        $0.addTarget(self,action: #selector(idolSelectButtonTapped),for: .touchUpInside)
    }
    
    private let eventTypeSelectButton = smallStorkeCustomBtn(title: "선택").then {
        $0.borderColor = .grey400
        $0.titleColor = .grey400
        $0.addTarget(self,action: #selector(eventTypeSelectButtonTapped),for: .touchUpInside)
    }
    
    private let eventDateSelectButton = smallStorkeCustomBtn(title: "선택").then {
        $0.borderColor = .grey400
        $0.titleColor = .grey400
        $0.addTarget(self, action: #selector(eventDateSelectButtonTapped), for: .touchUpInside)
    }

    // StackView 정렬 (왼쪽 레이블, 오른쪽 버튼)
    private lazy var idolStackView = UIStackView(arrangedSubviews: [selectedCelebLabel, idolSelectButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    private lazy var eventTypeStackView = UIStackView(arrangedSubviews: [eventTypeLabel, eventTypeSelectButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    private lazy var eventDateStackView = UIStackView(arrangedSubviews: [eventDateLabel, eventDateSelectButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    private lazy var companionStackView = UIStackView(arrangedSubviews: [
        idolStackView, eventTypeStackView, eventDateStackView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let uploadButton = UIButton().then {
        $0.setTitle("업로드", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 22
        $0.isEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
        setupPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            backgroundView, uploadImageView, imageCountLabel,
            titleTextField, contentTextView,
            companionInfoLabel, companionStackView,
            uploadButton
        ].forEach {
            contentView.addSubview($0)
        }
        
        contentTextView.addSubview(placeholderLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        uploadImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backgroundView)
            $0.width.height.equalTo(80)
        }
        
        imageCountLabel.snp.makeConstraints {
            $0.top.equalTo(uploadImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(150)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.left.equalTo(contentTextView).offset(10)
        }
        
        companionInfoLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(16)
        }
        
        companionStackView.snp.makeConstraints {
            $0.top.equalTo(companionInfoLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        uploadButton.snp.makeConstraints {
            $0.top.equalTo(eventDateStackView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupPlaceholder() {
        contentTextView.delegate = self
    }

    @objc private func idolSelectButtonTapped() {
        delegate?.didTapIdolSelectButton()
    }
    
    @objc private func eventTypeSelectButtonTapped() {
        delegate?.didTapeventTypeSelectButton()
    }

    @objc private func eventDateSelectButtonTapped() {
        showDatePicker()
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
            self.dateChanged(datePicker.date)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)

        if let viewController = self.findViewController() {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }

    private func dateChanged(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let selectedDate = dateFormatter.string(from: date)

        eventDateSelectButton.setTitle(selectedDate, for: .normal)
        eventDateSelectButton.titleColor = .black
        eventDateSelectButton.borderColor = .black
    }

    func updateSelectedCeleb(_ celeb: Celeb) {
        idolSelectButton.setTitle(celeb.name, for: .normal)
        idolSelectButton.titleColor = .black
        idolSelectButton.borderColor = .black
    }
    
    func updateSelectedEvent(_ event: Event) {
        eventTypeSelectButton.setTitle(event.tag.rawValue, for: .normal)
        eventTypeSelectButton.titleColor = .black
        eventTypeSelectButton.borderColor = .black
    }
}

// Placeholder 자동 숨김
extension WriteView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// UIView 확장 - 현재 뷰가 속한 뷰 컨트롤러 찾기
extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
