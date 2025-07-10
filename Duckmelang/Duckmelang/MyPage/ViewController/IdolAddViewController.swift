//
//  IdolAddViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya
import SwiftyToaster

class IdolAddViewController: UIViewController {
    
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
        self.navigationController?.popViewController(animated: true)
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
                Toaster.shared.makeToast("아이돌을 불러오지 못했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    @objc private func finishBtnTapped() {
        let group = DispatchGroup()
        var oneSuccess = false // 하나라도 post하면 pop되도록
        var duplicatedIdol = false
        var failCount = 0
        
        // 선택된 아이돌 ID를 서버에 추가하는 API 호출
        for idolId in selectedIdols {
            group.enter()
            
            _Concurrency.Task {
                defer { group.leave() }
                
                do {
                    _ = try await networkService.postIdol(idolId: idolId)
                    oneSuccess = true
                } catch {
                    print("🚨 다른 에러: \(error.localizedDescription)")
                    duplicatedIdol = error.localizedDescription.contains("선택")
                    failCount += 1
                }
            }
        }
        
        group.notify(queue: .main) {
            if oneSuccess { // 하나라도 성공하면 완료 메시지 띄우기 (중복된 아이돌 포함되어있을 수도 있음)
                Toaster.shared.makeToast("아이돌 추가가 완료되었습니다.")
                self.navigationController?.popViewController(animated: true)
                self.onCompletion?()
            } else if failCount > 0 {
                // 서버 오류 or 모두 중복된 아이돌일때
                // 중복된 아이돌이 없는데 에러가 난거면 서버 오류
                // 중복된 아이돌이 있다면 4003에러
                duplicatedIdol ? Toaster.shared.makeToast("중복된 아이돌 선택 해제 후 \n 다시 시도해주세요.") : Toaster.shared.makeToast("아이돌 추가를 완료하지 못했습니다. \n 잠시 후 다시 시도해주세요.")
            }
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
        } else {
            cell.idolName.textColor = .black
            cell.idolImage.layer.borderWidth = 0
            cell.idolImage.layer.borderColor = nil
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

extension IdolAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // ✅ "완료" 버튼 클릭 시 키보드 내리기
        return true
    }
}
