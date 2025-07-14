//
//  IdolChangeViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya
import SwiftyToaster

class IdolChangeViewController: UIViewController {
    
    let data = IdolChangeModel.dummy()
    
    let networkService = MyPageService()
    
    private var idolList: [IdolListDTO] = []  // 서버에서 가져온 관심 아이돌 목록
    private var deleteQueue: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = idolChangeView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        
        fetchIdolList()  // 아이돌 목록 조회
        
        NotificationCenter.default.addObserver(self, selector: #selector(idolListUpdated), name: NSNotification.Name("idolListUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("idolListUpdated"), object: nil)
    }
    
    @objc
    private func idolListUpdated() {
        fetchIdolList()
    }
    
    private lazy var idolChangeView = IdolChangeView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.finishBtn.addTarget(self, action: #selector(finishBtnTapped), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteBtnTapped(_ sender: UIButton) {
        let index = sender.tag
        let idolId = idolList[index].idolId
        
        guard index < idolList.count else { return }  // 안전한 인덱스 확인

        // 삭제 대기 목록에 추가
        if !deleteQueue.contains(idolId) {
            deleteQueue.insert(idolId)

            // 컬렉션 뷰 업데이트를 위해 삭제 전 인덱스 저장
            let indexPath = IndexPath(item: index, section: 0)
            
            // 데이터 먼저 삭제
            idolList.remove(at: index)
            
            // 부드러운 삭제 애니메이션 적용
            idolChangeView.idolChangeCollectionView.performBatchUpdates {
                idolChangeView.idolChangeCollectionView.deleteItems(at: [indexPath])
            } completion: { _ in
                self.idolChangeView.idolChangeCollectionView.reloadItems(at: self.idolChangeView.idolChangeCollectionView.indexPathsForVisibleItems)  // 남은 셀들 정렬
            }
        }
    }
    
    @objc private func finishBtnTapped() {
        let group = DispatchGroup()
        
        for idolId in deleteQueue {
            group.enter()
            _Concurrency.Task {
                do {
                    startLoading()
                    
                    try await networkService.deleteIdol(idolId: idolId)
                    
                    Toaster.shared.makeToast("아이돌 변경이 완료되었습니다.") // 완료버튼 눌렀을때 아이돌을 삭제했으면..
                    stopLoading()
                } catch {
                    stopLoading()
                    print(error.localizedDescription)
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.deleteQueue.removeAll()  // 삭제 대기 목록 초기화
            self.fetchIdolList() // 최신 아이돌 목록 다시 가져옴
            self.navigationController?.popViewController(animated: true)
        }
    }
 
    private func setupDelegate() {
        idolChangeView.idolChangeCollectionView.dataSource = self
        idolChangeView.idolChangeCollectionView.delegate = self
    }
    
    private func fetchIdolList() {
        _Concurrency.Task {
            do {
                startLoading()
                
                let response = try await networkService.getIdolList().idolList
                self.idolList = response
                DispatchQueue.main.async {
                    self.idolChangeView.idolChangeCollectionView.reloadData()
                }
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    // 삭제 대기 상태인 셀을 시각적으로 표시하기 위한 함수
    private func updateCellAppearance(_ cell: IdolChangeCell, isInDeleteQueue: Bool) {
        cell.contentView.backgroundColor = isInDeleteQueue ? .lightGray : .white
        cell.deleteBtn.isHidden = !isInDeleteQueue  // 아이콘 표시 여부
    }
}

extension IdolChangeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return idolList.isEmpty ? 1 : idolList.count + 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if idolList.isEmpty || indexPath.item == idolList.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdolAddBtnCell.identifier, for: indexPath)
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdolChangeCell.identifier,
                                                                for: indexPath) as? IdolChangeCell else {
                return UICollectionViewCell()//행 식별위해 파라미터로 받음
            }
            
            let idol = idolList[indexPath.item]
            cell.configure(model: idol, isLastCell: false)
            
            // 삭제 대기 상태인지 확인하여 삭제 버튼 시각적 처리
            //cell.deleteBtn.isHidden = !deleteQueue.contains(idol.idolId)
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: .touchUpInside)
        
            return cell
        }
    }
}
    
extension IdolChangeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 마지막 셀인지 확인
        if indexPath.item == idolList.count {
            // 다른 화면으로 전환
            let idolAddVC = IdolAddViewController()
            idolAddVC.onCompletion = { [weak self] in
                self?.fetchIdolList()
            }
            self.navigationController?.pushViewController(idolAddVC, animated: true)
        }
    }
}

