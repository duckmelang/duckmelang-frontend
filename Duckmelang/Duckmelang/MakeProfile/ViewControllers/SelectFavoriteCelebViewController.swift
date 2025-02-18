//
//  SelectFavoriteCelebViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//


import UIKit
import Alamofire
import Moya

class SelectFavoriteCelebViewController: UIViewController, MoyaErrorHandlerDelegate {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private lazy var provider = MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])

    private let selectFavoriteCelebView = SelectFavoriteCelebView()

    private var idolCategories: [(id: Int, name: String)] = []
    private var selectedIdols: [Int] = []
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
//        fetchIdolCategories()
        //FIXME: - 더미데이터, 수정필요
        loadDummyData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(selectFavoriteCelebView)
        
        selectFavoriteCelebView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupHandlers() {
        // 텍스트 입력 이벤트 감지 → 필터링 적용
        selectFavoriteCelebView.onTextInput = { [weak self] query in
            self?.filterIdols(with: query)
        }

        // 아이돌 선택 이벤트 핸들링
        selectFavoriteCelebView.onIdolSelected = { [weak self] selectedId in
            self?.addSelectedIdol(selectedId)
        }

        // 아이돌 태그 삭제 이벤트 핸들링
        selectFavoriteCelebView.onIdolRemoved = { [weak self] removedId in
            self?.removeSelectedIdol(removedId)
        }
    }
    
    //FIXME: - 더미 데이터 불러오기
    private func loadDummyData() {
        let dummyData = IdolList.dummy1()
        self.idolCategories = dummyData.map { ($0.idolId, $0.idolName) }
        self.selectFavoriteCelebView.updateDropdown(with: self.idolCategories)
    }

//    // API에서 아이돌 카테고리 가져오기
//    private func fetchIdolCategories() {
//    }

    // 입력한 텍스트에 따라 필터링
    private func filterIdols(with query: String) {
        let filtered = idolCategories.filter { $0.name.lowercased().contains(query.lowercased()) }
        selectFavoriteCelebView.updateDropdown(with: filtered)
    }

    // 아이돌 선택 시 추가
    private func addSelectedIdol(_ selectedId: Int) {
        guard let idol = idolCategories.first(where: { $0.id == selectedId }) else { return }
        print("🟢 태그 추가 - ID: \(idol.id), 이름 : \(idol.name)")
        selectedIdols.append(idol.id)
        selectFavoriteCelebView.addTag(idol)
    }

    // 아이돌 태그 삭제 시 목록에서도 제거
    private func removeSelectedIdol(_ removedId: Int) {
        selectFavoriteCelebView.removeTag(removedId)
    }
    
    func handleNextStep(completion: @escaping () -> Void) {
            sendSelectedIdolsRequest(completion: completion)
        }

    // ✅ 서버에 선택한 아이돌 POST 요청 보내기
    private func sendSelectedIdolsRequest(completion: @escaping () -> Void) {
        if selectedIdols.isEmpty {
            showAlert(title: "선택 오류", message: "최소 한 개 이상의 아이돌을 선택해주세요.")
            return
        }

        let request = SelectFavoriteIdolRequest(idolCategoryIds: selectedIdols)

        provider.request(.postMemberInterestCeleb(memberId: memberId, idolNums: request)) { result in
            switch result {
            case .success(let response):
                do {
                    if let successData = try? response.mapJSON() {
                        print("✅ 성공: \(successData)")
                        completion() // ✅ 요청 성공 시 다음 단계로 이동
                    } else {
                        self.showAlert(title: "오류", message: "응답 데이터를 처리할 수 없습니다.")
                    }
                } catch {
                    self.showAlert(title: "오류", message: "JSON 변환 실패: \(error.localizedDescription)")
                }

            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
                self.showAlert(title: "네트워크 오류", message: "아이돌 선택 저장에 실패했습니다.")
            }
        }
    }
}
