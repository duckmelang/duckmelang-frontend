//
//  ProfileModifyViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class ProfileModifyViewController: UIViewController {
    
    private let provider = MoyaProvider<AllEndpoint>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileModifyView
        
        navigationController?.isNavigationBarHidden = true
        
        setupAction()
    }
    
    private lazy var profileModifyView = ProfileModifyView()
    
    private func setupAction() {
        profileModifyView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        profileModifyView.finishBtn.addTarget(self, action: #selector(finishBtnDidTap), for: .touchUpInside)
        profileModifyView.profileAddBtn.addTarget(self, action: #selector(addBtnDidTap), for: .touchUpInside)
        profileModifyView.nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldInput), for: .editingChanged)
        profileModifyView.selfPRTextField.addTarget(self, action: #selector(selfPRTextFieldInput), for: .editingChanged)
        
        let viewDidTap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        viewDidTap.numberOfTapsRequired = 1 // 단일 탭, 횟수 설정
        profileModifyView.addGestureRecognizer(viewDidTap)
        
        let alertDidTap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        profileModifyView.alert.addGestureRecognizer(alertDidTap)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc
    private func finishBtnDidTap() {
        if (profileModifyView.nicknameTextField.text == "")||(profileModifyView.selfPRTextField.text == ""){
            profileModifyView.nicknameTextField.layer.borderColor = UIColor.errorPrimary?.cgColor
            profileModifyView.nicknameTextField.textColor = .errorPrimary
            profileModifyView.nicknameErrorText.isHidden = false
            
            profileModifyView.selfPRTextField.layer.borderColor = UIColor.errorPrimary?.cgColor
            profileModifyView.selfPRTextField.textColor = .errorPrimary
            profileModifyView.selfPRErrorText.isHidden = false
        }else if (profileModifyView.selfPRTextField.text == ""){
            profileModifyView.selfPRTextField.layer.borderColor = UIColor.errorPrimary?.cgColor
            profileModifyView.selfPRTextField.textColor = .errorPrimary
            profileModifyView.selfPRErrorText.isHidden = false
            profileModifyView.nicknameErrorText.isHidden = true
        }else if (profileModifyView.nicknameTextField.text == ""){
            profileModifyView.nicknameTextField.layer.borderColor = UIColor.errorPrimary?.cgColor
            profileModifyView.nicknameTextField.textColor = .errorPrimary
            profileModifyView.nicknameErrorText.isHidden = false
            profileModifyView.selfPRTextField.isHidden = true
        }else {
            profileModifyView.nicknameTextField.layer.borderColor = UIColor.grey400?.cgColor
            profileModifyView.nicknameTextField.textColor = .grey600
            profileModifyView.nicknameErrorText.isHidden = true
            
            profileModifyView.selfPRTextField.layer.borderColor = UIColor.grey400?.cgColor
            profileModifyView.selfPRTextField.textColor = .grey600
            profileModifyView.selfPRErrorText.isHidden = true
        }
    }
    
    @objc
    private func nicknameTextFieldInput() {
        profileModifyView.nicknameTextField.layer.borderColor = UIColor.dmrBlue?.cgColor
        profileModifyView.nicknameTextField.textColor = .dmrBlue
        profileModifyView.nicknameErrorText.isHidden = true
    }
    
    @objc
    private func selfPRTextFieldInput() {
        profileModifyView.selfPRTextField.layer.borderColor = UIColor.dmrBlue?.cgColor
        profileModifyView.selfPRTextField.textColor = .dmrBlue
        profileModifyView.selfPRErrorText.isHidden = true
    }
    
    @objc
    private func addBtnDidTap() {
        profileModifyView.alert.isHidden = false
        profileModifyView.blurBackgroundView.isHidden = false
    }
    
    @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        // 터치한 위치 가져오기
        let touchPoint = sender.location(in: tappedView)
        
        // 이미지를 절반으로 나누기
        let halfHeight = tappedView.bounds.height / 2
        
        if touchPoint.y <= halfHeight {
            // 윗부분 터치시 갤러리 접근
        } else {
            // 아랫부분 터치시 카메라 접근
        }
    }
    
    // alert 창 떠 있는 상태에서 다른 뷰를 누를때
    @objc
    private func viewDidTap() {
        if profileModifyView.alert.isHidden == false {
            profileModifyView.alert.isHidden = true
            profileModifyView.blurBackgroundView.isHidden = true
        }
    }
    
    // ✅ 프로필 수정 요청
    func editProfile(profileData: EditProfileRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.EditProfile(profileData: profileData)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<Bool>.self)
                    if decodedResponse.isSuccess {
                        print("프로필 수정 성공")
                        completion(true)
                    } else {
                        print("프로필 수정 실패: \(decodedResponse.message)")
                        completion(false)
                    }
                } catch {
                    print("JSON 디코딩 오류: \(error.localizedDescription)")
                    completion(false)
                }
            case .failure(let error):
                print("API 요청 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    //완료버튼 누르면 저장됨
    @objc private func saveProfile() {
        guard let nickname = profileModifyView.nicknameTextField.text, !nickname.isEmpty,
              let introduction = profileModifyView.selfPRTextField.text, !introduction.isEmpty else {
            print("입력값을 확인하세요")
            return
        }
        
        let profileData = EditProfileRequest(
            memberProfileImageURL: "https://your-image-url.com", //실제 이미지 업로드 후 URL 적용해야 함
            nickname: nickname,
            introduction: introduction
        )
        
        //`MoyaProvider`를 직접 호출하여 API 요청
        provider.request(.EditProfile(profileData: profileData)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<Bool>.self)
                    if decodedResponse.isSuccess {
                        print("✅ 프로필 업데이트 성공")
                        DispatchQueue.main.async {
                            self.dismiss(animated: true)
                        }
                    } else {
                        print("❌ 프로필 업데이트 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ API 요청 실패: \(error.localizedDescription)")
            }
        }
    }
}

