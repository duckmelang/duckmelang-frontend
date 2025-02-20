//
//  FilterKeywordsViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//


import UIKit
import Moya
import Alamofire

class FilterKeywordsViewController: UIViewController, NextStepHandler, NextButtonUpdatable, MoyaErrorHandlerDelegate {
    
    lazy var provider: MoyaProvider<LoginAPI> = {
        return MoyaProvider<LoginAPI>(plugins: [TokenPlugin(),MoyaLoggerPlugin()])
    }()
    
    private let memberId: Int
    
    init(memberId: Int) {
        self.memberId = memberId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleNextStep(completion: @escaping () -> Void) {
        postKeywords(completion: completion)
    }
    
    weak var nextButtonDelegate: NextButtonUpdatable?
    
    func updateNextButtonState(isEnabled: Bool) {
        nextButtonDelegate?.updateNextButtonState(isEnabled: isEnabled)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    

    private let filterKeywordsView = FilterKeywordsView()
    
    private var keywords: [String] = [] {
        didSet {
            print("📌 현재 키워드 목록: \(keywords) (총 \(keywords.count)개)")
            self.nextButtonDelegate?.updateNextButtonState(isEnabled: !keywords.isEmpty)
        }
    }
    
    private func postKeywords(completion: @escaping () -> Void) {
        let request = SetLandmineKeywordRequest(landmineContents: keywords)
        
        provider.request(.postLandMines(memberId: memberId, landmineString: request)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    // JSON 디코딩
                    let decoder = JSONDecoder()
                    let landmineResponse = try decoder.decode(LandmineResponse.self, from: response.data)
                    
                    // 응답 성공 여부 확인
                    if landmineResponse.isSuccess {
                        print("✅ Keywords posted successfully: \(landmineResponse.result.landmineContents)")
                        completion()
                    } else {
                        self.showAlert(title: "오류", message: landmineResponse.message)
                    }
                    
                } catch {
                    self.showAlert(title: "오류", message: "응답 처리 중 오류가 발생했습니다.")
                    print("❌ JSON 디코딩 오류 또는 상태 코드 오류: \(error)")
                }
                
            case .failure(let error):
                self.showAlert(title: "네트워크 오류", message: "키워드 전송에 실패했습니다.")
                print("❌ API 요청 실패: \(error.localizedDescription)")
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        filterKeywordsView.onKeywordsUpdated = { [weak self] updatedKeywords in
            self?.keywords = updatedKeywords
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(filterKeywordsView)
        
        filterKeywordsView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FilterKeywordsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return false }
        filterKeywordsView.addKeyword(text)
        textField.text = ""
        return true
    }
}

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
        cell.deleteAction = { [weak self] in
            self?.keywords.remove(at: indexPath.row)
        }
        return cell
    }
}
