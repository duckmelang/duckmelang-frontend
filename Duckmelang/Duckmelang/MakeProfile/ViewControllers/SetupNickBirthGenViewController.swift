//
//  SetupNickBirthGenViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//

import UIKit
import Moya

class SetupNickBirthGenViewController: UIViewController, NextStepHandler, NextButtonUpdatable, MoyaErrorHandlerDelegate{
    
    weak var nextButtonDelegate: NextButtonUpdatable?
    
    func updateNextButtonState(isEnabled: Bool) {
        nextButtonDelegate?.updateNextButtonState(isEnabled: isEnabled)
    }
    private func checkNextButtonState() {
        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
        let birth = setupNickBirthGenView.birthdateTextField.text ?? ""
        
        let isNicknameEntered = !nickname.isEmpty
        let isBirthdateFilled = !birth.isEmpty
        
        let isEnabled = isNicknameEntered && isNicknameAvailable && isBirthdateFilled
        
        print("✅ 버튼 활성화 조건 -> 닉네임 입력: \(isNicknameEntered), 중복 확인: \(isNicknameAvailable), 생년월일 입력: \(isBirthdateFilled), 최종 상태: \(isEnabled)")
        if isEnabled {
            nextButtonDelegate?.updateNextButtonState(isEnabled: true)
        } else {
            nextButtonDelegate?.updateNextButtonState(isEnabled: false)
        }
    }
    
    
    func handleNextStep(completion: @escaping () -> Void) {
        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
        let birth = setupNickBirthGenView.birthdateTextField.text ?? ""
        let gender: String
        if setupNickBirthGenView.maleButton.backgroundColor == .dmrBlue {
            gender = "MALE"
        } else {
            gender = "FEMALE"
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
    private let setupNickBirthGenView = SetupNickBirthGenView()
    private var isNicknameAvailable: Bool = false
    

    
    var onProfileUpdateSuccess: (() -> Void)? // 프로필 설정 성공 시 호출될 콜백
    
    //화면 초기 로딩시 초기화
    public func resetBirthdateField() {
        setupNickBirthGenView.birthdateTextField.text = ""
        setupNickBirthGenView.birthdateTextField.textColor = .grey500
    }

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
        resetBirthdateField()
        setupNickBirthGenView.maleButton.addTarget(self, action: #selector(didTapMale), for: .touchUpInside)
        setupNickBirthGenView.femaleButton.addTarget(self, action: #selector(didTapFemale), for: .touchUpInside)
        setupNickBirthGenView.nickCheckButton.addTarget(self, action: #selector(didTapNickCheck), for: .touchUpInside)
    }
    
    private func setupDatePicker() {
        setupNickBirthGenView.datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        setupNickBirthGenView.birthdateTextField.inputView = setupNickBirthGenView.datePicker
        setupNickBirthGenView.birthdateTextField.text = dateFormat(date: Date())
    }

    // 값이 변할 때 마다 동작
    @objc func dateChange(_ sender: UIDatePicker) {
        setupNickBirthGenView.birthdateTextField.text = dateFormat(date: sender.date)
        setupNickBirthGenView.birthdateTextField.textColor = .grey800
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandeler))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        setupNickBirthGenView.birthdateTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonHandeler(_ sender: UIBarButtonItem) {
        setupNickBirthGenView.birthdateTextField.text = dateFormat(date: setupNickBirthGenView.datePicker.date)
        setupNickBirthGenView.birthdateTextField.textColor = .grey800
        setupNickBirthGenView.birthdateTextField.resignFirstResponder()
        checkNextButtonState()
    }
    
    // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
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
        setupDatePicker()
        setupToolBar()
        setupNickBirthGenView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    @objc private func didTapNickCheck() {
        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
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
                    self.isNicknameAvailable = nicknameResponse.result.available
                    if nicknameResponse.isSuccess {
                        self.setupNickBirthGenView.nickCheckButton.configureGenderButton(title: "확인", selectedBool: isNicknameAvailable)
                        
                        self.checkNextButtonState()
                        self.showErrorAlert(title: "닉네임 확인", message: nicknameResponse.result.message)
                    } else {
                        self.setupNickBirthGenView.nickCheckButton.configureGenderButton(title: "확인", selectedBool: isNicknameAvailable)
                        self.checkNextButtonState()
                        // 실패 시 서버에서 전달된 message 사용
                        self.showErrorAlert(title: "닉네임 확인 실패", message: nicknameResponse.message)
                    }
                } catch {
                    self.isNicknameAvailable = false
                    self.showErrorAlert(title: "오류", message: "닉네임 중복 확인 중 오류가 발생했습니다.")
                }
            case .failure(let error):
                self.isNicknameAvailable = false
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
