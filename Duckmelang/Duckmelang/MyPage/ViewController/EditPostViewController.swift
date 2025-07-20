//
//  PostModifyViewController.swift
//  Duckmelang
//
//  Created by nau on 7/16/25.
//

import UIKit
import PhotosUI
import Moya
import Kingfisher
import SwiftyToaster

protocol EditPostViewControllerDelegate: AnyObject {
    func didUpdateSelectedCeleb(_ celeb: IdolListDTO?)
}

class EditPostViewController: UIViewController, EditPostViewDelegate, EventSelectionViewControllerDelegate, DateSelectionViewControllerDelegate, CelebSelectionDelegate {
    
    func didTapIdolAdd() {
        let vc = HomeIdolAddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    let networkService = HomeService()
    let myNetworkService = MyPageService()
    
    weak var delegate: WriteViewControllerDelegate?
    var textViewPlaceHolder = "본문"
    var celebs: [IdolListDTO]?
    var events: [EventDTO] = []
    private var selectedImages : [UIImage] = []
    
    private var selectedTitle: String = ""
    private var selectedContent: String = ""
    private var selectedCeleb: IdolListDTO?
    private var selectedEvent: EventDTO?
    private var selectedDate: String?
    
    var postId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editPostView
        
        editPostView.contentView.isHidden = true
        fetchIdolsAndEvents()
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
    
    private lazy var editPostView = EditPostView()

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // ✅ 다른 터치 이벤트도 가능하게 설정
        view.addGestureRecognizer(tapGesture)
        
        editPostView.idolSelectButton.addTarget(self, action: #selector(didTapIdolSelectButton), for: .touchUpInside)
        editPostView.eventTypeSelectButton.addTarget(self, action: #selector(didTapEventTypeSelectButton), for: .touchUpInside)
        editPostView.eventDateSelectButton.addTarget(self, action: #selector(didTapEventDateSelectButton), for: .touchUpInside)
        editPostView.uploadImageView.addTarget(self, action: #selector(didTapImageView), for: .touchUpInside)
        editPostView.uploadButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        editPostView.navibar.setLeftButtonAction(target: self, action: #selector(goBack))
    }
    
    private func setupDelegates() {
        editPostView.delegate = self
        editPostView.titleTextField.delegate = self
        editPostView.contentTextView.delegate = self
        editPostView.imageCollectionView.delegate = self
        editPostView.imageCollectionView.dataSource = self
    }
    
    // MARK: - Actions
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // 현재 편집 중인 뷰의 키보드를 내림
    }
    
    // 이미지 선택 버튼을 누르면 동작하는 함수
    @objc private func didTapImageView() {
        print("didTappedSelectedImages - called()")
        
        // PHPickerConfiguration 설정
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5   // 선택 가능한 이미지 또는 영상 개수
        configuration.filter = .any(of: [.images])   // 이미지 선택 가능
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // 아이돌 선택
    @objc func didTapIdolSelectButton() {
        let selectVC = CelebSelectionViewController(celebs: celebs ?? [], selectedCeleb: self.selectedCeleb, mode: .write)
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
        _Concurrency.Task {
            do {
                startLoading()
                guard let celeb = selectedCeleb,
                      let event = selectedEvent,
                      let date = selectedDate else {
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
                for (index, image) in selectedImages.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.2) {
                        formData.append(MultipartFormData(provider: .data(imageData),
                                                          name: "images",
                                                          fileName: "image\(index).jpg",
                                                          mimeType: "image/jpeg")
                        )
                    }
                }
                
                let _ = try await networkService.patchPosts(postId: self.postId!, formData: formData)
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchIdolsAndEvents() {
        _Concurrency.Task {
            do {
                startLoading()
                let idols = try await myNetworkService.getIdolList().idolList
                let events = try await networkService.getEvents().eventCategoryList
               
                self.events = events
                self.celebs = idols
                
                self.fetchPostDetail()
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchPostDetail() {
        guard let postId = postId else { return }

        _Concurrency.Task {
            do {
                let detail = try await myNetworkService.getMyPostDetail(postId: postId)
                
                // 뷰 업데이트
                DispatchQueue.main.async {
                    self.updateEditView(with: detail)
                }
                
                editPostView.contentView.isHidden = false
            } catch {
                print("게시글 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }

    private func updateEditView(with detail: MyPostDetailResponse) {
        // 텍스트 관련
        self.selectedTitle = detail.title
        self.selectedContent = detail.content
        self.editPostView.titleTextField.text = detail.title
        self.editPostView.contentTextView.text = detail.content

        if let idol = celebs?.first(where: { $0.idolName == detail.idol.first }) {
            self.selectedCeleb = idol
            self.didSelectCeleb(idol)
        } else {
            print("해당 아이돌 이름과 일치하는 아이돌이 없습니다.")
        }
    
    
        if let matched = events.first(where: { $0.eventName == detail.category }) {
            self.selectedEvent = matched
            self.didSelectEvent(matched) // 버튼 스타일까지 함께 적용
        } else {
            print("해당 카테고리 이름과 일치하는 이벤트가 없습니다.")
        }
        
        // 날짜
        self.selectedDate = detail.date
        if let selectedDate = selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: selectedDate)
            self.updateSelectedDate(date!)
        }
        
        // 이미지들
        self.selectedImages = [] // 초기화 후 다시 추가
        for urlString in detail.postImageUrl {
            if let url = URL(string: urlString) {
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        self.selectedImages.append(value.image)
                        DispatchQueue.main.async {
                            self.editPostView.imageCollectionView.reloadData()
                        }
                    case .failure(let error):
                        print("이미지 로딩 실패: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        checkAllFieldsFilled()
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
        if !selectedImages.isEmpty,
           !selectedTitle.isEmpty,
           !selectedContent.isEmpty,
           selectedCeleb != nil,
           selectedEvent != nil,
           selectedDate != nil {
            editPostView.uploadButton.setEnabled(true)
        } else {
            editPostView.uploadButton.setEnabled(false)
        }
    }
    
    // 아이돌 선택 - CelebSelectionDelegate
    func didSelectCeleb(_ celeb: IdolListDTO?) {
        self.selectedCeleb = celeb
        editPostView.idolSelectButton.setTitle(celeb?.idolName, for: .normal)
        editPostView.idolSelectButton.setTitleColor(.grey800, for: .normal)
        editPostView.idolSelectButton.layer.borderColor = UIColor.grey600!.cgColor
        checkAllFieldsFilled()
    }
    
    // 이벤트 선택 - EventSelectionViewControllerDelegate
    func didSelectEvent(_ event: EventDTO) {
        self.selectedEvent = event
        editPostView.eventTypeSelectButton.setTitle(event.eventName, for: .normal)
        editPostView.eventTypeSelectButton.setTitleColor(.grey800, for: .normal)
        editPostView.eventTypeSelectButton.layer.borderColor = UIColor.grey600!.cgColor
        checkAllFieldsFilled()
    }
    
    // 날짜 선택 - DateSelectionViewControllerDelegate
    func updateSelectedDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: date)
        
        self.selectedDate = selectedDate
        editPostView.eventDateSelectButton.setTitle(selectedDate, for: .normal)
        editPostView.eventDateSelectButton.setTitleColor(.grey800, for: .normal)
        editPostView.eventDateSelectButton.layer.borderColor = UIColor.grey600!.cgColor
        
        checkAllFieldsFilled()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width )
        editPostView.pageControl.currentPage = page
    }
}

extension EditPostViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedTitle = textField.text ?? ""
        checkAllFieldsFilled()
    }
}

extension EditPostViewController: UITextViewDelegate {
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

extension EditPostViewController: WriteViewDelegate {
    func didTapSelectedImageButton() {
        print("Delegate called: Button tapped.")
        presentImagePicker()
    }
}

// MARK: - PHPicker 관련 기능
extension EditPostViewController: PHPickerViewControllerDelegate {

    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let dispatchGroup = DispatchGroup()
        var newImages: [UIImage] = []
        
        let availablesSlots = max(0, 10 - selectedImages.count)
        if availablesSlots == 0 {
            Toaster.shared.makeToast("사진은 최대 10장까지입니다.")
            return
        }
        
        for result in results {
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                defer { dispatchGroup.leave() }
                
                if let image = object as? UIImage {
                    newImages.append(image)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // 기존 이미지에 추가로 붙임
            self.selectedImages.append(contentsOf: newImages)
            
            // UI 갱신
            self.editPostView.imageCollectionView.reloadData()
            self.editPostView.pageControl.numberOfPages = self.selectedImages.count
            self.editPostView.pageControl.currentPage = 0
            self.editPostView.imageCountLabel.text = "\(self.selectedImages.count)/10"
            
            // 버튼 활성화 체크 등
            self.checkAllFieldsFilled()
        }
    }
}

extension EditPostViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteImageCell.identifier, for: indexPath) as? WriteImageCell else {
            return UICollectionViewCell()
        }
        
        let image = selectedImages[indexPath.item]
        
        
        cell.configure(image: image) {
            let currentPage = Int(self.editPostView.imageCollectionView.contentOffset.x / self.editPostView.imageCollectionView.frame.width)
            
            self.selectedImages.remove(at: indexPath.item)
            
            let newPage = min(currentPage, self.selectedImages.count - 1)
            
            self.editPostView.imageCollectionView.reloadData()
            self.editPostView.pageControl.numberOfPages = self.selectedImages.count
            self.editPostView.pageControl.currentPage = max(newPage, 0)
            
            let offset = CGFloat(newPage) * self.editPostView.imageCollectionView.frame.width
            self.editPostView.imageCollectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            
            self.editPostView.imageCountLabel.text = "\(self.selectedImages.count)/10"
        }
        
        return cell
    }
}

