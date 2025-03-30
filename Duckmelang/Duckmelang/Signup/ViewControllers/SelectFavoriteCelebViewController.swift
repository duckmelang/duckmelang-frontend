////
////  SelectFavoriteCelebViewController.swift
////  Duckmelang
////
////  Created by 김연우 on 2/17/25.
////
//
//
//import UIKit
//
//class SelectFavoriteCelebViewController: UIViewController, NextButtonUpdatable, NextStepHandler {
//    let networkService = SignupService()
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
//    private let selectFavoriteCelebView = SelectFavoriteCelebView()
//
//    // ✅ ViewModel 배열
//    private var selectableIdols: [SelectableIdol] = []
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
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupHandlers()
//        getIdolsAPI()
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        view.addSubview(selectFavoriteCelebView)
//        
//        selectFavoriteCelebView.snp.makeConstraints {
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//    
//    private func setupHandlers() {
//        textInputUpdate()
//        isSelectedUpdate()
//    }
//    
//    private func textInputUpdate(){
//        selectFavoriteCelebView.onTextInput = { [weak self] query in
//            guard let self = self else { return }
//            
//            if query.isEmpty {
//                // ✅ 검색어가 비어있을 때는 전체 목록 보여주기
//                self.selectFavoriteCelebView.updateCollectionView(with: self.selectableIdols)
//            } else {
//                // ✅ 검색어가 있을 때만 필터링 실행
//                self.filterIdols(with: query)
//            }
//        }
//    }
//    
//    private func isSelectedUpdate() {
//        selectFavoriteCelebView.isSelected = { [weak self] idolId, isSelected in
//            guard let self = self else { return }
//            if let index = self.selectableIdols.firstIndex(where: { $0.idol.idolId == idolId }) {
//                self.selectableIdols[index].isSelected = isSelected
//                print("✅ 선택 상태 변경: \(self.selectableIdols[index])")
//                selectFavoriteCelebView.resetTextField()
//            }
//            self.nextButtonDelegate?.updateNextButtonState(isEnabled: !self.selectableIdols.filter { $0.isSelected }.isEmpty)
//        }
//    }
//    
//    private func getIdolsAPI() {
//        Task {
//            do {
//                startLoading()
//                
//                let result = try await networkService.getAllIdols()
//                self.selectableIdols = result.idolList.map { idol in
//                    SelectableIdol(idol: idol, isSelected: false)
//                }
//                DispatchQueue.main.async {
//                    self.selectFavoriteCelebView.updateCollectionView(with: self.selectableIdols)
//                }
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
//    private func filterIdols(with query: String) {
//        let filtered = selectableIdols.filter { idol in
//            idol.idol.idolName.lowercased().contains(query.lowercased())
//        }
//        selectFavoriteCelebView.updateCollectionView(with: filtered)
//    }
//
//    private func sendSelectedIdolsRequest() {
//        let selectedIds = selectableIdols
//            .filter { $0.isSelected }
//            .map { $0.idol.idolId }
//
//        if selectedIds.isEmpty {
//            showAlert(title: "선택 오류", message: "최소 한 개 이상의 아이돌을 선택해주세요.")
//            return
//        }
//
//        
//        provider.request(.postMemberInterestCeleb(memberId: memberId, idolNums: request)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    if let successData = try? response.mapJSON() {
//                        print("✅ 성공: \(successData)")
//                        completion()
//                    } else {
//                        self.showAlert(title: "오류", message: "응답 데이터를 처리할 수 없습니다.")
//                    }
//                } catch {
//                    self.showAlert(title: "오류", message: "JSON 변환 실패: \(error.localizedDescription)")
//                }
//
//            case .failure(let error):
//                self.showAlert(title: "네트워크 오류", message: "아이돌 선택 저장에 실패했습니다.")
//            }
//        }
//    }
//    
//    private func postInterestCelebAPI() {
//        Task {
//            do {
//                startLoading()
//                
//                let request = SelectFavoriteIdolRequest(idolCategoryIds: selectedIds)
//                let result = try await networkService.postMemberInterestCeleb(memberId: memberId, idolNums: request)
//                self.selectableIdols = result.idolList.map { idol in
//                    SelectableIdol(idol: idol, isSelected: false)
//                }
//                DispatchQueue.main.async {
//                    self.selectFavoriteCelebView.updateCollectionView(with: self.selectableIdols)
//                }
//                
//                stopLoading()
//            }
//            catch {
//                stopLoading()
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
