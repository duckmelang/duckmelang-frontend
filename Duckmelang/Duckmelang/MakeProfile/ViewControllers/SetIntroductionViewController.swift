//
//  SetIntroductionViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/21/25.
//

import UIKit
import Moya

class SetIntroductionViewController: UIViewController, MoyaErrorHandlerDelegate, NextStepHandler, NextButtonUpdatable, SetIntroductionViewDelegate, UITextFieldDelegate {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    
    private lazy var provider = MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])
    
    weak var nextButtonDelegate: NextButtonUpdatable?
    
    func updateNextButtonState(isEnabled: Bool) {
        nextButtonDelegate?.updateNextButtonState(isEnabled: isEnabled)
    }
    
    public func checkNextButtonState() {
        let introduction = setIntroductionView.introductionTextField.text ?? ""
        let isEnabled = !introduction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  // ✅ 공백만 입력된 경우 방지
        
        print("✅ 버튼 활성화 조건 -> 자기소개 입력 여부: \(isEnabled)")
        
        DispatchQueue.main.async {  // ✅ UI 업데이트는 메인 스레드에서 실행
            self.nextButtonDelegate?.updateNextButtonState(isEnabled: isEnabled)
        }
    }
    
    private let memberId: Int
    private let setIntroductionView = SetIntroductionView()
    private var introductionText: String = "" {
        didSet {
            print("📌 현재 입력된 자기소개: '\(introductionText)' (길이: \(introductionText.count))")
            checkNextButtonState()
        }
    }
    
    private var isNicknameAvailable: Bool = false
    
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
        setIntroductionView.delegate = self
    }
    
    func introductionTextDidChange(_ text: String) {
        introductionText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        print("IntroductionText: \(introductionText)")
    }
    
    func handleNextStep(completion: @escaping () -> Void) {
        print("📌 handleNextStep 실행됨 - 입력된 자기소개: '\(introductionText)'")
        patchMemberIntroduction(introduction: introductionText) { // ✅ 최신 값 전달
            completion() // ✅ 서버 요청이 끝난 후 completion 호출
        }
    }
    
    private func setupUI() {
        view.addSubview(setIntroductionView)
        setIntroductionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func patchMemberIntroduction(introduction: String, completion: @escaping () -> Void) {
        
        provider.request(.patchMemberIntroduction(memberId: memberId, introduction: introduction)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(SetIntroIntroductionResponse.self, from: response.data)
                    if decodedResponse.isSuccess {
                        print("✅ 자기소개 업데이트 성공: \(decodedResponse.result.introContent)")
                        // ✅ 다음 화면으로 이동하는 로직 추가 가능
                    } else {
                        print("❌ 자기소개 업데이트 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("❌ 네트워크 오류: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
