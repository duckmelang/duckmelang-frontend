//
//  PostFilterViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/5/25.
//

import UIKit

class PostFilterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = postFilterView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
    }
    
    // 현재 확장된 섹션 (없으면 nil)
    private var expandedSection: Int? = nil
    
    private var expandedIndexPath: IndexPath? = nil
    
    // 필터 옵션 리스트
    private let filters = ["성별", "나이"]
    
    private lazy var postFilterView = PostFilterView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    private lazy var tableView = postFilterView.postFilterTableView
    
    private func setupDelegate() {
        postFilterView.postFilterTableView.delegate = self
        postFilterView.postFilterTableView.dataSource = self
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc
    private func handleSectionTap(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        
        let indexPath = IndexPath(row: 0, section: section)
        
        let previousExpandedSection = expandedIndexPath?.section
        let isSameSection = previousExpandedSection == section

        if isSameSection {
            expandedIndexPath = nil
        } else {
            expandedIndexPath = indexPath
        }

        tableView.performBatchUpdates({
            if let previousSection = previousExpandedSection {
                tableView.reloadSections(IndexSet(integer: previousSection), with: .automatic)
            }
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }, completion: nil)
    }

}

extension PostFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedIndexPath == IndexPath(row: 0, section: section) ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = filters[indexPath.section]

        let cell: UITableViewCell

        if sectionTitle == "성별" {
            guard let genderCell = tableView.dequeueReusableCell(withIdentifier: GenderSelectionCell.identifier, for: indexPath) as? GenderSelectionCell else {
                return UITableViewCell()
            }
            cell = genderCell
        } else if sectionTitle == "나이" {
            guard let ageCell = tableView.dequeueReusableCell(withIdentifier: AgeSelectionCell.identifier, for: indexPath) as? AgeSelectionCell else {
                return UITableViewCell()
            }
            cell = ageCell
        } else {
            return UITableViewCell()
        }

        //각 SelectionCell 아래 구분선 추가
        let separatorTag = 200
        let existingSeparator = cell.contentView.viewWithTag(separatorTag)
        
        if existingSeparator == nil {
            let separator = UIView().then {
                $0.backgroundColor = .grey200
                $0.tag = separatorTag  //태그 지정하여 중복 추가 방지
            }
            cell.contentView.addSubview(separator)
            separator.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if expandedSection == indexPath.section {
                expandedSection = nil // 이미 열려 있으면 닫음
            } else {
                expandedSection = indexPath.section // 새로운 섹션을 열기
            }
            tableView.reloadData() // 변경 사항 반영
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView().then {
            $0.backgroundColor = .white
            $0.tag = section
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSectionTap(_:))))
        }

        let label = Label(text: filters[section], font: .ptdSemiBoldFont(ofSize: 17), color: .grey800)
        
        let toggleButton = UIButton().then {
            let isExpanded = expandedIndexPath?.section == section
            let imageName = isExpanded ? "chevron.up" : "chevron.down"
            $0.setImage(UIImage(systemName: imageName), for: .normal)
            $0.tintColor = .grey500
            $0.addTarget(self, action: #selector(handleSectionTap(_:)), for: .touchUpInside)
        }
        
        let separator = UIView().then {
            $0.backgroundColor = .grey200
            $0.tag = 100  //태그를 지정하여 구분선 숨김 처리 가능하게
        }

        [label, toggleButton, separator].forEach({headerView.addSubview($0)})
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        toggleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        //구분선 숨김 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            separator.isHidden = self.expandedIndexPath?.section == section
        }

        return headerView
    }

}
