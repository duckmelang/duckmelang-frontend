//
//  SetupNickBirthGenViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//

import UIKit
import Moya

class SetupNickBirthGenViewController: UIViewController, NextStepHandler, MoyaErrorHandlerDelegate{
    func handleNextStep(completion: @escaping () -> Void) {
        
        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
        let birth = setupNickBirthGenView.birthdateTextField.text ?? ""
        let gender: String
        if setupNickBirthGenView.maleButton.backgroundColor == .dmrBlue {
            gender = "MALE"
        } else {
            gender = "FEMALE"
        }

        if nickname.isEmpty {
            showErrorAlert(title: "입력 오류", message: "닉네임을 입력해주세요.")
            return
        }

        if birth.isEmpty {
            showErrorAlert(title: "입력 오류", message: "생년월일을 입력해주세요.")
            return
        }

        showConfirmationAlert(nickname: nickname, birth: birth, gender: gender, completion: completion)
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    
    private lazy var provider = MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])
    
    private let memberId: Int
    private let nextButtonView = NextButtonView()
    private let setupNickBirthGenView = SetupNickBirthGenView()
    // 닉네임 중복 체크 결과 저장
    private var isNicknameAvailable = false {
        didSet {updateNextButtonState()}
    }
    
    private func updateNextButtonState() {
        nextButtonView.nextButton.isEnabled = isNicknameAvailable
    }
    
    var onProfileUpdateSuccess: (() -> Void)? // 프로필 설정 성공 시 호출될 콜백

    init(memberId: Int) {
        self.memberId = memberId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNickBirthGenView.resetBirthdateField()
        setupNickBirthGenView.maleButton.addTarget(self, action: #selector(didTapMale), for: .touchUpInside)
        setupNickBirthGenView.femaleButton.addTarget(self, action: #selector(didTapFemale), for: .touchUpInside)
        setupNickBirthGenView.nickCheckButton.addTarget(self, action: #selector(didTapNickCheck), for: .touchUpInside)
    }

    @objc private func didTapMale() {
        updateGenderSelection(isMaleSelected: true)
    }

    @objc private func didTapFemale() {
        updateGenderSelection(isMaleSelected: false)
    }
    
    private func updateGenderSelection(isMaleSelected: Bool) {
        setupNickBirthGenView.maleButton.isSelected = isMaleSelected
        setupNickBirthGenView.femaleButton.isSelected = !isMaleSelected
        
        setupNickBirthGenView.maleButton.backgroundColor = isMaleSelected ? .dmrBlue : .white
        setupNickBirthGenView.femaleButton.backgroundColor = isMaleSelected ? .white : .dmrBlue
        
        setupNickBirthGenView.maleButton.setTitleColor(isMaleSelected ? .white : .grey400, for: .normal)
        setupNickBirthGenView.femaleButton.setTitleColor(isMaleSelected ? .grey400 : .white, for: .normal)

        setupNickBirthGenView.maleButton.layer.borderColor = isMaleSelected ? UIColor.dmrBlue!.cgColor : UIColor.grey400!.cgColor
        setupNickBirthGenView.femaleButton.layer.borderColor = isMaleSelected ? UIColor.grey400!.cgColor : UIColor.dmrBlue!.cgColor
    }
    
    private func setupUI() {
        view.addSubview(setupNickBirthGenView)
        setupNickBirthGenView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    @objc private func didTapNickCheck() {
        let nickname = setupNickBirthGenView.nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if nickname.isEmpty {
            showErrorAlert(title: "입력 오류", message: "닉네임을 입력해주세요.")
            return
        }

        provider.request(.getMemberNicknameCheck(nickname: nickname)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let nicknameResponse = try response.map(NicknameCheckResponse.self)
                    if nicknameResponse.isSuccess {
                        self.isNicknameAvailable = nicknameResponse.result.available
                        let buttonTitle = "확인"
                        let isAvailable = nicknameResponse.result.available
                        
                        self.showErrorAlert(title: "닉네임 확인", message: nicknameResponse.result.message)
                        self.setupNickBirthGenView.nickCheckButton.configureGenderButton(title: buttonTitle, selectedBool: isAvailable)
                    } else {
                        self.isNicknameAvailable = false
                        self.showErrorAlert(title: "닉네임 확인 실패", message: "닉네임 확인에 실패했습니다.")
                        self.setupNickBirthGenView.nickCheckButton.configureGenderButton(title: "확인", selectedBool: false)
                    }
                } catch {
                    self.showErrorAlert(title: "오류", message: "닉네임 중복 확인 중 오류가 발생했습니다.")
                }
            case .failure(let error):
                self.showErrorAlert(title: "네트워크 오류", message: error.localizedDescription)
            }
        }
    }
    
    private func updateMemberProfile(completion: @escaping () -> Void) {
        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
        let birth = setupNickBirthGenView.birthdateTextField.text ?? ""
        let gender: String
        if setupNickBirthGenView.maleButton.backgroundColor == .dmrBlue {
            gender = "MALE"
        } else {
            gender = "FEMALE"
        }

        if nickname.isEmpty {
            showErrorAlert(title: "입력 오류", message: "닉네임을 입력해주세요.")
            return
        }

        if birth.isEmpty || birth == "YYYY-MM-DD" {
            showErrorAlert(title: "입력 오류", message: "생년월일을 선택해주세요.")
            return
        }

        // ✅ API 요청을 보낸 후 성공하면 `completion()` 호출
        sendProfileUpdateRequest(nickname: nickname, birth: birth, gender: gender, completion: completion)
    }
    
    private func showConfirmationAlert(nickname: String, birth: String, gender: String, completion: @escaping () -> Void) {
        let genderText = (gender == "MALE") ? "남성" : "여성"
        let message = """
            설정하신 닉네임 : \(nickname)
            생년월일 : \(birth)
            성별 : \(genderText)
            
            이대로 진행할까요?
            """

        let alert = UIAlertController(title: "확인", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.sendProfileUpdateRequest(nickname: nickname, birth: birth, gender: gender, completion: completion)
        })
        present(alert, animated: true)
    }

    private func sendProfileUpdateRequest(nickname: String, birth: String, gender: String, completion: @escaping () -> Void) {
        let request = PatchMemberProfileRequest(nickname: nickname, birth: birth, gender: gender)

        provider.request(.patchMemberProfile(memberId: memberId, profile: request)) { result in
            switch result {
            case .success(let response):
                do {
                    if let successData = try? response.map(PatchMemberProfileSuccessResponse.self), successData.isSuccess {
                        print("✅ 서버 응답 성공! 닉네임: \(successData.result.nickname), 생년월일: \(successData.result.birth)")
                        completion() // ✅ 요청 성공 시 다음 단계로 이동
                    } else if let errorData = try? response.map(PatchMemberProfileErrorResponse.self) {
                        print("❌ 서버 응답 실패! 코드: \(errorData.code), 메시지: \(errorData.message)")
                        self.showErrorAlert(title: "프로필 설정 실패", message: errorData.message)
                    } else {
                        self.showErrorAlert(title: "오류", message: "응답 데이터를 처리할 수 없습니다.")
                    }
                }

            case .failure(let error):
                print("❌ 프로필 설정 실패: \(error.localizedDescription)")
                self.showErrorAlert(title: "오류", message: "프로필 설정 실패: \(error.localizedDescription)")
            }
        }
    }
}
