//
//  SelectFavoriteIdolView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import Then
import SnapKit

class SelectFavoriteCelebView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let titleLabel = UILabel().then {
        $0.text = "좋아하는 아이돌을 알려주세요!"
        $0.font = UIFont.aritaBoldFont(ofSize: 20)
        $0.textColor = .grey800
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "언제든 변경할 수 있어요"
        $0.font = UIFont.ptdRegularFont(ofSize: 13)
        $0.textColor = .grey600
    }
    
    private let celebTextField = UITextField().then {
        $0.placeholder = "텍스트 입력"
        $0.borderStyle = .roundedRect

        // 왼쪽 패딩 추가
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        $0.leftView = leftPaddingView
        $0.leftViewMode = .always

        // 돋보기 아이콘 추가 (오른쪽)
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .grey600
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        searchIcon.center = CGPoint(x: rightPaddingView.frame.width / 2, y: rightPaddingView.frame.height / 2)
        rightPaddingView.addSubview(searchIcon)

        $0.rightView = rightPaddingView
        $0.rightViewMode = .always
    }
    
    private let tagScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    private let tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private let dropdownContainerView = UIView().then {
        $0.isHidden = true
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 0
        $0.backgroundColor = .white
    }
    
    private let dropdownTableView = UITableView().then {
        $0.layer.cornerRadius = 8
    }
    
    private var idolCategories: [(id: Int, name: String)] = []
    private var selectedIdols: [(id: Int, name: String)] = []

    var onTextInput: ((String) -> Void)?
    var onIdolSelected: ((Int) -> Void)?
    var onIdolRemoved: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            titleLabel,
            subtitleLabel,
            celebTextField,
            tagScrollView,
            dropdownContainerView
        ].forEach {
            addSubview($0)
        }
        
        tagScrollView.addSubview(tagStackView)
        dropdownContainerView.addSubview(dropdownTableView)
            
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
            
        celebTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        tagScrollView.snp.makeConstraints {
            $0.top.equalTo(celebTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        tagStackView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().priority(.low)
            $0.width.greaterThanOrEqualTo(tagScrollView.snp.width).priority(.high)
        }
        
        dropdownContainerView.snp.makeConstraints {
            $0.top.equalTo(tagScrollView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(200)
        }
        
        dropdownTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        celebTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func updateDropdown(with idolCategories: [(id: Int, name: String)]) {
        self.idolCategories = idolCategories
        dropdownTableView.reloadData()

        // 기존 드롭다운 상태 유지, 필터링 결과가 없으면 숨김
        dropdownContainerView.isHidden = celebTextField.text?.isEmpty ?? true || idolCategories.isEmpty
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        onTextInput?(text)
        
        dropdownContainerView.isHidden = text.isEmpty
    }

    func addTag(_ idol: (id: Int, name: String)) {
        guard !selectedIdols.contains(where: { $0.id == idol.id }) else { return }
        selectedIdols.append(idol)
        updateTagsView()
        celebTextField.text = "" // 선택 후 입력창 초기화
        dropdownContainerView.isHidden = true // 선택 후 드롭다운 숨김
    }
    
    func removeTag(_ id: Int) {
        selectedIdols.removeAll { $0.id == id }
        updateTagsView()
    }
    
    private func updateTagsView() {
        tagScrollView.isHidden = selectedIdols.isEmpty ? true : false

        let existingTags = tagStackView.arrangedSubviews.compactMap { $0 as? TagView } // 현재 추가된 태그 목록
        let existingIds = Set(existingTags.map { $0.id }) // 기존 태그의 ID 목록
        let newIds = Set(selectedIdols.map { $0.id }) // 새롭게 추가된 태그의 ID 목록
        
        // 삭제된 태그 제거
        for tag in existingTags where !newIds.contains(tag.id) {
            tagStackView.removeArrangedSubview(tag)
            tag.removeFromSuperview()
        }
        
        // 추가된 태그만 새로 추가
        for idol in selectedIdols where !existingIds.contains(idol.id) {
            let tagView = createTagView(idol)
            tagStackView.addArrangedSubview(tagView)
            print("🟡 태그 추가됨: \(idol.name) (ID: \(idol.id))")
        }

        self.layoutIfNeeded()
        tagScrollView.contentSize = tagStackView.frame.size
        print("현재 아이템 개수: \(tagStackView.arrangedSubviews.count)개")
    }
    
    private func createTagView(_ idol: (id: Int, name: String)) -> UIView {
        let tagView = TagView(id: idol.id, name: idol.name)

        tagView.onDelete = { [weak self] id in
            self?.removeTag(id)
        }

        tagView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.greaterThanOrEqualTo(80)
        }

        return tagView
    }

    @objc private func removeTagAction(_ sender: UIButton) {
        onIdolRemoved?(sender.tag)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idolCategories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = idolCategories[indexPath.row]
        guard !selectedIdols.contains(where: { $0.id == selected.id }) else { return }
        
        onIdolSelected?(selected.id)
        
        celebTextField.text = "" // 입력창 초기화
        dropdownContainerView.isHidden = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = idolCategories[indexPath.row].name
        return cell
    }
}

class TagView: UIView {
    let id: Int
    var onDelete: ((Int) -> Void)?
    
    private let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("✖", for: .normal)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    init(id: Int, name: String) {
        self.id = id
        super.init(frame: .zero)
        
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        nameLabel.text = name
        deleteButton.addTarget(self, action: #selector(removeTagAction(_:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, deleteButton]).then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = nameLabel.intrinsicContentSize
        let buttonSize = deleteButton.intrinsicContentSize
        return CGSize(width: labelSize.width + buttonSize.width + 24, height: max(labelSize.height, buttonSize.height) + 12)
    }

    @objc private func removeTagAction(_ sender: UIButton) {
        onDelete?(id)
    }
}
