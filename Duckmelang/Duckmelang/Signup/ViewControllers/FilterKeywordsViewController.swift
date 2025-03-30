////
////  FilterKeywordsViewController.swift
////  Duckmelang
////
////  Created by 김연우 on 2/17/25.
////
//
//
//import UIKit
//
//class FilterKeywordsViewController: UIViewController, NextStepHandler, NextButtonUpdatable, MoyaErrorHandlerDelegate {
//    let networkService = SignupService()
//    
//    private let memberId: Int
//    
//    init(memberId: Int) {
//        self.memberId = memberId
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func handleNextStep(completion: @escaping () -> Void) {
//        postKeywords(completion: completion)
//    }
//    
//    weak var nextButtonDelegate: NextButtonUpdatable?
//    
//    func updateNextButtonState(isEnabled: Bool) {
//        nextButtonDelegate?.updateNextButtonState(isEnabled: isEnabled)
//    }
//    
//    func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "확인", style: .default))
//        present(alert, animated: true)
//    }
//    
//
//    private let filterKeywordsView = FilterKeywordsView()
//    
//    private var keywords: [String] = [] {
//        didSet {
//            print("📌 현재 키워드 목록: \(keywords) (총 \(keywords.count)개)")
//            self.nextButtonDelegate?.updateNextButtonState(isEnabled: !keywords.isEmpty)
//        }
//    }
//    
//    private func postKeywords(completion: @escaping () -> Void) {
//        Task {
//            do {
//                startLoading()
//                
//                let request = SetLandmineKeywordRequest(landmineContents: keywords)
//                let result = try await networkService.postLandMines(memberId: memberId, landmineString: request)
//                
//                stopLoading()
//            }
//            catch {
//                stopLoading()
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        
//        filterKeywordsView.onKeywordsUpdated = { [weak self] updatedKeywords in
//            self?.keywords = updatedKeywords
//        }
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        view.addSubview(filterKeywordsView)
//        
//        filterKeywordsView.snp.makeConstraints {
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//}
//
//extension FilterKeywordsViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return false }
//        filterKeywordsView.addKeyword(text)
//        textField.text = ""
//        return true
//    }
//}
//
//extension FilterKeywordsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return keywords.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.identifier, for: indexPath) as? KeywordCell else {
//            return UICollectionViewCell()
//        }
//        let keyword = keywords[indexPath.row]
//        cell.configure(with: keyword)
//        cell.deleteAction = { [weak self] in
//            self?.keywords.remove(at: indexPath.row)
//        }
//        return cell
//    }
//}
