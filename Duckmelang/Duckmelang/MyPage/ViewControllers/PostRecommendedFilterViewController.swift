//
//  PostRecommendedFilterViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class PostRecommendedFilterViewController: UIViewController, UICollectionViewDelegate {

    private var filters: [PostRecommendedFilterModel] = PostRecommendedFilterModel.dummy() // 추천 필터 데이터 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = postRecommendedFilterView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
    }
    
    private lazy var postRecommendedFilterView = PostRecommendedFilterChangeView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.searchIcon.addTarget(self, action: #selector(addFilter), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc private func addFilter() {
        guard let filterText = postRecommendedFilterView.searchBar.text, !filterText.isEmpty else {
            // 텍스트가 비어있으면 추가하지 않음
            return
        }
        
        // 새로운 필터 추가
        filters.append(PostRecommendedFilterModel(filter: filterText))
        
        // 새로 추가된 셀의 인덱스 계산
        let newIndexPath = IndexPath(item: filters.count - 1, section: 0)
        
        // 컬렉션 뷰에 애니메이션과 함께 추가
        postRecommendedFilterView.recommendFilterCollectionView.performBatchUpdates {
            postRecommendedFilterView.recommendFilterCollectionView.insertItems(at: [newIndexPath])
        }
        
        // 검색 바 초기화
        postRecommendedFilterView.searchBar.text = ""
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag // 버튼의 태그를 기반으로 삭제할 필터의 인덱스를 가져옴
        
        // ✅ 배열 범위 내의 index인지 확인하여 삭제
        guard index >= 0, index < filters.count else {
            return
        }

        // ✅ 배열에서 해당 필터 삭제
        filters.remove(at: index)
        
        // ✅ 컬렉션 뷰 갱신 (performBatchUpdates 대신 reloadData() 사용)
        postRecommendedFilterView.recommendFilterCollectionView.reloadData()
    }


    
    private func setupDelegate() {
        postRecommendedFilterView.recommendFilterCollectionView.dataSource = self
        postRecommendedFilterView.recommendFilterCollectionView.delegate = self
    }
    
}

extension PostRecommendedFilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return filters.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            PostRecommendedFilterCell.identifier,
            for: indexPath //행 식별위해 파라미터로 받음
        ) as? PostRecommendedFilterCell else {
                return UICollectionViewCell()
        }
        
        let filter = filters[indexPath.item]
        cell.configure(model: filter)
        
        // 버튼 태그 설정
        cell.deleteBtn.tag = indexPath.item
        cell.deleteBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
 
        return cell
    }
}

extension PostRecommendedFilterViewController: PostRecommendedFilterCellDelegate {
    func didTapDeleteButton(cell: PostRecommendedFilterCell) {
        guard let indexPath = postRecommendedFilterView.recommendFilterCollectionView.indexPath(for: cell) else { return }

        let index = indexPath.item
        
        // ✅ 배열 범위 내의 index인지 확인하여 삭제
        guard index >= 0, index < filters.count else {
            return
        }
        
        // ✅ 배열에서 해당 필터 삭제
        filters.remove(at: index)

        // ✅ 컬렉션 뷰 갱신 (performBatchUpdates 대신 reloadData() 사용)
        postRecommendedFilterView.recommendFilterCollectionView.reloadData()
    }


}

protocol PostRecommendedFilterCellDelegate: AnyObject {
    func didTapDeleteButton(cell: PostRecommendedFilterCell)
}



