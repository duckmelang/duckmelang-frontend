//
//  FilterKeywordsViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 5/21/25.
//

import UIKit

class FilterKeywordsViewController: UIViewController {
    let networkService = SignupService()
    
    var memberId: Int?
    
    private var keywords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = filterKeywordsView
        setupNavigationBar()
        setupDelegates()
    }
    
    private lazy var filterKeywordsView: FilterKeywordsView = {
        let view = FilterKeywordsView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPlusIconTapped))
        view.plusIcon.addGestureRecognizer(tapGesture)
        
        view.nextBtn.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
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
            action: #selector(goBack)
        )
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupDelegates() {
        filterKeywordsView.keywordsCollectionView.delegate = self
        filterKeywordsView.keywordsCollectionView.dataSource = self
        filterKeywordsView.filterKeywordTextField.delegate = self
    }
    
    @objc func onPlusIconTapped() {
        guard let text = filterKeywordsView.filterKeywordTextField.text?.trimmingCharacters(in: .alphanumerics), !text.isEmpty else { return }
        self.keywords.append(text)
        filterKeywordsView.filterKeywordTextField.text = ""
        
        DispatchQueue.main.async {
            self.filterKeywordsView.keywordsCollectionView.reloadData()
        }
    }

    private func postKeywords() {
        guard let memberId = self.memberId else { return }
        
        Task {
            do {
                startLoading()
                
                let request = SetLandmineKeywordRequest(landmineContents: keywords)
                _ = try await networkService.postLandMines(memberId: memberId, landmineString: request)
                DispatchQueue.main.async {
                    self.navigateToHomeView()
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
//        navigateToHomeView()
        postKeywords()
    }
    
    private func navigateToHomeView() {
        let splashVC = SignUpCompleteViewController()
        splashVC.modalPresentationStyle = .fullScreen
        splashVC.modalTransitionStyle = .crossDissolve
        self.present(splashVC, animated: true)
    }
}

extension FilterKeywordsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return false }
        self.keywords.append(text)
        textField.text = ""
        
        DispatchQueue.main.async {
            self.filterKeywordsView.keywordsCollectionView.reloadData()
        }
        
        return true
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension FilterKeywordsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.identifier, for: indexPath) as? KeywordCell else {
            return UICollectionViewCell()
        }
        let keyword = keywords[indexPath.row]
        cell.configure(with: keyword)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        keywords.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}
