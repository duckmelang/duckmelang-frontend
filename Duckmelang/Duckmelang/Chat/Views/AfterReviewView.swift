//
//  ReviewView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit
import Cosmos

class AfterReviewView: UIView, UITextViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cosmosView = CosmosView().then {
        $0.rating = 4.0
        $0.settings.fillMode = .precise
        $0.settings.starSize = 25
        $0.settings.starMargin = 6.4
        $0.settings.filledImage = UIImage(resource: .star)
        $0.settings.emptyImage = UIImage(resource: .emptyStar)
        
        $0.text = "4.0"
        $0.settings.textColor = .mainColor!
        $0.settings.textFont = .ptdSemiBoldFont(ofSize: 17)
        $0.settings.textMargin = 12
    }
    
    let subRatingLabel = UILabel().then {
        $0.text = "/ 5"
        $0.font = .ptdRegularFont(ofSize: 17)
        $0.textColor = .grey600
        $0.textAlignment = .left
    }
    
    let ratingLabel = UILabel().then {
        $0.text = "훌륭해요! 기대 이상이에요!"
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey800
        $0.textAlignment = .center
    }
    
    let detailMain = MiddleReviewView()
    
    let textViewPlaceHolder = "리뷰를 작성해주세요"
    
    public lazy var reviewTextView = UITextView().then {
        $0.font = .ptdRegularFont(ofSize: 13)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.backgroundColor = .white
        
        $0.isEditable = true
        $0.isScrollEnabled = true
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 7
        
        $0.text = textViewPlaceHolder
        $0.textColor = .grey500
        $0.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
            self.finishBtn.setEnabled(true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .grey500
            self.finishBtn.setEnabled(false)
        }
    }
    
    let finishBtn = longCustomBtn(title: "완료", isEnabled: false)
        
    private func setupView() {
        [
            cosmosView,
            subRatingLabel,
            ratingLabel,
            detailMain,
            reviewTextView,
            finishBtn
        ].forEach {
            addSubview($0)
        }
        
        cosmosView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(64)
            $0.leading.equalToSuperview().offset(88)
            $0.height.equalTo(25)
        }
        
        subRatingLabel.snp.makeConstraints {
            $0.leading.equalTo(cosmosView.snp.trailing).offset(10)
            $0.centerY.equalTo(cosmosView.snp.centerY)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(cosmosView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        detailMain.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        reviewTextView.snp.makeConstraints {
            $0.top.equalTo(detailMain.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(343)
            $0.height.equalTo(101)
        }
        
        finishBtn.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.centerX.equalToSuperview()
        }
    }
}
