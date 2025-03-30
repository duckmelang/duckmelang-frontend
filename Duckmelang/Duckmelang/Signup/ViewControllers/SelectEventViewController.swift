////
////  SelectEventViewController.swift
////  Duckmelang
////
////  Created by 김연우 on 2/17/25.
////
//
//
//import UIKit
//
//class SelectEventViewController: UIViewController, NextStepHandler, UICollectionViewDelegate, SelectEventViewDelegate {
//    func selectedEventsDidChange(_ selectedEvents: Set<Int>) {
//        self.selectedEventIds = selectedEvents
//        print("🟢 View에서 받은 선택된 이벤트 목록: \(selectedEventIds)")
//    }
//    
//    func handleNextStep(completion: @escaping () -> Void) {
//        nextButtonDelegate?.updateNextButtonState(isEnabled: true)
//        postSelectedEvents {completion()}
//    }
//    
//    weak var nextButtonDelegate: NextButtonUpdatable?
//    
//    private func showConfirmationAlert() {
//        let alert = UIAlertController(title: "확인", message: "다음 단계로 이동하시겠습니까?", preferredStyle: .alert)
//        
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
//            print("✅ 다음 단계 진행")
//        }))
//        
//        present(alert, animated: true)
//    }
//    
//    func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "확인", style: .default))
//        present(alert, animated: true)
//    }
//    
//    let networkService = SignupService()
//    
//    private let memberId: Int
//    
//    private var events: [EventCategoryList] = []
//    private var selectedEventIds: Set<Int> = []
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
//    private let selectEventView = SelectEventView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        fetchEventList()
//        
//        selectEventView.delegate = self
//        DispatchQueue.main.async {
//            self.nextButtonDelegate?.updateNextButtonState(isEnabled: true)
//        }
//        
//        print("✅ SelectEventView가 화면에 추가되었는지 확인: \(selectEventView.superview != nil)")
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        view.addSubview(selectEventView)
//        
//        selectEventView.snp.makeConstraints {
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//    
//    private func fetchEventList() {
//        Task {
//            do {
//                startLoading()
//                
//                let result = try await networkService.getAllEvents()
//                
//                DispatchQueue.main.async {
//                    self.selectEventView.updateWithEvents(events: result.eventCategoryList)
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
//    private func postSelectedEvents(completion: @escaping () -> Void) {
//        let selectedEventIds = selectEventView.getSelectedEventIds()
//        
//        if selectedEventIds.isEmpty {
//            print("❌ 선택된 이벤트 없음. 요청을 보내지 않음.")
//            return
//        }
//        
//        print("🟢 선택된 이벤트 ID: \(selectedEventIds) → 서버로 전송")
//
//        let request = SelectFavoriteEventRequest(eventCategoryIds: selectedEventIds)
//        postMemberInterestEventAPI(eventNums: request)
//    }
//    
//    private func postMemberInterestEventAPI(eventNums: SelectFavoriteEventRequest) {
//        Task {
//            do {
//                startLoading()
//                
//                let result = try await networkService.postMemberInterestEvent(memberId: memberId, eventNums: eventNums)
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
//
//extension SelectEventView {
//    func getSelectedEventIds() -> [Int] {
//        return Array(selectedEvents)
//    }
//}
