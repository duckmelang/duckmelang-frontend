//
//  PostDetailViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

//버튼 상태
enum PostProgressState {
    case inProgress
    case progressTap(progressing: Bool) // 진행 중이면 true, 완료 상태면 false
    case completed
}

class PostDetailViewController: UIViewController {
    var postId: Int?  // 전달받을 게시물 ID
    
    var data = PostDetailAccompanyModel.dummy()
    
    private var accompanyData: [PostDetailAccompanyModel] = [] // 동행 정보 데이터
    
    private var currentState: PostProgressState = .inProgress
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = postDetailView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        
        updateButtonVisibility(state: .inProgress) // 초기 상태 설정
        
        // ✅ postId가 nil이 아니면 API 요청
        if let postId = postId {
            fetchPostDetail(postId: postId)
        } else {
            print("❌ postId가 nil입니다. API 호출을 하지 않습니다.")
        }
    }
    
    private lazy var postDetailView = PostDetailView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.postDetailTopView.progressBtn.addTarget(self, action: #selector(progressBtnDidTap), for: .touchUpInside)
        $0.postDetailTopView.progressTapBtn.addTarget(self, action: #selector(topTitleDidTap), for: .touchUpInside)//버튼의 title 클릭시 topTitleDidTap()작동, subtitle 클릭시 bottomTitleDidTap()작동
        $0.postDetailTopView.endBtn.addTarget(self, action: #selector(endBtnDidTap), for: .touchUpInside)
        
        // 진행 Tap 버튼에 터치 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnProgressTapBtn(_:)))
        $0.postDetailTopView.progressTapBtn.addGestureRecognizer(tapGesture)
    }

    private var buttons: [UIButton] {
        return [postDetailView.postDetailTopView.progressBtn,
                postDetailView.postDetailTopView.progressTapBtn,
                postDetailView.postDetailTopView.endBtn]
    }
    
    @objc private func backBtnDidTap() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true) // ✅ 네비게이션이 있을 경우 pop 사용
        } else {
            dismiss(animated: true) // ✅ 네비게이션이 없으면 dismiss
        }
    }

    
    // 버튼 상태 업데이트 함수
    private func updateButtonVisibility(state: PostProgressState) {
        buttons.forEach { $0.isHidden = true }
        
        currentState = state
       
        switch state {
        case .inProgress:
            postDetailView.postDetailTopView.progressBtn.isHidden = false
        case .progressTap(let progressing):
            postDetailView.postDetailTopView.progressTapBtn.isHidden = false
            updateProgressTapButtonStyle(progressing: progressing)
        case .completed:
            postDetailView.postDetailTopView.endBtn.isHidden = false
        }
    }
    
    // 진행 Tap 버튼을 눌렀을 때 터치 위치 판별 (윗쪽/아랫쪽)
    @objc private func handleTapOnProgressTapBtn(_ sender: UITapGestureRecognizer) {
        let button = postDetailView.postDetailTopView.progressTapBtn
        let touchPoint = sender.location(in: button) // 터치한 위치 가져오기
        
        // 진행 중일 때 클릭 시 완료 버튼이 아래, 완료일 때 클릭 시 진행 중 버튼이 아래
        switch currentState {
        /*case .progressTap(let progressing):
            if touchPoint.y <= (button.bounds.height / 2) {
                updateButtonVisibility(state: progressing ? .inProgress : .completed)
            } else {
                updateButtonVisibility(state: progressing ? .completed : .inProgress)
            }
        default:
            break
        }*/
        
        case .progressTap(let progressing):
            let newState: PostProgressState = touchPoint.y <= (button.bounds.height / 2) ? (progressing ? .inProgress : .completed) : (progressing ? .completed : .inProgress)
    
            updateButtonVisibility(state: newState)
        default:
            break
        }
    }
  
    // 진행 Tap 버튼 스타일 업데이트 (진행 중 vs 완료 상태에 따라 변경)
    private func updateProgressTapButtonStyle(progressing: Bool) {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        if progressing {
            // 진행 중 상태일 때 → 완료가 아래쪽
            config.attributedTitle = AttributedString("진행 중", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey800!]))
            config.attributedSubtitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey500!]))
        } else {
            // 완료 상태일 때 → 진행 중이 아래쪽
            config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey800!]))
            config.attributedSubtitle = AttributedString("진행 중", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey500!]))
        }
        
        config.titleAlignment = .center
        config.titlePadding = 12
        postDetailView.postDetailTopView.progressTapBtn.configuration = config
    }
    
    @objc private func progressBtnDidTap() {
        updateButtonVisibility(state: .progressTap(progressing: true))
    }
    
    
    @objc
    private func topTitleDidTap() {
        updateButtonVisibility(state: .inProgress)
    }
    
    @objc
    private func endBtnDidTap() {
        updateButtonVisibility(state: .progressTap(progressing: false))
    }

    private func setupDelegate() {
        postDetailView.postDetailBottomView.tableView.delegate = self
        postDetailView.postDetailBottomView.tableView.dataSource = self
    }
    
    private func fetchPostDetail(postId: Int) {
        provider.request(.getMyPostDetail(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<MyPostDetailResponse>.self)
                    if decodedResponse.isSuccess {
                        guard let postDetail = decodedResponse.result else { return }
                        DispatchQueue.main.async {
                            self.postDetailView.updateUI(with: postDetail)
                            self.updateAccompanyData(with: postDetail)
                        }
                        // ✅ 성공 시 데이터 출력
                        print("Post Detail: \(String(describing: decodedResponse.result))")
                    } else {
                        print("❌ 서버 에러: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 실패: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func patchPostStatus() {
        guard let postId = postId else {
            print("❌ postId가 없습니다.")
            return
        }
        
        provider.request(.patchPostStatus(postId: postId)) { result in
            switch result {
            case .success(let response):
                // ✅ 서버 응답 로그 출력
                if let responseString = String(data: response.data, encoding: .utf8) {
                    print("📌 [DEBUG] 서버 응답 바디: \(responseString)")
                }

                do {
                    // ✅ `ApiResponse<UpdatePostStatusResponse>`으로 디코딩
                    let decodedResponse = try response.map(ApiResponse<UpdatePostStatusResponse>.self)
                    
                    if decodedResponse.isSuccess, let updatedPost = decodedResponse.result {
                        print("✅ 게시글 상태 변경 성공: \(decodedResponse.message)")
                        print("📝 변경된 상태 - ID: \(updatedPost.id), 제목: \(updatedPost.title), 모집 상태: \(updatedPost.wanted)")

                        // ✅ 변경된 상태를 UI에 반영
                        /*DispatchQueue.main.async {
                            self.updateBtn(with: updatedPost)
                        }*/
                    } else {
                        print("❌ 상태 변경 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
            }
        }
    }


    
    // 동행 정보 데이터 가공
    private func updateAccompanyData(with detail: MyPostDetailResponse) {
        var models: [PostDetailAccompanyModel] = []
        
        models.append(PostDetailAccompanyModel(title: "아이돌", info: detail.idol.joined(separator: ", ")))
        models.append(PostDetailAccompanyModel(title: "행사 종류", info: detail.category))
        models.append(PostDetailAccompanyModel(title: "행사 날짜", info: detail.date))
        
        self.accompanyData = models
        self.postDetailView.postDetailBottomView.tableView.reloadData()
    }
    
    /*private func updateBtn(with data: UpdatePostStatusResponse) {
        // wanted == 0 → 모집 완료, wanted == 1 → 모집 중
        let state = data.wanted == 0 ? PostProgressState.completed : PostProgressState.inProgress
        updateButtonVisibility(state: state)
    }*/
}

extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accompanyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailAccompanyCell.identifier, for: indexPath) as? PostDetailAccompanyCell else {
            return UITableViewCell()
        }
        
        cell.configure(model: accompanyData[indexPath.row])
        return cell
    }
}
