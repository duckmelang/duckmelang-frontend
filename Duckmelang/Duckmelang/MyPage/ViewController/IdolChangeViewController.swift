//
//  IdolChangeViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class IdolChangeViewController: UIViewController {
    
    let data = IdolChangeModel.dummy()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = idolChangeView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
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
}

extension IdolChangeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return IdolChangeModel.dummy().count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdolChangeCell.identifier,
            for: indexPath //행 식별위해 파라미터로 받음
        ) as? IdolChangeCell else {
                return UICollectionViewCell()
        }
        
        let isLastCell = (indexPath.item == data.count - 1)
        cell.configure(model: data[indexPath.row], isLastCell: isLastCell)
         
        return cell
    }
}

extension IdolChangeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 마지막 셀인지 확인
        if indexPath.item == data.count - 1 {
            // 다른 화면으로 전환
            let idolAddVC = UINavigationController(rootViewController: IdolAddViewController())
            idolAddVC.modalPresentationStyle = .fullScreen
            present(idolAddVC, animated: false)
        }
    }
}
