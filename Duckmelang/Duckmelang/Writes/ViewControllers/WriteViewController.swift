//
//  WriteViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit
import Moya

protocol WriteViewControllerDelegate: AnyObject {
    func didUpdateSelectedCeleb(_ celeb: idolDTO?)
}

class WriteViewController: UIViewController, WriteViewDelegate, CelebSelectionDelegate, EventSelectionViewControllerDelegate, DateSelectionViewControllerDelegate {
    private let provider = MoyaProvider<HomeAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    weak var delegate: WriteViewControllerDelegate?
    var textViewPlaceHolder = "본문"
    var celebs: [idolDTO]?
    
    private var selectedImage: UIImage?
    private var selectedTitle: String = ""
    private var selectedContent: String = ""
    private var selectedCeleb: idolDTO?
    private var selectedEvent: EventDTO?
    private var selectedDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        setupUI()
        setupActions()
        setupDelegates()
    }
    
    // HomeViewController에 selectedCeleb 값 전달
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.didUpdateSelectedCeleb(selectedCeleb)
        }
    }
    
    private lazy var writeView: WriteView = {
        let view = WriteView()
        return view
    }()
    
    // MARK: - Setup
    private func setupUI() {
        setupNavigationBar()
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // ✅ 다른 터치 이벤트도 가능하게 설정
        view.addGestureRecognizer(tapGesture)
        
        writeView.idolSelectButton.addTarget(self, action: #selector(didTapIdolSelectButton), for: .touchUpInside)
        writeView.eventTypeSelectButton.addTarget(self, action: #selector(didTapEventTypeSelectButton), for: .touchUpInside)
        writeView.eventDateSelectButton.addTarget(self, action: #selector(didTapEventDateSelectButton), for: .touchUpInside)
        writeView.uploadImageView.addTarget(self, action: #selector(didTapImageView), for: .touchUpInside)
        writeView.uploadButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        writeView.delegate = self
        writeView.titleTextField.delegate = self
        writeView.contentTextView.delegate = self
    }
    
    private func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "글쓰기"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)
        ]
        
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    // MARK: - Actions
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // 현재 편집 중인 뷰의 키보드를 내림
    }
    
    // 이미지 선택
    @objc private func didTapImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // 아이돌 선택
    @objc func didTapIdolSelectButton() {
        let selectVC = CelebSelectionViewController(celebs: celebs ?? [], selectedCeleb: self.selectedCeleb)
        selectVC.delegate = self
        presentBottomSheet(selectVC)
    }
    
    // 이벤트 선택
    @objc func didTapEventTypeSelectButton() {
        let selectVC = EventSelectionViewController()
        selectVC.selectedEvent = selectedEvent
        selectVC.delegate = self
        presentBottomSheet(selectVC)
    }
    
    // 행사 날짜 선택
    @objc func didTapEventDateSelectButton() {
        let selectVC = DateSelectionViewController()
        selectVC.delegate = self

        if let selectedDate = selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: selectedDate)
            selectVC.selectedDate = date
        }
        
        presentBottomSheet(selectVC)
    }
    
    // 업로드 버튼
    @objc private func didTapPostButton() {
        guard let celeb = selectedCeleb,
              let event = selectedEvent,
              let date = selectedDate,
              let image = selectedImage else {
            print("선택되지않음")
            return
        }

        let postRequest = PostRequest(
            title: selectedTitle,
            content: selectedContent,
            idolIds: [celeb.idolId],
            categoryId: event.eventId,
            date: date,
            imageInfos: [ImageInfo(orderNumber: 1, description: "example")]
        )
        
        var formData: [MultipartFormData] = []

        // JSON 데이터 변환하여 `multipart/form-data`로 추가
        if let jsonData = try? JSONEncoder().encode(postRequest) {
            formData.append(MultipartFormData(provider: .data(jsonData),
                                              name: "request",
                                              mimeType: "application/json"))
        }

        // 이미지 추가 (여러 장 가능하도록 설정)
        if let imageData = image.jpegData(compressionQuality: 0.1) {
            formData.append(MultipartFormData(provider: .data(imageData),
                                              name: "images",
                                              fileName: "image.jpg",
                                              mimeType: "image/jpeg"))
        }
            
        provider.request(.postPosts(formData: formData)) { result in
            switch result {
            case .success(let response):
                print("✅ 성공: \(response.statusCode)")
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("❌ 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func presentBottomSheet(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(viewController, animated: true)
    }
    
    // 모든 필드가 채워졌는지 확인하는 함수
    func checkAllFieldsFilled() {
        if selectedImage != nil,
           !selectedTitle.isEmpty,
           !selectedContent.isEmpty,
           selectedCeleb != nil,
           selectedEvent != nil,
           selectedDate != nil {
            writeView.uploadButton.setEnabled(true)
        } else {
            writeView.uploadButton.setEnabled(false)
        }
    }
    
    // 아이돌 선택 - CelebSelectionDelegate
    func didSelectCeleb(_ celeb: idolDTO) {
        self.selectedCeleb = celeb
        writeView.idolSelectButton.setTitle(celeb.idolName, for: .normal)
        writeView.idolSelectButton.setTitleColor(.black, for: .normal)
        writeView.idolSelectButton.layer.borderColor = UIColor.black!.cgColor
        checkAllFieldsFilled()
    }
    
    // 이벤트 선택 - EventSelectionViewControllerDelegate
    func didSelectEvent(_ event: EventDTO) {
        self.selectedEvent = event
        writeView.eventTypeSelectButton.setTitle(event.eventName, for: .normal)
        writeView.eventTypeSelectButton.setTitleColor(.black, for: .normal)
        writeView.eventTypeSelectButton.layer.borderColor = UIColor.black!.cgColor
        checkAllFieldsFilled()
    }
    
    // 날짜 선택 - DateSelectionViewControllerDelegate
    func updateSelectedDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: date)
        
        self.selectedDate = selectedDate
        writeView.eventDateSelectButton.setTitle(selectedDate, for: .normal)
        writeView.eventDateSelectButton.setTitleColor(.black, for: .normal)
        writeView.eventDateSelectButton.layer.borderColor = UIColor.black!.cgColor
        
        checkAllFieldsFilled()
    }
}

extension WriteViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedTitle = textField.text ?? ""
        checkAllFieldsFilled()
    }
}

extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .grey500
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        selectedContent = textView.text ?? ""
        checkAllFieldsFilled()
    }
}

extension WriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            writeView.backgroundView.image = selectedImage
        }
        picker.dismiss(animated: true)
        checkAllFieldsFilled()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
