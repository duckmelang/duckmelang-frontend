//
//  PostRecommendedFilterViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class XKeywordChangeViewController: UIViewController {

    private let provider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var filters: [LandmineModel] = []  // LandmineModel(id, content)
    private var deleteQueue: Set<Int> = []  // 삭제 대기 목록(landmineId를 저장)

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
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc private func addFilter() {
        guard let filterText = xKeywordChangeView.searchBar.text, !filterText.isEmpty else { return }
        
        provider.request(.postLandmines(content: filterText)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<LandmineModel>.self)
                    guard let newFilter = decodedResponse.result else { return }
                    
                    self.filters.append(newFilter)  // content만 추가
                    DispatchQueue.main.async {
                        let newIndexPath = IndexPath(item: self.filters.count - 1, section: 0)
                        self.xKeywordChangeView.xKeywordCollectionView.insertItems(at: [newIndexPath])
                        self.xKeywordChangeView.searchBar.text = ""
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 필터 추가 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let landmineId = filters[index].id
        
        if deleteQueue.contains(landmineId) {
            return // 이미 삭제 대기 목록에 있는 경우 아무 작업도 하지 않음
        }
        
        deleteQueue.insert(landmineId)  // 삭제 대기 목록에 추가
        filters.remove(at: index)  // UI에서 임시 삭제
        
        DispatchQueue.main.async {
            self.xKeywordChangeView.xKeywordCollectionView.performBatchUpdates {
                self.xKeywordChangeView.xKeywordCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    @objc private func finishBtnTapped() {
        let dispatchGroup = DispatchGroup() // 모든 삭제 작업 후 fetchLandmines 호출하기 위해..
        
        for landmineId in deleteQueue {
            dispatchGroup.enter() // 삭제 작업 시작
            provider.request(.deleteLandmines(landmineId: landmineId)) { result in
                switch result {
                case .success:
                    print("✅ \(landmineId) 삭제 성공")
                case .failure(let error):
                    print("❌ 삭제 실패: \(error.localizedDescription)")
                }
                dispatchGroup.leave() // 삭제 작업 종료
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.deleteQueue.removeAll()
                self.fetchLandmines()
            }
        }
    }
    
    private func setupDelegate() {
        xKeywordChangeView.xKeywordCollectionView.dataSource = self
        xKeywordChangeView.xKeywordCollectionView.delegate = self
    }
    
    private func fetchLandmines() {
        provider.request(.getLandmines) { result in
            switch result {
            case .success(let response):
                do {
                    // 응답 디코딩: String 배열을 LandmineModel로 변환
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("📝 GET 응답: \(responseString)")
                    }

                    let decodedResponse = try response.map(ApiResponse<LandmineResponse>.self)  // String 배열로 디코딩
                    let landmineStrings = decodedResponse.result?.landmineList ?? []

                    // String 배열을 LandmineModel 배열로 변환 (id는 임시 UUID 사용)
                    self.filters = landmineStrings.enumerated().map { index, content in
                        LandmineModel(id: index, content: content)
                    }

                    DispatchQueue.main.async {
                        self.xKeywordChangeView.xKeywordCollectionView.reloadData()
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 필터 목록 가져오기 실패: \(error.localizedDescription)")
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
