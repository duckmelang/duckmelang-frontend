//
//  FeedManagementViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class FeedManagementViewController: UIViewController {
    
    var data = FeedManagementModel.dummy()
    
    var selectedIndices: Set<IndexPath> = [] // 선택된 셀의 indexPath를 저장

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = feedManagementView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        setupAction()
    }
    
    private lazy var feedManagementView = FeedManagementView()

    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc
    private func deleteBtnDidTap() {
        guard !selectedIndices.isEmpty else {
            // 선택된 셀이 없을 경우
            print("No selected row")
            return
        }
        
        // 선택된 indexPath들을 정렬하여 처리 (역순으로 삭제하면 index 문제가 발생하지 않음)
        let sortedIndices = selectedIndices.sorted { $0.row > $1.row }
        
        // 데이터 모델에서 제거
        for indexPath in sortedIndices {
            data.remove(at: indexPath.row)
        }
        
        // 테이블 뷰에서 제거
        feedManagementView.postView.deleteRows(at: sortedIndices, with: .automatic)
        
        // 선택 상태 초기화
        selectedIndices.removeAll()
    }
    
    @objc
    private func finishBtnDidTap() {
        // 선택된 IndexPath에 해당하는 데이터를 삭제
        selectedIndices.sorted(by: { $0.row > $1.row }).forEach { indexPath in
            data.remove(at: indexPath.row)
        }
        
        // 테이블 뷰 갱신
        feedManagementView.postView.reloadData()
        
        // 선택된 IndexPath 초기화
        selectedIndices.removeAll()
        
        feedManagementView.deleteBtn.isHidden = true
    }
    
    private func setupDelegate() {
        feedManagementView.postView.dataSource = self
        feedManagementView.postView.delegate = self
    }
    
    private func setupAction() {
        feedManagementView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        feedManagementView.finishBtn.addTarget(self, action: #selector(finishBtnDidTap), for: .touchUpInside)
        feedManagementView.deleteBtn.addTarget(self, action: #selector(deleteBtnDidTap), for: .touchUpInside)
    }
}

extension FeedManagementViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedManagementCell.identifier, for: indexPath) as? FeedManagementCell else {
            return UITableViewCell()
        }
        cell.configure(model: data[indexPath.row])
        
        // 셀이 선택된 상태인지 확인
        if selectedIndices.contains(indexPath) {
            cell.selectBtn.isSelected = true
            cell.selectBtn.setImage(.select, for: .normal)
            cell.contentView.backgroundColor = .grey100
        } else {
            cell.selectBtn.isSelected = false
            cell.selectBtn.setImage(.noSelect, for: .normal)
            cell.contentView.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FeedManagementCell {
            // 선택된 셀을 토글
            if selectedIndices.contains(indexPath) {
                // 이미 선택된 경우, 선택 해제
                selectedIndices.remove(indexPath)
                cell.selectBtn.isSelected = false
                cell.selectBtn.setImage(.noSelect, for: .normal)
                cell.contentView.backgroundColor = .clear
            } else {
                // 새로 선택된 경우
                selectedIndices.insert(indexPath)
                cell.selectBtn.isSelected = true
                cell.selectBtn.setImage(.select, for: .normal)
                cell.contentView.backgroundColor = .grey100
            }
            
            // delete 버튼 상태 업데이트
            feedManagementView.deleteBtn.isHidden = selectedIndices.isEmpty
        }
    }
}
