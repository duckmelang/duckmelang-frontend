//
//  PostRecommendedFilterViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya
import SwiftyToaster

enum ActionType {
    case add, delete, none
}

class XKeywordChangeViewController: UIViewController {
    
    let networkService = MyPageService()
    
    private var filters: [LandmineModel] = []  // 서버에서 가져온 키워드 리스트
    private var pendingAddQueue: Set<String> = []  // 새로 추가할 키워드 큐
    private var pendingDeleteQueue: Set<Int> = []  // 삭제할 키워드 ID 큐
    
    private var lastAction: [String: ActionType] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = xKeywordChangeView
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        fetchLandmines()
    }
    
    private lazy var xKeywordChangeView = XKeywordChangeView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.searchIcon.addTarget(self, action: #selector(addFilter), for: .touchUpInside)
        $0.finishBtn.addTarget(self, action: #selector(finishBtnTapped), for: .touchUpInside)
    }
    
    @objc private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Add Filter
    @objc private func addFilter() {
        guard let filterText = xKeywordChangeView.searchBar.text, !filterText.isEmpty else { return }
        
        // 중복 방지
        if filters.contains(where: { $0.content == filterText }) || pendingAddQueue.contains(filterText) {
            print("⚠️ 중복된 키워드입니다.")
            Toaster.shared.makeToast("중복된 키워드입니다.")
            return
        }
        
        pendingAddQueue.insert(filterText)  // Add 대기 큐에 추가
        filters.append(LandmineModel(landmineId: -1, content: filterText))  // 임시로 id는 -1로 설정
        lastAction[filterText] = .add
        
        DispatchQueue.main.async {
            let newIndexPath = IndexPath(item: self.filters.count - 1, section: 0)
            self.xKeywordChangeView.xKeywordCollectionView.insertItems(at: [newIndexPath])
            self.xKeywordChangeView.searchBar.text = ""
        }
    }
    
    // MARK: - Delete Filter
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let point = sender.convert(sender.bounds.origin, to: xKeywordChangeView.xKeywordCollectionView)
        guard let indexPath = xKeywordChangeView.xKeywordCollectionView.indexPathForItem(at: point) else {
            print("⚠️ 셀의 indexPath를 가져오지 못했습니다.")
            return
        }
        
        let index = indexPath.item
        let landmine = filters[index]
        
        if pendingAddQueue.contains(landmine.content) {
            pendingAddQueue.remove(landmine.content)
            lastAction[landmine.content] = ActionType.none
        } else {
            pendingDeleteQueue.insert(landmine.landmineId)
            lastAction[landmine.content] = .delete
            
        }
        if landmine.landmineId != -1 {
            pendingDeleteQueue.insert(landmine.landmineId)  // 삭제할 ID를 큐에 추가
        }
        
        filters.remove(at: index)  // filters에서 임시 삭제
        DispatchQueue.main.async {
            self.xKeywordChangeView.xKeywordCollectionView.deleteItems(at: [indexPath])
        }
    }
    
    // MARK: - Finish Action
    @objc private func finishBtnTapped() {
        
        // 변경된 키워드가 없을 경우
        if pendingAddQueue.isEmpty && pendingDeleteQueue.isEmpty {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        var isSuccess = false
        
        // **Step 1: 실제 추가할 키워드 계산 (삭제되지 않은 추가 키워드)**
        let finalAddQueue = pendingAddQueue.filter { lastAction[$0] != .delete }
        
        // **Step 2: 삭제 요청**
        for landmineId in pendingDeleteQueue {
            dispatchGroup.enter()
            
            _Concurrency.Task {
                do {
                    startLoading()
                    
                    let _: () = try await networkService.deleteLandmines(landmineId: landmineId)
                    
                    isSuccess = true
                    print("\(landmineId) 삭제 성공")
                } catch {
                    print(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            }
        }
        
        // **Step 3: 추가 요청**
        for content in finalAddQueue {
            dispatchGroup.enter()
            
            _Concurrency.Task {
                do {
                    startLoading()
                    
                    let response = try await networkService.postLandmines(content: content)
                    
                    isSuccess = true
                    print("\(content) 추가 성공")
                    
                    stopLoading()
                } catch {
                    print(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            }
        }
        
        
        
        // **Step 4: 모든 요청이 끝난 후 초기화 및 새로고침**
        dispatchGroup.notify(queue: .main) {
            self.pendingAddQueue.removeAll()
            self.pendingDeleteQueue.removeAll()
            self.lastAction.removeAll()
            
            if isSuccess {
                Toaster.shared.makeToast("키워드 변경이 완료되었습니다.")
                self.navigationController?.popViewController(animated: true)
            } else {
                Toaster.shared.makeToast("변경된 키워드를 적용하지 못했습니다. \n 잠시 후 다시 시도해주세요.")
            }
            
            self.fetchLandmines()
        }
    }
    
    private func setupDelegate() {
        xKeywordChangeView.xKeywordCollectionView.dataSource = self
        xKeywordChangeView.xKeywordCollectionView.delegate = self
    }
    
    private func fetchLandmines() {
        _Concurrency.Task {
            do {
                startLoading()
                
                let reponse = try await networkService.getLandmines()
                self.filters = reponse.landmineList
                
                DispatchQueue.main.async {
                    self.xKeywordChangeView.xKeywordCollectionView.reloadData()
                }
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
}

extension XKeywordChangeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XKeywordChangeCell.identifier, for: indexPath) as? XKeywordChangeCell else {
            return UICollectionViewCell()
        }
        
        let filter = filters[indexPath.item]
        cell.configure(filterText: filter.content)
        cell.deleteBtn.tag = indexPath.item
        cell.deleteBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
}

extension XKeywordChangeViewController: UICollectionViewDelegate { }

extension XKeywordChangeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // ✅ "완료" 버튼 클릭 시 키보드 내리기
        return true
    }
}
