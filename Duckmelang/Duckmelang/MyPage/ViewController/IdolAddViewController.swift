//
//  IdolAddViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class IdolAddViewController: UIViewController {
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    private var searchResults: [IdolListDTO] = []  // 검색 결과
    private var selectedIdols: Set<Int> = []  // 선택된 아이돌의 ID
    
    var onCompletion: (() -> Void)? // 완료 시 실행할 클로저 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = idolAddView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
    }
    
    private lazy var idolAddView = IdolAddView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.searchIcon.addTarget(self, action: #selector(searchIconTapped), for: .touchUpInside)
        $0.finishBtn.addTarget(self, action: #selector(finishBtnTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        idolAddView.idolAddCollectionView.dataSource = self
        idolAddView.idolAddCollectionView.delegate = self
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc
    private func searchIconTapped() {
        guard let searchText = idolAddView.searchBar.text, !searchText.isEmpty else { return }
        searchIdols(keyword: searchText)
    }
        
    private func searchIdols(keyword: String) {
        provider.request(.getSearchIdol(keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<idolListResponse>.self)
                    self.searchResults = decodedResponse.result?.idolList ?? []
                    DispatchQueue.main.async {
                        self.idolAddView.idolAddCollectionView.reloadData()
                        print("컬렉션뷰크기: \(self.idolAddView.idolAddCollectionView.frame)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 아이돌 검색 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func finishBtnTapped() {
        // 선택된 아이돌 ID를 서버에 추가하는 API 호출
        for idolId in selectedIdols {
            provider.request(.postIdol(idolId: idolId)) { result in
                switch result {
                case .success:
                    print("✅ 아이돌 추가 성공: \(idolId)")
                case .failure(let error):
                    print("❌ 아이돌 추가 실패: \(error.localizedDescription)")
                }
            }
        }
        
        self.presentingViewController?.dismiss(animated: true) {
            self.onCompletion?()
        }
    }
}

extension IdolAddViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdolAddCell.identifier, for: indexPath) as? IdolAddCell else {
            return UICollectionViewCell()
        }
        
        let idol = searchResults[indexPath.item]
        cell.configure(model: idol)
        
        // 선택된 아이돌
        if selectedIdols.contains(idol.idolId) {
            cell.idolName.textColor = .dmrBlue
            cell.idolImage.layer.borderWidth = 1
            cell.idolImage.layer.borderColor = UIColor.dmrBlue?.cgColor
        }
        
        return cell
    }
}

extension IdolAddViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idolId = searchResults[indexPath.item].idolId
        
        // 선택 상태 토글 (중복 선택 가능)
        if selectedIdols.contains(idolId) {
            selectedIdols.remove(idolId)
        } else {
            selectedIdols.insert(idolId)
        }
        
        // ✅ 개별 아이템 새로고침 (오류 방지)
        DispatchQueue.main.async {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
