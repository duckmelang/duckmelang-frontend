//
//  ProfileModifyViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//
import UIKit
import Kingfisher
import Moya
import SwiftyToaster

class ProfileModifyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let networkService = MyPageService()
    private lazy var profileModifyView = ProfileModifyView()
    private var uploadedImageURL: String? = nil
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = profileModifyView
        navigationController?.isNavigationBarHidden = true
        setupAction()
        getProfileInfo()
        
        self.profileModifyView.contentView.isHidden = true
        
        startLoading()
    }

    // MARK: - Setup Functions
    private func setupAction() {
        profileModifyView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        profileModifyView.finishBtn.addTarget(self, action: #selector(finishBtnDidTap), for: .touchUpInside)
        profileModifyView.profileAddBtn.addTarget(self, action: #selector(addBtnDidTap), for: .touchUpInside)
    }

    // MARK: - Button Actions
    @objc private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func finishBtnDidTap() {
        let isNicknameEmpty = profileModifyView.nicknameTextField.text?.isEmpty ?? true
        let isSelfPREmpty = profileModifyView.selfPRTextField.text?.isEmpty ?? true

        if isNicknameEmpty || isSelfPREmpty {
            updateErrorState(isNicknameEmpty: isNicknameEmpty, isSelfPREmpty: isSelfPREmpty)
            return
        }

        resetErrorState()

        if let imageData = profileModifyView.profileImage.image?.jpegData(compressionQuality: 0.8) {
            postProfileImage(imageData) // 이미지 업로드
        } else {
            patchProfileInfo() // 이미지 없이 닉네임과 자기소개만 수정
        }
    }

    private func patchProfileInfo() {
        guard let nickname = profileModifyView.nicknameTextField.text,
              let introduction = profileModifyView.selfPRTextField.text else { return }
        
        let profileData = EditProfileRequest(nickname: nickname, introduction: introduction)
        
        _Concurrency.Task {
            do {
                try await networkService.patchProfile(profileData: profileData)
                
                NotificationCenter.default.post(
                    name: NSNotification.Name("ProfileUpdated"),
                    object: nil,
                    userInfo: ["nickname": nickname, "introduction": introduction, "imageURL": self.uploadedImageURL ?? ""]
                )
                
                Toaster.shared.makeToast("프로필 수정이 완료되었습니다.")
                self.navigationController?.popViewController(animated: true)
                stopLoading()
            } catch {
                print(error.localizedDescription)
                Toaster.shared.makeToast("프로필 수정에 실패했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }

    @objc private func addBtnDidTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
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
        if let editedImage = info[.editedImage] as? UIImage {
            profileModifyView.profileImage.image = editedImage
            profileModifyView.profileImage.layer.cornerRadius = profileModifyView.profileImage.frame.height / 2
            profileModifyView.profileImage.clipsToBounds = true
        }
        picker.dismiss(animated: true)
    }

    // MARK: - API Requests
    private func postProfileImage(_ imageData: Data) {
        _Concurrency.Task {
            do {
                startLoading()
                
                let formData = MultipartFormData(provider: .data(imageData), name: "profileImage", fileName: "profile.jpg", mimeType: "image/jpeg")
                       
                let response = try await networkService.postProfileImage(profileImage: [formData])
                self.uploadedImageURL = response.memberProfileImageUrl
                self.patchProfileInfo()  // 이미지 URL이 성공적으로 저장된 후 닉네임과 자기소개 수정
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func getProfileInfo() {
        _Concurrency.Task {
            do {
                startLoading()
                let profile = try await networkService.getLatestProfile() // 닉네임, 사진 불러오기
                self.updateProfileView(with: profile)
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }

    private func updateProfileView(with profile: ProfileEditInfoResponse) {
        profileModifyView.nicknameTextField.text = profile.nickname
        //profileModifyView.selfPRTextField.text = profile.introduction
        if let imageUrlString = profile.latestPublicMemberProfileImage, let imageUrl = URL(string: imageUrlString) {
            profileModifyView.profileImage.kf.setImage(with: imageUrl) { result in
                switch result {
                case .success:
                    self.makeProfileImageRound()
                case .failure:
                    print("❌ 이미지 로드 실패")
                }
            }
        }
        
        self.profileModifyView.contentView.isHidden = false
    }
    
    private func makeProfileImageRound() {
        profileModifyView.profileImage.layer.cornerRadius = profileModifyView.profileImage.frame.height / 2
        profileModifyView.profileImage.clipsToBounds = true
    }
}
