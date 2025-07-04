//
//  SetupNickBirthGenViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 4/2/25.
//

import UIKit
import Moya
import SwiftyToaster

class SetupNickBirthGenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let networkService = SignupService()
    
    var memberId: Int?
    private var isNicknameAvailable: Bool = false
    private var selectedImage: UIImage?
    private var isMaleSelected: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = setupNickBirthGenView
        
        setupDatePicker()
        setupToolBar()
        setupAction()
        setupNavigationBar()
    }
    
    private lazy var setupNickBirthGenView: SetupNickBirthGenView = {
        let view = SetupNickBirthGenView()
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = "회원가입"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(
            ofSize: 18
        )]
        
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(openBackPopup)
        )
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func openBackPopup() {
        let popupVC = ProfileCancelPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
    }
    
    private func setupAction() {
        setupNickBirthGenView.nicknameTextField.addTarget(self, action: #selector(nicknameChanged), for: .editingChanged)
        setupNickBirthGenView.nickCheckButton.addTarget(self, action: #selector(checkNickname), for: .touchUpInside)
        setupNickBirthGenView.profileImageButton.addTarget(self, action: #selector(didTapProfileImgSet), for: .touchUpInside)
        setupNickBirthGenView.maleButton.addTarget(self, action: #selector(didTapMale), for: .touchUpInside)
        setupNickBirthGenView.femaleButton.addTarget(self, action: #selector(didTapFemale), for: .touchUpInside)
        setupNickBirthGenView.nextButton.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
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
        updateNextButtonState()
    }

    // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: date)
    }

    @objc private func didTapProfileImgSet() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary  // 사진 라이브러리에서 선택
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        // 선택한 이미지 가져오기
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            print("✅ 이미지 선택 완료")

            setupNickBirthGenView.profileImageButton.setImage(selectedImage, for: .normal)
            self.selectedImage = selectedImage
        }
    }

    @objc private func didTapMale() {
        updateGenderSelection(isMaleSelected: true)
        updateNextButtonState()
    }

    @objc private func didTapFemale() {
        updateGenderSelection(isMaleSelected: false)
        updateNextButtonState()
    }

    private func updateGenderSelection(isMaleSelected: Bool) {
        self.isMaleSelected = isMaleSelected
        setupNickBirthGenView.maleButton.isSelected = isMaleSelected
        setupNickBirthGenView.femaleButton.isSelected = !isMaleSelected
    }
    
    // 닉네임 텍스트필드 변경할 때마다
    @objc func nicknameChanged() {
        if (self.isNicknameAvailable) {
            self.isNicknameAvailable = false
            setupNickBirthGenView.checkIcon.isHidden = true
            setupNickBirthGenView.nickCheckButton.isSelected = false
            setupNickBirthGenView.nickCheckButton.isEnabled = false
        }
        
        let text = setupNickBirthGenView.nicknameTextField.text ?? ""
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        setupNickBirthGenView.nickCheckButton.isSelected = !trimmedText.isEmpty
        setupNickBirthGenView.nickCheckButton.isEnabled = !trimmedText.isEmpty
        
        updateNextButtonState()
    }
    
    // 닉네임 체크 버튼
    @objc func checkNickname() {
        guard let nickname = setupNickBirthGenView.nicknameTextField.text else { return }
        checkNicknameAPI(nickname: nickname)
    }
    
    // 다음 버튼 눌렀을 때
    @objc func nextBtn() {
        self.navigateToSelectFavoriteCelebView()
//        // 닉네임 입력 확인
//        guard let nickname = setupNickBirthGenView.nicknameTextField.text, !nickname.isEmpty else {
//            Toaster.shared.makeToast("닉네임을 입력해주세요.")
//            return
//        }
//        
//        // 생년월일 입력 확인
//        guard let birth = setupNickBirthGenView.birthdateTextField.text, !birth.isEmpty else {
//            Toaster.shared.makeToast("생년월일을 입력해주세요.")
//            return
//        }
//        
//        // 성별 선택 확인
//        guard let isMaleSelected = isMaleSelected else {
//            Toaster.shared.makeToast("성별을 선택해주세요.")
//            return
//        }
//
//        // 프로필 사진 선택 확인
//        guard let selectedImage = selectedImage else {
//            Toaster.shared.makeToast("프로필 사진을 선택해주세요.")
//            return
//        }
//
//        // 멤버 ID 확인
//        guard let memberId = memberId else {
//            Toaster.shared.makeToast("회원 정보를 불러올 수 없습니다.\n잠시 후 다시 시도해주세요.")
//            return
//        }

//        let gender = isMaleSelected ? "MALE" : "FEMALE"
//
//        // 프로필 이미지 전송
//        if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
//            postProfileImageAPI(memberId: memberId, imageData: imageData)
//        } else {
//            Toaster.shared.makeToast("이미지 변환에 실패했습니다.\n잠시 후 다시 시도해주세요.")
//            return
//        }
//
//        // 프로필 정보 전송
//        patchMemberProfileAPI(memberId: memberId, nickname: nickname, birth: birth, gender: gender)
    }
    
    func updateNextButtonState() {
        let isImageSelected = selectedImage != nil
        let isBirthEntered = !(setupNickBirthGenView.birthdateTextField.text?.isEmpty ?? true)
        let isGenderSelected = isMaleSelected != nil
        
        print(isImageSelected && isNicknameAvailable && isBirthEntered && isGenderSelected)
        setupNickBirthGenView.nextButton.setEnabled(isImageSelected && isNicknameAvailable && isBirthEntered && isGenderSelected)
    }
    
    // 닉네임 중복 확인 API
    private func checkNicknameAPI(nickname: String) {
        _Concurrency.Task {
            do {
                startLoading()
                
                let result = try await networkService.getMemberNicknameCheck(nickname: nickname)
                self.isNicknameAvailable = result.available
                updateNextButtonState()
                
                DispatchQueue.main.async {
                    self.setupNickBirthGenView.checkIcon.isHidden = !self.isNicknameAvailable
                    
                    let modal = CheckNicknamePopupViewController()
                    modal.isAvailable = self.isNicknameAvailable
                    modal.modalPresentationStyle = .overFullScreen
                    self.present(modal, animated: false)
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }

    private func postProfileImageAPI(memberId: Int, imageData: Data) {
        _Concurrency.Task {
            do {
                startLoading()
                
                let formData = MultipartFormData(provider: .data(imageData), name: "profileImage", fileName: "profile.jpg", mimeType: "image/jpeg")
                _ = try await networkService.postMemberProfileImage(memberId: memberId, profileImage: [formData])

                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func patchMemberProfileAPI(memberId: Int, nickname: String, birth: String, gender: String) {
        _Concurrency.Task {
            do {
                startLoading()
                
                let request = PatchMemberProfileRequest(nickname: nickname, birth: birth, gender: gender)
                _ = try await networkService.patchMemberProfile(memberId: memberId, profile: request)
                
                DispatchQueue.main.async {
                    self.navigateToSelectFavoriteCelebView()
                }

                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func navigateToSelectFavoriteCelebView() {
        let celebVC = SelectFavoriteCelebViewController()
        celebVC.hidesBottomBarWhenPushed = true
        celebVC.memberId = self.memberId
        navigationController?.pushViewController(celebVC, animated: true)
    }
}
