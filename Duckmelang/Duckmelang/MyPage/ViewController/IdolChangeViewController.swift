//
//  IdolChangeViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class IdolChangeViewController: UIViewController {
    
    let data = IdolChangeModel.dummy()
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
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
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc private func deleteBtnTapped(_ sender: UIButton) {
        let index = sender.tag
        let idolId = idolList[index].idolId
        
        // 삭제 대기 목록에 추가하고 목록에서 임시 삭제
        if !deleteQueue.contains(idolId) {
            deleteQueue.insert(idolId)
            idolList.remove(at: index)  // 목록에서 임시 제거
            idolChangeView.idolChangeCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    @objc private func finishBtnTapped() {
        for idolId in deleteQueue {
            provider.request(.deleteIdol(idolId: idolId)) { result in
                switch result {
                case .success:
                    print("✅ 아이돌 삭제 성공: \(idolId)")
                    self.idolChangeView.idolChangeCollectionView.reloadData()
                case .failure(let error):
                    print("❌ 아이돌 삭제 실패: \(error.localizedDescription)")
                }
            }
        }
        
        // 완료 후 목록을 다시 가져와 새로고침
        fetchIdolList()
        deleteQueue.removeAll()  // 삭제 대기 목록 초기화
    }
 
    private func setupDelegate() {
        idolChangeView.idolChangeCollectionView.dataSource = self
        idolChangeView.idolChangeCollectionView.delegate = self
    }
    
    private func fetchIdolList() {
        provider.request(.getIdolList) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<idolListResponse>.self)
                    guard let list = decodedResponse.result?.idolList else { return }
                    print("✅ 관심 아이돌 조회 성공: \(list)")
                    self.idolList = list
                    DispatchQueue.main.async {
                        self.idolChangeView.idolChangeCollectionView.reloadData()
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 관심 아이돌 목록 조회 실패: \(error.localizedDescription)")
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return idolList.count + 1}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < idolList.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdolChangeCell.identifier,
                                                                for: indexPath) as? IdolChangeCell else {
                return UICollectionViewCell()//행 식별위해 파라미터로 받음
            }
            
            let idol = idolList[indexPath.row]
            let isLastCell = (indexPath.item == idolList.count - 1)
            cell.configure(model: idol, isLastCell: isLastCell)
            
            // 삭제 대기 상태인지 확인하여 삭제 버튼 시각적 처리
            //cell.deleteBtn.isHidden = !deleteQueue.contains(idol.idolId)
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: .touchUpInside)

            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdolAddBtnCell.identifier, for: indexPath)
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
            let navigationController = UINavigationController(rootViewController: idolAddVC)
            navigationController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: false)
        }
    }
}

