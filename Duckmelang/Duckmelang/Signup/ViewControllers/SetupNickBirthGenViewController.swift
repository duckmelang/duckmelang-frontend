////
////  SetupNickBirthGenViewController.swift
////  Duckmelang
////
////  Created by 김연우 on 2/17/25.
////
//
//import UIKit
//import Moya
//
//class SetupNickBirthGenViewController: UIViewController, NextStepHandler, NextButtonUpdatable, MoyaErrorHandlerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
//    
//    weak var nextButtonDelegate: NextButtonUpdatable?
//    
//    func updateNextButtonState(isEnabled: Bool) {
//        nextButtonDelegate?.updateNextButtonState(isEnabled: isEnabled)
//    }
//    private func checkNextButtonState() {
//        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
//        let birth = setupNickBirthGenView.birthdateTextField.text ?? ""
//        
//        let isNicknameEntered = !nickname.isEmpty
//        let isBirthdateFilled = !birth.isEmpty
//        
//        let isEnabled = isNicknameEntered && isNicknameAvailable && isBirthdateFilled
//        
//        print("✅ 버튼 활성화 조건 -> 닉네임 입력: \(isNicknameEntered), 중복 확인: \(isNicknameAvailable), 생년월일 입력: \(isBirthdateFilled), 최종 상태: \(isEnabled)")
//        if isEnabled {
//            nextButtonDelegate?.updateNextButtonState(isEnabled: true)
//        } else {
//            nextButtonDelegate?.updateNextButtonState(isEnabled: false)
//        }
//    }
//    
//    
//    func handleNextStep(completion: @escaping () -> Void) {
//        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
//        let birth = setupNickBirthGenView.birthdateTextField.text ?? ""
//        let gender: String
//        if setupNickBirthGenView.maleButton.backgroundColor == .dmrBlue {
//            gender = "MALE"
//        } else {
//            gender = "FEMALE"
//        }
//
//        showConfirmationAlert(nickname: nickname, birth: birth, gender: gender, completion: completion)
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
//    private let setupNickBirthGenView = SetupNickBirthGenView()
//    private var isNicknameAvailable: Bool = false
//    
//    private var uploadedImageURL: String?
//    
//    var onProfileUpdateSuccess: (() -> Void)? // 프로필 설정 성공 시 호출될 콜백
//    
//    //화면 초기 로딩시 초기화
//    public func resetBirthdateField() {
//        setupNickBirthGenView.birthdateTextField.text = ""
//        setupNickBirthGenView.birthdateTextField.textColor = .grey500
//    }
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
//        view.backgroundColor = .white
//        setupUI()
//        resetBirthdateField()
//        setupNickBirthGenView.profileImageButton.addTarget(self, action: #selector(didTapProfileImgSet), for: .touchUpInside)
//        setupNickBirthGenView.maleButton.addTarget(self, action: #selector(didTapMale), for: .touchUpInside)
//        setupNickBirthGenView.femaleButton.addTarget(self, action: #selector(didTapFemale), for: .touchUpInside)
//        setupNickBirthGenView.nickCheckButton.addTarget(self, action: #selector(didTapNickCheck), for: .touchUpInside)
//        setupNickBirthGenView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//    }
//    
//    private func setupDatePicker() {
//        setupNickBirthGenView.datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
//        setupNickBirthGenView.birthdateTextField.inputView = setupNickBirthGenView.datePicker
//        setupNickBirthGenView.birthdateTextField.text = dateFormat(date: Date())
//    }
//
//    // 값이 변할 때 마다 동작
//    @objc func dateChange(_ sender: UIDatePicker) {
//        setupNickBirthGenView.birthdateTextField.text = dateFormat(date: sender.date)
//        setupNickBirthGenView.birthdateTextField.textColor = .grey800
//    }
//    
//    private func setupToolBar() {
//        let toolBar = UIToolbar()
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandeler))
//        toolBar.items = [flexibleSpace, doneButton]
//        toolBar.sizeToFit()
//        setupNickBirthGenView.birthdateTextField.inputAccessoryView = toolBar
//    }
//    
//    @objc func doneButtonHandeler(_ sender: UIBarButtonItem) {
//        setupNickBirthGenView.birthdateTextField.text = dateFormat(date: setupNickBirthGenView.datePicker.date)
//        setupNickBirthGenView.birthdateTextField.textColor = .grey800
//        setupNickBirthGenView.birthdateTextField.resignFirstResponder()
//        checkNextButtonState()
//    }
//    
//    // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
//    private func dateFormat(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        
//        return formatter.string(from: date)
//    }
//    
//    @objc private func didTapProfileImgSet() {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary  // 사진 라이브러리에서 선택
//        imagePicker.allowsEditing = true
//        present(imagePicker, animated: true)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//
//        // 선택한 이미지 가져오기
//        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
//            print("✅ 이미지 선택 완료")
//            
//            setupNickBirthGenView.profileImageButton.setImage(selectedImage, for: .normal)
//
//            // ✅ 3. UIImage -> Data 변환 (JPEG)
//            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
//                // ✅ 4. 서버에 업로드
//                uploadProfileImage(imageData)
//            } else {
//                print("❌ 이미지 변환 실패")
//            }
//        }
//    }
//
//    @objc private func didTapMale() {
//        updateGenderSelection(isMaleSelected: true)
//    }
//
//    @objc private func didTapFemale() {
//        updateGenderSelection(isMaleSelected: false)
//    }
//    
//    private func updateGenderSelection(isMaleSelected: Bool) {
//        setupNickBirthGenView.maleButton.isSelected = isMaleSelected
//        setupNickBirthGenView.femaleButton.isSelected = !isMaleSelected
//        
//        setupNickBirthGenView.maleButton.backgroundColor = isMaleSelected ? .dmrBlue : .white
//        setupNickBirthGenView.femaleButton.backgroundColor = isMaleSelected ? .white : .dmrBlue
//        
//        setupNickBirthGenView.maleButton.setTitleColor(isMaleSelected ? .white : .grey400, for: .normal)
//        setupNickBirthGenView.femaleButton.setTitleColor(isMaleSelected ? .grey400 : .white, for: .normal)
//
//        setupNickBirthGenView.maleButton.layer.borderColor = isMaleSelected ? UIColor.dmrBlue!.cgColor : UIColor.grey400!.cgColor
//        setupNickBirthGenView.femaleButton.layer.borderColor = isMaleSelected ? UIColor.grey400!.cgColor : UIColor.dmrBlue!.cgColor
//    }
//    
//    private func setupUI() {
//        view.addSubview(setupNickBirthGenView)
//        setupDatePicker()
//        setupToolBar()
//        setupNickBirthGenView.snp.makeConstraints { $0.edges.equalToSuperview() }
//    }
//    
//    @objc private func textFieldDidChange(_ textField: UITextField) {
//        // 닉네임이 변경되면 중복확인 버튼을 다시 비활성화 상태로 돌림
//        setupNickBirthGenView.nickCheckButton.configureGenderButton(title: "확인", selectedBool: false)
//        // 중복 확인 상태 초기화
//        isNicknameAvailable = false
//    }
//    
//    @objc private func didTapNickCheck() {
//        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
//        setupNickBirthGenView.nicknameTextField.resignFirstResponder()
//        if nickname.isEmpty {
//            showAlert(title: "입력 오류", message: "닉네임을 입력해주세요.")
//            return
//        }
//
//        getNicknameCheckAPI(nickname: nickname)
//    }
//    
//    private func getNicknameCheckAPI(nickname: String) {
//        _Concurrency.Task {
//            do {
//                startLoading()
//                
//                let result = try await networkService.getMemberNicknameCheck(nickname: nickname)
//                
//                DispatchQueue.main.async {
//                    self.setupNickBirthGenView.nickCheckButton.configureGenderButton(title: "확인", selectedBool: self.isNicknameAvailable)
//                    if self.isNicknameAvailable {
//                        self.setupNickBirthGenView.nicknameTextField.resignFirstResponder()
//                        self.checkNextButtonState()
//                    } else {
//                        self.setupNickBirthGenView.nicknameTextField.becomeFirstResponder()
//                    }
//                    self.showAlert(title: "닉네임 확인", message: "닉네임 확인에 성공하셨습니다!")
//                }
//                
//                stopLoading()
//            }
//            catch {
//                stopLoading()
//                
//                self.setupNickBirthGenView.nickCheckButton.configureGenderButton(title: "확인", selectedBool: isNicknameAvailable)
//                self.checkNextButtonState()
//                self.showAlert(title: "닉네임 확인 실패", message: "닉네임 확인에 실패하였습니다.")
//                
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    private func uploadProfileImage(_ imageData: Data) {
//        let formData = MultipartFormData(provider: .data(imageData), name: "profileImage", fileName: "profile.jpg", mimeType: "image/jpeg")
//        
//        postProfileImageAPI(imageData: formData)
//    }
//    
//    private func postProfileImageAPI(imageData: MultipartFormData) {
//        _Concurrency.Task {
//            do {
//                startLoading()
//                
//                let result = try await networkService.postMemberProfileImage(memberId: memberId, profileImage: [imageData])
//                self.uploadedImageURL = result.memberProfileImageURL
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
//    private func updateMemberProfile(completion: @escaping () -> Void) {
//        let nickname = setupNickBirthGenView.nicknameTextField.text ?? ""
//        let birth = setupNickBirthGenView.birthdateTextField.text ?? ""
//        let gender: String
//        if setupNickBirthGenView.maleButton.backgroundColor == .dmrBlue {
//            gender = "MALE"
//        } else {
//            gender = "FEMALE"
//        }
//
//        if nickname.isEmpty {
//            showAlert(title: "입력 오류", message: "닉네임을 입력해주세요.")
//            return
//        }
//
//        if birth.isEmpty || birth == "YYYY-MM-DD" {
//            showAlert(title: "입력 오류", message: "생년월일을 선택해주세요.")
//            return
//        }
//
//        // ✅ API 요청을 보낸 후 성공하면 `completion()` 호출
//        sendProfileUpdateRequest(nickname: nickname, birth: birth, gender: gender)
//    }
//    
//    private func showConfirmationAlert(nickname: String, birth: String, gender: String, completion: @escaping () -> Void) {
//        let genderText = (gender == "MALE") ? "남성" : "여성"
//        let message = """
//            설정하신 닉네임 : \(nickname)
//            생년월일 : \(birth)
//            성별 : \(genderText)
//            
//            이대로 진행할까요?
//            """
//
//        let alert = UIAlertController(title: "확인", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
//        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
//            self.sendProfileUpdateRequest(nickname: nickname, birth: birth, gender: gender)
//        })
//        present(alert, animated: true)
//    }
//
//    private func sendProfileUpdateRequest(nickname: String, birth: String, gender: String) {
//        let request = PatchMemberProfileRequest(nickname: nickname, birth: birth, gender: gender)
//        patchMemberProfileAPI(profile: request)
//    }
//    
//    private func patchMemberProfileAPI(profile: PatchMemberProfileRequest) {
//        _Concurrency.Task {
//            do {
//                startLoading()
//                
//                let result = try await networkService.patchMemberProfile(memberId: memberId, profile: profile)
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
