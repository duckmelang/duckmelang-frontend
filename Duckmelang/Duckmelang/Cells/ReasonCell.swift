//
//  ReasonCell.swift
//  Duckmelang
//
//  Created by nau on 7/17/25.
//
import UIKit
import SnapKit

final class ReasonCell: UITableViewCell {
    static let identifier = "ReasonCell"
    
    // MARK: - UI 구성 요소
    private let reasonLabel = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .grey700
    }
    
    // MARK: - 외부에서 선택 시 동작할 클로저
    var onSelect: (() -> Void)?
    
    // MARK: - 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
        setupTapGesture()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reasonLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupView() {
        contentView.addSubview(reasonLabel)
        
        reasonLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tap)
    }
    
    // MARK: - 데이터 설정
    func configure(with reason: String, isSelected: Bool, onSelect: @escaping () -> Void) {
        reasonLabel.text = reason
        self.onSelect = onSelect
    }
    
    // MARK: - 탭 처리
    @objc private func cellTapped() {
        print("✅ ReasonCell 탭됨: \(reasonLabel.text ?? "")")
        onSelect?()
    }
}
