//
//  PostDetailViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

//버튼 상태

class OtherPostDetailViewController: UIViewController {
    var postId: Int?  // 전달받을 게시물 ID
    
    var data = PostDetailAccompanyModel.dummy()
    
    private var accompanyData: [PostDetailAccompanyModel] = [] // 동행 정보 데이터

    private let provider = MoyaProvider<MyPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = otherPostDetailView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
 
        // ✅ postId가 nil이 아니면 API 요청
        if let postId = postId {
            fetchPostDetail(postId: postId)
        } else {
            print("❌ postId가 nil입니다. API 호출을 하지 않습니다.")
        }
    }
    
    private lazy var otherPostDetailView = OtherPostDetailView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }

    @objc private func backBtnDidTap() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true) // ✅ 네비게이션이 있을 경우 pop 사용
        } else {
            dismiss(animated: true) // ✅ 네비게이션이 없으면 dismiss
        }
    }

    private func setupDelegate() {
        otherPostDetailView.postDetailBottomView.tableView.delegate = self
        otherPostDetailView.postDetailBottomView.tableView.dataSource = self
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
                            self.otherPostDetailView.updateUI(with: postDetail)
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
    
   
    
    // 동행 정보 데이터 가공
    private func updateAccompanyData(with detail: MyPostDetailResponse) {
        var models: [PostDetailAccompanyModel] = []
        
        models.append(PostDetailAccompanyModel(title: "아이돌", info: detail.idol.joined(separator: ", ")))
        models.append(PostDetailAccompanyModel(title: "행사 종류", info: detail.category))
        models.append(PostDetailAccompanyModel(title: "행사 날짜", info: detail.date))
        
        self.accompanyData = models
        self.otherPostDetailView.postDetailBottomView.tableView.reloadData()
    }
}

extension OtherPostDetailViewController: UITableViewDataSource, UITableViewDelegate {
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
