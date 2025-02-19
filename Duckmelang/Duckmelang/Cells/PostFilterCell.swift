//
//  PostFilterCell.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/5/25.
//

import UIKit

class PostFilterCell: UITableViewCell {

    static let identifier = "PostFilterCell"
    
    let titleLabel = Label(text: "", font: .ptdSemiBoldFont(ofSize: 17), color: .grey800)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class GenderSelectionCell: UITableViewCell {
    
    static let identifier = "GenderSelectionCell"
    
    var selectedGender: String? {
        didSet {
            updateGenderUI()
        }
    }
    
    var onGenderSelected: ((String?) -> Void)?
    
    private let maleBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("남성", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 14), .foregroundColor: UIColor.grey400!]))
        $0.configuration = config
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 1
    }
    
    private let femaleBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("여성", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 14), .foregroundColor: UIColor.grey400!]))
        $0.configuration = config
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 1
    }
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = Stack(axis: .horizontal, spacing: 16)
        contentView.addSubview(stack)
        [maleBtn, femaleBtn].forEach{stack.addArrangedSubview($0)}
        
        stack.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        
        maleBtn.addTarget(self, action: #selector(genderSelected(_:)), for: .touchUpInside)
        femaleBtn.addTarget(self, action: #selector(genderSelected(_:)), for: .touchUpInside)
        
        updateGenderUI()
    }
    
    @objc private func genderSelected(_ sender: UIButton) {
        if sender == maleBtn { //남자버튼을 눌렀을때
            if selectedGender == "BOTH" {
                selectedGender = "FEMALE" // ✅ BOTH 상태에서 남성 해제 → 여성만 남음
            } else if selectedGender == "MALE" {
                selectedGender = "MALE" // ✅ 남성 선택 해제 → 아무것도 선택 안되는 건 불가
            } else {
                selectedGender = "BOTH"
            }
        } else if sender == femaleBtn {
            if selectedGender == "BOTH" {
                selectedGender = "MALE" // ✅ BOTH 상태에서 여성 해제 → 남성만 남음
            } else if selectedGender == "FEMALE" {
                selectedGender = "FEMALE" // ✅ 여성 선택 해제 → 아무것도 선택 안되는 건 안됨.
            } else {
                selectedGender = "BOTH"
            }
        }

        onGenderSelected?(selectedGender)
        updateGenderUI()
    }
    
    func updateGenderUI() {
        print("📌 updateGenderUI() - selectedGender: \(selectedGender ?? "nil")")

        if selectedGender == "MALE" || selectedGender == "BOTH" {
            maleBtn.backgroundColor = .dmrBlue
            maleBtn.layer.borderColor = UIColor.dmrBlue?.cgColor
            maleBtn.setTitleColor(.white, for: .normal)
        } else {
            maleBtn.backgroundColor = .clear
            maleBtn.layer.borderColor = UIColor.grey400?.cgColor
            maleBtn.setTitleColor(.grey400, for: .normal)
        }

        if selectedGender == "FEMALE" || selectedGender == "BOTH" {
            femaleBtn.backgroundColor = .dmrBlue
            femaleBtn.layer.borderColor = UIColor.dmrBlue?.cgColor
            femaleBtn.setTitleColor(.white, for: .normal)
        } else {
            femaleBtn.backgroundColor = .clear
            femaleBtn.layer.borderColor = UIColor.grey400?.cgColor
            femaleBtn.setTitleColor(.grey400, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class AgeSelectionCell: UITableViewCell {
    
    static let identifier = "AgeSelectionCell"
    
    var minAge: Int? {
        didSet { updateUI() }
    }
    
    var maxAge: Int? {
        didSet { updateUI() }
    }
    
    var onAgeChanged: ((Int, Int) -> Void)?
    
    private let rangeSlider = RangeSlider()
    private let ageLabel = Label(text: "만 18 ~ 50살", font: .ptdSemiBoldFont(ofSize: 22), color: .grey800).then {
        $0.textAlignment = .left
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(ageLabel)
        contentView.addSubview(rangeSlider)
        
        ageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview()
        }
        rangeSlider.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc private func rangeSliderValueChanged(_ sender: RangeSlider) {
        let newMinAge = Int(sender.lowerValue)
        let newMaxAge = Int(sender.upperValue)
        
        guard newMinAge != minAge || newMaxAge != maxAge else { return } // ✅ 값이 바뀐 경우만 업데이트

        minAge = newMinAge
        maxAge = newMaxAge

        print("📌 rangeSliderValueChanged - minAge: \(minAge!), maxAge: \(maxAge!)")

        DispatchQueue.main.async {
            self.ageLabel.text = "만 \(self.minAge!) ~ \(self.maxAge!)살"  // ✅ 직접 업데이트
            self.onAgeChanged?(self.minAge!, self.maxAge!)  // ✅ 변경된 값을 부모 컨트롤러로 전달
        }
    }

    func updateUI() {
        guard let min = minAge, let max = maxAge else {
            print("⚠️ updateUI() 호출 실패 - minAge 또는 maxAge가 nil")
            return
        }

        print("📌 updateUI() 호출됨 - minAge: \(min), maxAge: \(max)")

        DispatchQueue.main.async {
            self.ageLabel.text = "만 \(min) ~ \(max)살"
            self.rangeSlider.lowerValue = Float(min)
            self.rangeSlider.upperValue = Float(max)
            self.rangeSlider.updateLayerFrames()
            self.layoutIfNeeded()
        }
    }

}

class RangeSlider: UIControl {
    
    var minValue: Float = 18
    var maxValue: Float = 50
    
    var lowerValue: Float = 18 {
        didSet {
            if lowerValue > upperValue { lowerValue = upperValue }
            updateLayerFrames()
        }
    }
    
    var upperValue: Float = 50 {
        didSet {
            if upperValue < lowerValue { upperValue = lowerValue }
            updateLayerFrames()
        }
    }
    
    private let trackView = UIView().then {
           $0.backgroundColor = .grey200
           $0.layer.cornerRadius = 3
       }

       private let selectedTrackView = UIView().then {
           $0.backgroundColor = .grey600
           $0.layer.cornerRadius = 3
       }
    
    private let lowerThumbView = UIView().then {
        $0.backgroundColor = .grey0
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.grey500!.cgColor
        $0.layer.borderWidth = 1
        $0.layer.shadowColor = UIColor.grey600!.cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
    }
    
    private let upperThumbView = UIView().then {
        $0.backgroundColor = .grey0
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.grey500!.cgColor
        $0.layer.borderWidth = 1
        $0.layer.shadowColor = UIColor.grey600!.cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        updateLayerFrames()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        updateLayerFrames()
    }
    
    private func setupViews() {
        addSubview(trackView)
        addSubview(selectedTrackView)
        addSubview(lowerThumbView)
        addSubview(upperThumbView)
        
        let lowerPan = UIPanGestureRecognizer(target: self, action: #selector(handleLowerPan(_:)))
        lowerThumbView.isUserInteractionEnabled = true
        lowerThumbView.addGestureRecognizer(lowerPan)
        
        let upperPan = UIPanGestureRecognizer(target: self, action: #selector(handleUpperPan(_:)))
        upperThumbView.isUserInteractionEnabled = true
        upperThumbView.addGestureRecognizer(upperPan)
    }
    
    func updateLayerFrames() {
        let trackHeight: CGFloat = 4
        let thumbSize: CGFloat = 24
        let availableWidth = bounds.width
        
        let lowerThumbCenter = CGFloat((lowerValue - minValue) / (maxValue - minValue)) * availableWidth + thumbSize / 2
        let upperThumbCenter = CGFloat((upperValue - minValue) / (maxValue - minValue)) * availableWidth + thumbSize / 2
        
        trackView.frame = CGRect(x: 0, y: bounds.midY - trackHeight / 2, width: availableWidth, height: trackHeight)

        selectedTrackView.frame = CGRect(x: lowerThumbCenter, y: bounds.midY - trackHeight / 2, width: upperThumbCenter - lowerThumbCenter, height: trackHeight)
        
        lowerThumbView.frame = CGRect(x: lowerThumbCenter - thumbSize / 2, y: bounds.midY - thumbSize / 2, width: thumbSize, height: thumbSize)

        upperThumbView.frame = CGRect(x: upperThumbCenter - thumbSize / 2, y: bounds.midY - thumbSize / 2, width: thumbSize, height: thumbSize)

        setNeedsDisplay()
    }
    
    @objc private func handleLowerPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let percentage = (translation.x / bounds.width) * 0.1
        let valueChange = Float(percentage) * (maxValue - minValue)

        switch gesture.state {
        case .began, .changed:
            lowerValue = max(minValue, min(lowerValue + valueChange, upperValue - 1))
            print("📌 Lower Pan Moved - lowerValue: \(lowerValue)")
            sendActions(for: .valueChanged)
        case .ended:
            gesture.setTranslation(.zero, in: self)
        default:
            break
        }
        updateLayerFrames()
    }
    
    @objc private func handleUpperPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let percentage = (translation.x / bounds.width) * 0.1
        let valueChange = Float(percentage) * (maxValue - minValue)

        switch gesture.state {
        case .began, .changed:
            upperValue = min(maxValue, max(upperValue + valueChange, lowerValue + 1))
            print("📌 Upper Pan Moved - upperValue: \(upperValue)")
            sendActions(for: .valueChanged) // ✅ 이벤트 전달
        case .ended:
            gesture.setTranslation(.zero, in: self)
        default:
            break
        }
        updateLayerFrames()
    }
}

