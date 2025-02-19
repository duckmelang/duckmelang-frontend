//
//  SelectFavoriteCelebViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//


import UIKit
import Alamofire
import Moya

class SelectFavoriteCelebViewController: UIViewController, NextButtonUpdatable, MoyaErrorHandlerDelegate {
    
    weak var nextButtonDelegate: NextButtonUpdatable?
    
    func updateNextButtonState(isEnabled: Bool) {
        nextButtonDelegate?.updateNextButtonState(isEnabled: isEnabled)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private lazy var provider = MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])

    private let selectFavoriteCelebView = SelectFavoriteCelebView()

    // ✅ ViewModel 배열
    private var selectableIdols: [SelectableIdol] = []
    private let memberId: Int

    init(memberId: Int) {
        self.memberId = memberId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHandlers()
        fetchIdolCategories()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(selectFavoriteCelebView)
        
        selectFavoriteCelebView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupHandlers() {
        selectFavoriteCelebView.onTextInput = { [weak self] query in
            guard let self = self else { return }
            
            if query.isEmpty {
                // ✅ 검색어가 비어있을 때는 전체 목록 보여주기
                self.selectFavoriteCelebView.updateCollectionView(with: self.selectableIdols)
            } else {
                // ✅ 검색어가 있을 때만 필터링 실행
                self.filterIdols(with: query)
            }
        }
        
        selectFavoriteCelebView.isSelected = { [weak self] idolId, isSelected in
            guard let self = self else { return }
            if let index = self.selectableIdols.firstIndex(where: { $0.idol.idolId == idolId }) {
                self.selectableIdols[index].isSelected = isSelected
                print("✅ 선택 상태 변경: \(self.selectableIdols[index])")
            }
            self.nextButtonDelegate?.updateNextButtonState(isEnabled: !self.selectableIdols.filter { $0.isSelected }.isEmpty)
        }
    }
    
    private func fetchIdolCategories() {
        provider.request(.getAllIdols) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let idolListResponse = try response.map(IdolListResponse.self)
                    
                    // ✅ Idol -> SelectableIdol 변환하면서 초기 선택 상태 설정
                    self.selectableIdols = idolListResponse.result.idolList.map { idol in
                        SelectableIdol(idol: idol, isSelected: false)
                    }
                    
                    DispatchQueue.main.async {
                        self.selectFavoriteCelebView.updateCollectionView(with: self.selectableIdols)
                    }
                    print("✅ 서버에서 아이돌 목록 가져오기 성공: \(self.selectableIdols)")
                    
                } catch {
                    self.showAlert(title: "오류", message: "아이돌 목록을 불러오는 중 오류가 발생했습니다.")
                    print("❌ JSON 디코딩 오류: \(error)")
                }
                
            case .failure(let error):
                self.showAlert(title: "네트워크 오류", message: "아이돌 목록을 불러오는데 실패했습니다.")
                print("❌ API 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func filterIdols(with query: String) {
        let filtered = selectableIdols.filter { idol in
            idol.idol.idolName.lowercased().contains(query.lowercased())
        }
        selectFavoriteCelebView.updateCollectionView(with: filtered)
    }
    
    func handleNextStep(completion: @escaping () -> Void) {
        sendSelectedIdolsRequest(completion: completion)
    }

    private func sendSelectedIdolsRequest(completion: @escaping () -> Void) {
        let selectedIds = selectableIdols
            .filter { $0.isSelected }
            .map { $0.idol.idolId }

        if selectedIds.isEmpty {
            showAlert(title: "선택 오류", message: "최소 한 개 이상의 아이돌을 선택해주세요.")
            return
        }

        let request = SelectFavoriteIdolRequest(idolCategoryIds: selectedIds)
        
        provider.request(.postMemberInterestCeleb(memberId: memberId, idolNums: request)) { result in
            switch result {
            case .success(let response):
                do {
                    if let successData = try? response.mapJSON() {
                        print("✅ 성공: \(successData)")
                        completion()
                    } else {
                        self.showAlert(title: "오류", message: "응답 데이터를 처리할 수 없습니다.")
                    }
                } catch {
                    self.showAlert(title: "오류", message: "JSON 변환 실패: \(error.localizedDescription)")
                }

            case .failure(let error):
                self.showAlert(title: "네트워크 오류", message: "아이돌 선택 저장에 실패했습니다.")
            }
        }
    }
}
