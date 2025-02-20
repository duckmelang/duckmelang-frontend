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

class WriteViewController: UIViewController, WriteViewDelegate, CelebSelectionDelegate, EventSelectionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let provider = MoyaProvider<HomeAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    weak var delegate: WriteViewControllerDelegate?
    
    var celebs: [idolDTO]?
    
    private var selectedImage: UIImage?
    private var selectedTitle: String = ""
    private var selectedContent: String = ""
    private var selectedCeleb: idolDTO?
    private var selectedEvent: Event?
    private var selectedDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        writeView.uploadButton.setEnabled(true)
    }
    
    private lazy var writeView: WriteView = {
        let view = WriteView()
        
        view.delegate = self
        view.idolSelectButton.addTarget(self, action: #selector(didTapIdolSelectButton), for: .touchUpInside)
        view.eventTypeSelectButton.addTarget(self, action: #selector(didTapEventTypeSelectButton), for: .touchUpInside)
        view.eventDateSelectButton.addTarget(self, action: #selector(didTapEventDateSelectButton), for: .touchUpInside)
        view.uploadImageView.addTarget(self, action: #selector(didTapImageView), for: .touchUpInside)
        view.uploadButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        
        return view
    }()
    
    private func setupNavigationBar() {
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
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // HomeViewController에 selectedCeleb 값 전달
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.didUpdateSelectedCeleb(selectedCeleb)
        }
    }

    @objc func didTapIdolSelectButton() {
        let selectVC = CelebSelectionViewController(celebs: celebs ?? [], selectedCeleb: self.selectedCeleb)
        selectVC.delegate = self
        presentBottomSheet(selectVC)
    }
    
    @objc func didTapEventTypeSelectButton() {
        let selectVC = EventSelectionViewController(
            selectedEvent: selectedEvent
        )
        selectVC.delegate = self
        presentBottomSheet(selectVC)
    }
    
    @objc func didTapEventDateSelectButton() {
        showDatePicker()
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
    
    @objc private func didTapImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    // ✅ 사용자가 사진을 선택했을 때 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            writeView.backgroundView.image = selectedImage // ✅ 이미지뷰에 표시
        }
        picker.dismiss(animated: true)
    }

    // ✅ 사용자가 사진 선택을 취소했을 때
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func showDatePicker() {
        let alertController = UIAlertController(title: "날짜 선택", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.frame = CGRect(x: 10, y: 50, width: 260, height: 150)

        alertController.view.addSubview(datePicker)

        let selectAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.updateSelectedDate(datePicker.date)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    private func updateSelectedDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let selectedDate = dateFormatter.string(from: date)

        writeView.eventDateSelectButton.setTitle(selectedDate, for: .normal)
        writeView.eventDateSelectButton.setTitleColor(.black, for: .normal)
        writeView.eventDateSelectButton.layer.borderColor = UIColor.black!.cgColor
        
        self.selectedDate = selectedDate
    }
    
    private func updatePostButtonState() {
        let isFormComplete = selectedImage != nil &&
                             !selectedTitle.isEmpty &&
                             !selectedContent.isEmpty &&
                             selectedCeleb != nil &&
                             selectedEvent != nil &&
                             selectedDate != nil
                             
        writeView.uploadButton.setEnabled(isFormComplete)
    }
    
    @objc private func didTapPostButton() {
        guard let celeb = selectedCeleb,
              let event = selectedEvent,
              let date = selectedDate,
              let image = selectedImage else {
            print("선택되지않음")
            print(selectedCeleb)
            print(selectedEvent)
            print(selectedDate)
            print(selectedImage)
            return
        }

        let postRequest = PostRequest(
            title: selectedTitle,
            content: selectedContent,
            idolIds: [celeb.idolId],
            categoryId: event.id,
            date: date,
            imageInfos: [ImageInfo(orderNumber: 0, description: "example")]
        )

        provider.request(.postPosts(postRequest: postRequest, images: image)) { result in
            switch result {
            case .success:
                print("✅ 게시물 등록 성공")
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("❌ 게시물 등록 실패: \(error.localizedDescription)")
            }
        }
    }

    func didSelectCeleb(_ celeb: idolDTO) {
        selectedCeleb = celeb
        writeView.idolSelectButton.setTitle(celeb.idolName, for: .normal)
        writeView.idolSelectButton.setTitleColor(.black, for: .normal)
        writeView.idolSelectButton.layer.borderColor = UIColor.black!.cgColor
    }
    
    func didSelectEvent(_ event: Event) {
        selectedEvent = event
        writeView.eventTypeSelectButton.setTitle(event.tag.rawValue, for: .normal)
        writeView.eventTypeSelectButton.setTitleColor(.black, for: .normal)
        writeView.eventTypeSelectButton.layer.borderColor = UIColor.black!.cgColor
    }
}
