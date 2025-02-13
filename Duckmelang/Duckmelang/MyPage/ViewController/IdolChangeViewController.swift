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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = idolChangeView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        
        fetchIdolList()  // 아이돌 목록 조회
    }
    
    private lazy var idolChangeView = IdolChangeView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
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
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdolAddCell.identifier, for: indexPath)
            return cell
        }
    }
}
    
extension IdolChangeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 마지막 셀인지 확인
        if indexPath.item == idolList.count {
            // 다른 화면으로 전환
            let idolAddVC = UINavigationController(rootViewController: IdolAddViewController())
            idolAddVC.modalPresentationStyle = .fullScreen
            present(idolAddVC, animated: false)
        }
    }
}

