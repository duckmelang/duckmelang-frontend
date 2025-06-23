//
//  HomeIdolAddView.swift
//  Duckmelang
//
//  Created by nau on 6/23/25.
//
import UIKit
import Then
import SnapKit
import Moya

class HomeIdolAddViewController: UIViewController {
    
    let networkService = MyPageService()
    
    private var searchResults: [IdolListDTO] = []  // 검색 결과
    private var selectedIdols: Set<Int> = []  // 선택된 아이돌의 ID
    
    var onCompletion: (() -> Void)? // 완료 시 실행할 클로저 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = idolAddView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
    }
    
    private lazy var idolAddView = HomeIdolAddView().then {
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
        _Concurrency.Task {
            do {
                startLoading()
                
                let response = try await networkService.getSearchIdol(keyword: keyword).idolList
                
                await MainActor.run {
                    self.searchResults = response
                    self.idolAddView.idolAddCollectionView.reloadData()
                    print("컬렉션뷰크기: \(self.idolAddView.idolAddCollectionView.frame)")
                    stopLoading()
                }
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func finishBtnTapped() {
        let group = DispatchGroup()
        
        // 선택된 아이돌 ID를 서버에 추가하는 API 호출
        for idolId in selectedIdols {
            group.enter()
            _Concurrency.Task {
                do {
                    try await networkService.postIdol(idolId: idolId)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dismiss(animated: true)
            self.onCompletion?()
        }
        /*
        self.presentingViewController?.dismiss(animated: true) {
            self.onCompletion?()
        }*/
    }
}

extension HomeIdolAddViewController: UICollectionViewDataSource {
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
        } else {
            cell.idolName.textColor = .black
            cell.idolImage.layer.borderWidth = 0
            cell.idolImage.layer.borderColor = nil
        }
        
        return cell
    }
}

extension HomeIdolAddViewController: UICollectionViewDelegate {
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

extension HomeIdolAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // ✅ "완료" 버튼 클릭 시 키보드 내리기
        return true
    }
}
