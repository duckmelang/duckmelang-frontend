//
//  SelectEventViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//


import UIKit
import Moya

class SelectEventViewController: UIViewController, MoyaErrorHandlerDelegate, NextStepHandler, UICollectionViewDelegate, SelectEventViewDelegate {
    func selectedEventsDidChange(_ selectedEvents: Set<Int>) {
        self.selectedEventIds = selectedEvents
        print("🟢 View에서 받은 선택된 이벤트 목록: \(selectedEventIds)")
    }
    
    func handleNextStep(completion: @escaping () -> Void) {
        nextButtonDelegate?.updateNextButtonState(isEnabled: true)
        postSelectedEvents {completion()}
    }
    
    weak var nextButtonDelegate: NextButtonUpdatable?
    
    private func showConfirmationAlert() {
        let alert = UIAlertController(title: "확인", message: "다음 단계로 이동하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            print("✅ 다음 단계 진행")
        }))
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private lazy var provider = MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])
    
    private let memberId: Int
    
    private var events: [EventCategoryList] = []
    private var selectedEventIds: Set<Int> = []
    
    init(memberId: Int) {
        self.memberId = memberId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let selectEventView = SelectEventView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchEventList()
        
        selectEventView.delegate = self
        DispatchQueue.main.async {
            self.nextButtonDelegate?.updateNextButtonState(isEnabled: true)
        }
        
        print("✅ SelectEventView가 화면에 추가되었는지 확인: \(selectEventView.superview != nil)")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(selectEventView)
        
        selectEventView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func fetchEventList() {
        provider.request(.getAllEvents) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let eventListResponse = try response.map(EventListResponse.self)
                    
                    // ✅ 성공적으로 데이터를 가져오면 UI 업데이트
                    DispatchQueue.main.async {
                        self.selectEventView.updateWithEvents(events: eventListResponse.result.eventCategoryList)
                    }
                    
                    print("✅ 서버에서 이벤트 목록 가져오기 성공: \(eventListResponse.result.eventCategoryList)")
                    
                } catch {
                    self.showAlert(title: "오류", message: "이벤트 목록을 불러오는 중 오류가 발생했습니다.")
                    print("❌ JSON 디코딩 오류: \(error)")
                }
                
            case .failure(let error):
                self.showAlert(title: "네트워크 오류", message: "이벤트 목록을 불러오는데 실패했습니다.")
                print("❌ API 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func postSelectedEvents(completion: @escaping () -> Void) {
        let selectedEventIds = selectEventView.getSelectedEventIds()
        
        if selectedEventIds.isEmpty {
            print("❌ 선택된 이벤트 없음. 요청을 보내지 않음.")
            return
        }
        
        print("🟢 선택된 이벤트 ID: \(selectedEventIds) → 서버로 전송")

        let request = SelectFavoriteEventRequest(eventCategoryIds: selectedEventIds)

        provider.request(.postMemberInterestEvent(memberId: memberId, eventNums: request)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: response.data, options: [])
                    print("✅ 이벤트 선택 전송 성공: \(responseJSON)")
                    completion()
                } catch {
                    self.showAlert(title: "오류", message: "응답을 처리하는 중 오류가 발생했습니다.")
                    print("❌ JSON 디코딩 오류: \(error)")
                }
                
            case .failure(let error):
                self.showAlert(title: "네트워크 오류", message: "이벤트 선택 전송에 실패했습니다.")
                print("❌ API 요청 실패: \(error.localizedDescription)")
            }
        }
    }
}

extension SelectEventView {
    func getSelectedEventIds() -> [Int] {
        return Array(selectedEvents)
    }
}
