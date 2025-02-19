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

    private var idolCategories: [Idol] = []
    private var selectedIdols: [(id: Int, name: String)] = []

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

    private func fetchIdolCategories() {
        provider.request(.getAllIdols) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                do {
                    let idolListResponse = try response.map(IdolListResponse.self)
                    
                    // 서버에서 받아온 데이터를 idolCategories에 저장
                    self.idolCategories = idolListResponse.result.idolList.map { Idol(idolId: $0.idolId, idolName: $0.idolName, idolImage: $0.idolImage)}

                    // UI 업데이트
                    DispatchQueue.main.async {
                        self.selectFavoriteCelebView.updateCollectionView(with: self.idolCategories)
                    }
                    print("✅ 서버에서 아이돌 목록 가져오기 성공: \(self.idolCategories)")

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

    // 입력한 텍스트에 따라 필터링
    private func filterIdols(with query: String) {
        let filtered = idolCategories.filter { $0.idolName.lowercased().contains(query.lowercased()) }
        selectFavoriteCelebView.updateCollectionView(with: filtered)
    }

    // 아이돌 선택 시 추가
    private func addSelectedIdol(_ selectedIdol: Idol) {
        selectedIdols.append((id: selectedIdol.idolId, name: selectedIdol.idolName))
        // ✅ 배열 형태로 넘겨줌
        selectFavoriteCelebView.updateCollectionView(with: [selectedIdol])
        print("📌 추가 - 현재 선택된 아이돌 목록: \(selectedIdols)") // ✅ 추가 후 확인
        nextButtonDelegate?.updateNextButtonState(isEnabled: !selectedIdols.isEmpty)
    }

    // 아이돌 태그 삭제 시 목록에서도 제거
    private func removeSelectedIdol(_ removedId: Int) {
        selectedIdols.removeAll { $0.id == removedId }
        // ✅ selectedIdols에 저장된 id를 기준으로 idolCategories에서 해당 데이터만 찾아서 업데이트
        let remainingIdols = idolCategories.filter { idol in
            selectedIdols.contains { $0.id == idol.idolId }
        }
        selectFavoriteCelebView.updateCollectionView(with: remainingIdols) // ✅ UI 업데이트
        print("📌 삭제 - 현재 선택된 아이돌 목록: \(selectedIdols)") // ✅ 삭제 후 확인
        nextButtonDelegate?.updateNextButtonState(isEnabled: !selectedIdols.isEmpty)
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

        let request = SelectFavoriteIdolRequest(idolCategoryIds: selectedIdols.map { $0.id })

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
                self.showAlert(title: "네트워크 오류", message: "아이돌 선택 저장에 실패했습니다.")
            }
        }
    }
}
