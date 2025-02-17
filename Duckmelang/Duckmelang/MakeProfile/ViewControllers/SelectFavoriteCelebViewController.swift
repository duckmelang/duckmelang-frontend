//
//  SelectFavoriteCelebViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//


import UIKit
import Alamofire
import Moya

class SelectFavoriteCelebViewController: UIViewController {

    private let selectFavoriteCelebView = SelectFavoriteCelebView()

    private var idolCategories: [(id: Int, name: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHandlers()
//        fetchIdolCategories()
        //FIXME: - 더미데이터, 수정필요
        loadDummyData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(selectFavoriteCelebView)
        
        selectFavoriteCelebView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupHandlers() {
        // 텍스트 입력 이벤트 감지 → 필터링 적용
        selectFavoriteCelebView.onTextInput = { [weak self] query in
            self?.filterIdols(with: query)
        }

        // 아이돌 선택 이벤트 핸들링
        selectFavoriteCelebView.onIdolSelected = { [weak self] selectedId in
            self?.addSelectedIdol(selectedId)
        }

        // 아이돌 태그 삭제 이벤트 핸들링
        selectFavoriteCelebView.onIdolRemoved = { [weak self] removedId in
            self?.removeSelectedIdol(removedId)
        }
    }
    
    //FIXME: - 더미 데이터 불러오기
    private func loadDummyData() {
        let dummyData = IdolList.dummy1()
        self.idolCategories = dummyData.map { ($0.idolId, $0.idolName) }
        self.selectFavoriteCelebView.updateDropdown(with: self.idolCategories)
    }

//    // API에서 아이돌 카테고리 가져오기
//    private func fetchIdolCategories() {
//    }

    // 입력한 텍스트에 따라 필터링
    private func filterIdols(with query: String) {
        let filtered = idolCategories.filter { $0.name.lowercased().contains(query.lowercased()) }
        selectFavoriteCelebView.updateDropdown(with: filtered)
    }

    // 아이돌 선택 시 추가
    private func addSelectedIdol(_ selectedId: Int) {
        guard let idol = idolCategories.first(where: { $0.id == selectedId }) else { return }
        print("🟢 태그 추가 - ID: \(idol.id), 이름 : \(idol.name)")
        selectFavoriteCelebView.addTag(idol)
    }

    // 아이돌 태그 삭제 시 목록에서도 제거
    private func removeSelectedIdol(_ removedId: Int) {
        selectFavoriteCelebView.removeTag(removedId)
    }
    
    
}
