//
//  ProfileModifyViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//
import UIKit
import Moya
import Kingfisher

class ProfileModifyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    private let provider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private lazy var profileModifyView = ProfileModifyView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = profileModifyView
        navigationController?.isNavigationBarHidden = true
        setupAction()
        fetchProfileInfo()
    }

    // MARK: - Setup Functions
    private func setupAction() {
        profileModifyView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        profileModifyView.finishBtn.addTarget(self, action: #selector(finishBtnDidTap), for: .touchUpInside)
        profileModifyView.profileAddBtn.addTarget(self, action: #selector(addBtnDidTap), for: .touchUpInside)
        profileModifyView.nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldInput), for: .editingChanged)
        profileModifyView.selfPRTextField.addTarget(self, action: #selector(selfPRTextFieldInput), for: .editingChanged)
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        profileModifyView.addGestureRecognizer(viewTapGesture)
        
        let alertTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        profileModifyView.alert.addGestureRecognizer(alertTapGesture)
    }

    // MARK: - Button Actions
    @objc private func backBtnDidTap() {
        dismiss(animated: false)
    }
    
    @objc private func finishBtnDidTap() {
        let isNicknameEmpty = profileModifyView.nicknameTextField.text?.isEmpty ?? true
        let isSelfPREmpty = profileModifyView.selfPRTextField.text?.isEmpty ?? true
        
        if isNicknameEmpty || isSelfPREmpty {
            updateErrorState(isNicknameEmpty: isNicknameEmpty, isSelfPREmpty: isSelfPREmpty)
        } else {
            resetErrorState()
            saveProfile()
        }
    }

    @objc private func addBtnDidTap() {
        profileModifyView.alert.isHidden = false
        profileModifyView.blurBackgroundView.isHidden = false
    }
    
    @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: sender.view)
        let isUpperHalf = touchPoint.y <= (sender.view?.bounds.height ?? 0) / 2
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if isUpperHalf {
            imagePicker.sourceType = .photoLibrary
        } else if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            print("카메라 접근 불가능")
            return
        }
        
        present(imagePicker, animated: true)
    }

    @objc private func nicknameTextFieldInput() {
        profileModifyView.nicknameTextField.layer.borderColor = UIColor.dmrBlue?.cgColor
        profileModifyView.nicknameErrorText.isHidden = true
    }
    
    @objc private func selfPRTextFieldInput() {
        profileModifyView.selfPRTextField.layer.borderColor = UIColor.dmrBlue?.cgColor
        profileModifyView.selfPRErrorText.isHidden = true
    }
    
    @objc private func viewDidTap() {
        profileModifyView.alert.isHidden = true
        profileModifyView.blurBackgroundView.isHidden = true
    }

    // MARK: - Error Handling
    private func updateErrorState(isNicknameEmpty: Bool, isSelfPREmpty: Bool) {
        if isNicknameEmpty {
            profileModifyView.nicknameTextField.layer.borderColor = UIColor.errorPrimary?.cgColor
            profileModifyView.nicknameErrorText.isHidden = false
        }
        if isSelfPREmpty {
            profileModifyView.selfPRTextField.layer.borderColor = UIColor.errorPrimary?.cgColor
            profileModifyView.selfPRErrorText.isHidden = false
        }
    }
    
    private func resetErrorState() {
        profileModifyView.nicknameTextField.layer.borderColor = UIColor.grey400?.cgColor
        profileModifyView.nicknameErrorText.isHidden = true
        profileModifyView.selfPRTextField.layer.borderColor = UIColor.grey400?.cgColor
        profileModifyView.selfPRErrorText.isHidden = true
    }

    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage, let imageData = editedImage.jpegData(compressionQuality: 0.8) {
            profileModifyView.profileImage.image = editedImage
            profileModifyView.profileImage.clipsToBounds = true
            profileModifyView.profileImage.layer.cornerRadius = profileModifyView.profileImage.frame.height/2
            uploadProfileImage(imageData)
            profileModifyView.profileAddBtn.isHidden = true
        }
        
        profileModifyView.alert.isHidden = true
        profileModifyView.blurBackgroundView.isHidden = true
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: - API Requests
    func uploadProfileImage(_ imageData: Data) {
        let formData = MultipartFormData(provider: .data(imageData),
                                         name: "profileImage",
                                         fileName: "profile.jpg",
                                         mimeType: "image/jpeg")
        
        provider.request(.postProfileImage(profileImage: [formData])) { result in
            switch result {
            case .success(let response):
                self.handleUploadResponse(response)
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleUploadResponse(_ response: Response) {
        do {
            let decodedResponse = try response.map(ApiResponse<ProfileImageResponse>.self)
            if decodedResponse.isSuccess, let imageURLString = decodedResponse.result?.memberProfileImageUrl, let imageURL = URL(string: imageURLString) {
                updateProfileImage(with: imageURL)
            } else {
                print("❌ 업로드 실패: \(decodedResponse.message)")
            }
        } catch {
            print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
        }
    }
    
    func updateProfileImage(with url: URL) {
        profileModifyView.profileImage.kf.setImage(with: url)
    }
    
    @objc private func saveProfile() {
        guard let nickname = profileModifyView.nicknameTextField.text,
              let introduction = profileModifyView.selfPRTextField.text else { return }
        
        let profileData = EditProfileRequest(memberProfileImageURL: "https://image.url", nickname: nickname, introduction: introduction)
        
        provider.request(.patchProfile(profileData: profileData)) { result in
            switch result {
            case .success(let response):
                self.handleSaveResponse(response)
            case .failure(let error):
                print("❌ 프로필 저장 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleSaveResponse(_ response: Response) {
        do {
            let decodedResponse = try response.map(ApiResponse<EditProfileRequest>.self)
            if decodedResponse.isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name("ProfileUpdated"), object: nil)
                dismiss(animated: true)
            } else {
                print("❌ 프로필 업데이트 실패: \(decodedResponse.message)")
            }
        } catch {
            print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Profile API 호출
    private func fetchProfileInfo() {
        provider.request(.getProfile) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<ProfileEditInfoResponse>.self)
                    if decodedResponse.isSuccess {
                        guard let profileData = decodedResponse.result else { return }
                        DispatchQueue.main.async {
                            self.updateProfileView(with: profileData)
                        }
                    } else {
                        print("❌ 프로필 정보 조회 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ API 요청 실패: \(error.localizedDescription)")
            }
        }
    }

    private func updateProfileView(with profile: ProfileEditInfoResponse) {
        // 닉네임 텍스트필드에 서버에서 받은 닉네임 표시
        profileModifyView.nicknameTextField.text = profile.nickname
        
        // 서버에서 받은 이미지 URL을 Kingfisher로 로드
        if let imageUrlString = profile.latestPublicMemberProfileImage, let imageUrl = URL(string: imageUrlString) {
            profileModifyView.profileImage.kf.setImage(with: imageUrl)
            profileModifyView.profileImage.contentMode = .scaleAspectFill
        } else {
            profileModifyView.profileImage.image = UIImage(resource: .profileModify) // 기본 이미지 설정
        }
        
        // 스타일 적용
        profileModifyView.profileImage.clipsToBounds = true
        profileModifyView.profileImage.layer.cornerRadius = profileModifyView.profileImage.frame.height / 2
        profileModifyView.profileImage.layoutIfNeeded()
    }
}
