//
//  HomeViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit
import Moya

class HomeViewController: UIViewController {
    private let provider = MoyaProvider<HomeAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    // MARK: - 홈에 띄우는 게시물 데이터
    private var currentPostsData: [PostDTO] = []

    private lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()
    
    private var celebs: [idolDTO]?
    private var selectedCeleb: idolDTO?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        setupDelegate()
        setupActions()
        getIdolsAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedCeleb = selectedCeleb {
            homeView.celebNameLabel.text = selectedCeleb.idolName
        }
        self.navigationController?.isNavigationBarHidden = true
        homeView.postsTableView.isHidden = false
        homeView.postsTableView.reloadData() // 데이터를 다시 불러오기
        getIdolsAPI()
    }
    
    private func setupDelegate() {
        homeView.postsTableView.dataSource = self
        homeView.postsTableView.delegate = self
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCelebSelection))
        homeView.celebStack.addGestureRecognizer(tapGesture)
        
        homeView.bellIcon.addTarget(self, action: #selector(bellIconTapped), for: .touchUpInside)
        homeView.findIcon.addTarget(self, action: #selector(findIconTapped), for: .touchUpInside)
        homeView.writeButton.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func showCelebSelection() {
        let celebSelectionVC = CelebSelectionViewController(celebs: self.celebs ?? [], selectedCeleb: self.selectedCeleb)

        celebSelectionVC.delegate = self
        celebSelectionVC.modalPresentationStyle = .pageSheet
        
        if let sheet = celebSelectionVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(celebSelectionVC, animated: true)
    }
    
    @objc private func bellIconTapped() {
        navigateToNotice()
        print("🔔 notice icon tapped!")
    }

    @objc private func findIconTapped() {
        navigateToSearch()
        print("🔍 search icon tapped!")
    }

    @objc private func writeButtonTapped() {
        print("📝 Write button tapped!")
        let writeVC = WriteViewController()
        writeVC.celebs = self.celebs
        writeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(writeVC, animated: true)
    }
    
    //MARK: - navigate
    private func navigateToNotice(){
        let noticeVC = NoticeViewController()
        noticeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(noticeVC, animated: true)
    }
    
    private func navigateToSearch(){
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func getIdolsAPI() {
        provider.request(.getIdols) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<idolResponse>.self)
                guard let result = response?.result?.idolList else { return }
                
                self.celebs = result
                self.selectedCeleb = self.celebs?.first
                self.homeView.celebNameLabel.text = self.selectedCeleb?.idolName
                
                self.fetchPosts()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchPosts() {
        if let selectedCeleb = selectedCeleb {
            getIdolsPosts(selectedCeleb.idolId)
        } else {
            getPosts()
        }
    }
    
    private func getPosts() {
        provider.request(.getHomePosts(page: 0)) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<PostResponse>.self)
                guard let result = response?.result?.postList else { return }
                self.currentPostsData = result
                print("홈 게시글: \(self.currentPostsData)")
                
                DispatchQueue.main.async {
                    self.homeView.postsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getIdolsPosts(_ idolId: Int) {
        provider.request(.getIdolPosts(idolId: idolId, page: 0)) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<PostResponse>.self)
                guard let result = response?.result?.postList else { return }
                self.currentPostsData = result
                print("홈 게시글 데이터들: \(self.currentPostsData)")
                
                DispatchQueue.main.async {
                    self.homeView.postsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPostsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(model: currentPostsData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("📌 didSelectRowAt 호출됨 - IndexPath: \(indexPath.row)")

        let post = currentPostsData[indexPath.row]  // 선택한 게시물 가져오기
           
        // PostDetailViewController로 postId 전달
        let VC = OtherPostDetailViewController()
        VC.postId = post.postId
        VC.modalPresentationStyle = .overFullScreen
        // ✅ 네비게이션 스택을 사용하여 푸시 (기존 present 방식에서 변경)
        present(VC, animated: true)
    }
}

extension HomeViewController: CelebSelectionDelegate {
    func didSelectCeleb(_ celeb: idolDTO) {
        selectedCeleb = celeb
        homeView.celebNameLabel.text = celeb.idolName
        fetchPosts()
    }
}

extension HomeViewController: WriteViewControllerDelegate {
    func didUpdateSelectedCeleb(_ celeb: idolDTO?) {
        if let celeb = celeb {
            selectedCeleb = celeb
            homeView.celebNameLabel.text = celeb.idolName
            fetchPosts()
        }
    }
}
