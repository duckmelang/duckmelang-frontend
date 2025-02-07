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

    private lazy var stack = Stack(axis: .horizontal, spacing: 16)
   
    private func addStack() {
        [maleBtn, femaleBtn].forEach{stack.addArrangedSubview($0)}
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addStack()
        contentView.addSubview(stack)
        
        stack.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        maleBtn.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.width.equalTo(49)
        }
        
        femaleBtn.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.width.equalTo(49)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class AgeSelectionCell: UITableViewCell {
    
    static let identifier = "AgeSelectionCell"
    
    private let rangeSlider = RangeSlider().then {
        $0.minValue = 18
        $0.maxValue = 50
        $0.lowerValue = 18
        $0.upperValue = 28
    }
    
    private let ageLabel = Label(text: "만 18 ~ 28세", font: .ptdSemiBoldFont(ofSize: 22), color: .grey800)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(ageLabel)
        contentView.addSubview(rangeSlider)
        
        ageLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        rangeSlider.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func rangeSliderValueChanged(_ sender: RangeSlider) {
        ageLabel.text = "만 \(Int(sender.lowerValue)) ~ \(Int(sender.upperValue))세"
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class RangeSlider: UIControl {
    
    var minValue: Float = 18
    var maxValue: Float = 50
    
    var lowerValue: Float = 18 {
        didSet {
            if lowerValue > upperValue { lowerValue = upperValue } // 초과 방지
            updateLayerFrames()
        }
    }
    
    var upperValue: Float = 28 {
        didSet {
            if upperValue < lowerValue { upperValue = lowerValue } // 역전 방지
            updateLayerFrames()
        }
    }
    
    private let trackView = UIView().then {
        $0.backgroundColor = .grey600
        $0.layer.cornerRadius = 3
    }
    
    private let lowerThumbView = UIView().then {
        $0.backgroundColor = .grey0
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.grey500?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.shadowColor = UIColor.grey0?.cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 1
    }
    
    private let upperThumbView = UIView().then {
        $0.backgroundColor = .grey0
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.grey500?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.shadowColor = UIColor.grey0?.cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        updateLayerFrames()
    }
    
    //초기 프레임 설정 (슬라이더 위치가 처음부터 올바르게 보이게 함)
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
        addSubview(lowerThumbView)
        addSubview(upperThumbView)
        
        // 팬 제스처 추가 (손가락 드래그 감지)
        let lowerPan = UIPanGestureRecognizer(target: self, action: #selector(handleLowerPan(_:)))
        lowerThumbView.addGestureRecognizer(lowerPan)
        
        let upperPan = UIPanGestureRecognizer(target: self, action: #selector(handleUpperPan(_:)))
        upperThumbView.addGestureRecognizer(upperPan)
    }
    
    private func updateLayerFrames() {
        let trackHeight: CGFloat = 4
        let thumbSize: CGFloat = 24
        
        let lowerThumbCenter = CGFloat((lowerValue - minValue) / (maxValue - minValue)) * bounds.width
        let upperThumbCenter = CGFloat((upperValue - minValue) / (maxValue - minValue)) * bounds.width
        
        trackView.frame = CGRect(x: 0, y: bounds.midY - trackHeight / 2, width: bounds.width, height: trackHeight)
        
        lowerThumbView.frame = CGRect(x: lowerThumbCenter - thumbSize / 2, y: bounds.midY - thumbSize / 2, width: thumbSize, height: thumbSize)
        
        upperThumbView.frame = CGRect(x: upperThumbCenter - thumbSize / 2, y: bounds.midY - thumbSize / 2, width: thumbSize, height: thumbSize)
    }
    
    @objc private func handleLowerPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let percentage = Float(translation.x / bounds.width)
        let newValue = lowerValue + percentage * (maxValue - minValue)
        
        lowerValue = min(upperValue, max(minValue, newValue)) // 🚀 초과 방지
        gesture.setTranslation(.zero, in: self)
        sendActions(for: .valueChanged)
    }
    
    @objc private func handleUpperPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let percentage = Float(translation.x / bounds.width)
        let newValue = upperValue + percentage * (maxValue - minValue)
        
        upperValue = min(maxValue, max(lowerValue, newValue)) // 🚀 역전 방지
        gesture.setTranslation(.zero, in: self)
        sendActions(for: .valueChanged)
    }
}
