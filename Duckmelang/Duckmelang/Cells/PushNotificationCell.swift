//
//  PushNotificationCell.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/30/25.
//

import UIKit

class PushNotificationCell: UITableViewCell {

    static let identifier = "PushNotificationCell"

    private let titleLabel = Label(text: "", font: .ptdRegularFont(ofSize: 16), color: .grey600)

    private let toggleSwitch = CustomToggleButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }

        toggleSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(39)
            $0.height.equalTo(24)
        }
    }

    func configure(with setting: PushNotificationModel, section: Int, row: Int, target: Any, action: Selector) {
        titleLabel.text = setting.title
        toggleSwitch.setToggleState(isOn: setting.isOn) // ✅ 현재 상태 반영
    }
}
