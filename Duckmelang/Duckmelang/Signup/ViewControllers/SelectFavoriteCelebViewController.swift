//
//  SelectFavoriteCelebViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 5/9/25.
//

import UIKit

class SelectFavoriteCelebViewController: UIViewController {
    let networkService = SignupService()
    
    private var selectableIdols: [Idol] = []
    var selectedIdols: [Idol] = [] {
        didSet {
            selectFavoriteCelebView.nextBtn.setEnabled(!selectedIdols.isEmpty)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = selectFavoriteCelebView
        setupDelegate()
        setupNavigationBar()
        getIdolsAPI()
    }
    
    private lazy var selectFavoriteCelebView: SelectFavoriteCelebView = {
        let view = SelectFavoriteCelebView()
        view.nextBtn.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
        view.searchButton.addTarget(self, action: #selector(searchIconTapped), for: .touchUpInside)
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = "회원가입"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(
            ofSize: 18
        )]
        
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(openBackPopup)
        )
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func openBackPopup() {
        let popupVC = ProfileCancelPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
    }
    
    private func setupDelegate() {
        selectFavoriteCelebView.collectionView.dataSource = self
        selectFavoriteCelebView.collectionView.delegate = self
        selectFavoriteCelebView.celebTextField.delegate = self
    }
    
    private func getIdolsAPI() {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getAllIdols()
                
                self.selectableIdols = result.idolList.map { idol in idol }
                DispatchQueue.main.async {
                    self.selectFavoriteCelebView.collectionView.reloadData()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func searchIconTapped() {
        guard let searchText = selectFavoriteCelebView.celebTextField.text else { return }
        
        if (searchText.isEmpty) {
            getIdolsAPI()
        } else {
            searchIdols(keyword: searchText)
        }
    }
    
    // 아이돌 검색 API
    private func searchIdols(keyword: String) {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getSearchIdol(keyword: keyword)
                
                self.selectableIdols = result.idolList.map { idol in idol }
                DispatchQueue.main.async {
                    self.selectFavoriteCelebView.collectionView.reloadData()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    // 다음 버튼 눌렀을 때
    @objc func nextBtn() {
        // MARK: TEST
//        navigateToSelectEventView()
        postInterestCelebAPI()
    }
    
    // post
    private func postInterestCelebAPI() {
        Task {
            do {
                guard let memberIdString = KeychainManager.shared.load(key: "memberId"),
                      let memberId = Int(memberIdString) else { return }
                
                startLoading()
                
                let idolNums = self.selectableIdols.map { idol in idol.idolId }
                let request = SelectFavoriteIdolRequest(idolCategoryIds: idolNums)
                _ = try await networkService.postMemberInterestCeleb(memberId: memberId, idolNums: request)
                
                DispatchQueue.main.async {
                    self.navigateToSelectEventView()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func navigateToSelectEventView() {
        let eventVC = SelectEventViewController()
        eventVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(eventVC, animated: true)
    }
}

extension SelectFavoriteCelebViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return false }
        
        if (searchText.isEmpty) {
            getIdolsAPI()
        } else {
            searchIdols(keyword: searchText)
        }
        
        return true
    }
}

extension SelectFavoriteCelebViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectableIdols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IdolCollectionViewCell", for: indexPath) as? IdolCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let idol = selectableIdols[indexPath.item]
        cell.configure(with: idol)
        
        if selectedIdols.contains(idol) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idol = selectableIdols[indexPath.item]
        
        if selectedIdols.contains(where: { $0 == idol }) {
            selectedIdols.removeAll(where: { $0 == idol })
        } else {
            selectedIdols.append(idol)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? IdolCollectionViewCell {
            cell.isSelected = selectedIdols.contains(idol)
        }
        print(selectedIdols)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let idol = selectableIdols[indexPath.item]
        
        if selectedIdols.contains(where: { $0 == idol }) {
            selectedIdols.removeAll(where: { $0 == idol })
        } else {
            selectedIdols.append(idol)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? IdolCollectionViewCell {
            cell.isSelected = selectedIdols.contains(idol)
        }
        print(selectedIdols)
    }
}
