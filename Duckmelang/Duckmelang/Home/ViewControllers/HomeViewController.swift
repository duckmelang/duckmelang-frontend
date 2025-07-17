//
//  HomeViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit
import SwiftyToaster

class HomeViewController: UIViewController {
    let networkService = HomeService()
    let myNetworkService = MyPageService()
    
    // MARK: - 홈에 띄우는 게시물 데이터
    private var currentPostsData: [PostDTO] = []
    
    var myPostIdSet: Set<Int> = []

    private lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()
    
    private var celebs: [IdolListDTO]?
    private var selectedCeleb: IdolListDTO?
    
    var isLoading = false   // 중복 로딩 방지
    var totalPage = 0       // 마지막 페이지 번호
    var currentPage = 0     // 현재 페이지 번호

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        if let selectedCeleb = selectedCeleb {
            homeView.celebNameLabel.text = selectedCeleb.idolName
        } else {
            homeView.celebNameLabel.text = "모든 게시물 보기"
        }
        
        setupDelegate()
        setupActions()
        getMyPostId(startPage: 0)
        getIdolsAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedCeleb = selectedCeleb {
            homeView.celebNameLabel.text = selectedCeleb.idolName
        } else {
            homeView.celebNameLabel.text = "모든 게시물 보기"
        }
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
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
        let celebSelectionVC = CelebSelectionViewController(celebs: self.celebs ?? [], selectedCeleb: self.selectedCeleb, mode: .home)

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
    
    // 아이돌 목록 불러오기
    private func getIdolsAPI() {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getIdols()
                self.celebs = result.idolList
                self.fetchPosts(startPage: 0)
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast("아이돌 목록을 불러오지 못했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    private func fetchPosts(startPage: Int) {
        if let selectedCeleb = selectedCeleb {
            getIdolsPosts(idolId: selectedCeleb.idolId, startPage: startPage)
        } else {
            getAllPosts(startPage: startPage)
        }
    }
    
    private func getAllPosts(startPage: Int) {
        Task {
            do {
                self.isLoading = true
                startLoading()
                
                let result = try await networkService.getAllPosts(page: startPage)
                
                if (result.isFirst) {
                    self.currentPostsData = result.postList
                    self.totalPage = result.totalPage
                } else {
                    self.currentPostsData.append(contentsOf: result.postList)
                }
                self.currentPage = result.currentPage
                
                DispatchQueue.main.async {
                    self.homeView.empty.isHidden = !self.currentPostsData.isEmpty
                    self.homeView.postsTableView.reloadData()
                }
                
                stopLoading()
                isLoading = false
            }
            catch {
                stopLoading()
                isLoading = false
                print(error.localizedDescription)
                Toaster.shared.makeToast("게시물 목록을 불러오지 못했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    private func getMyPostId(startPage: Int) {
        _Concurrency.Task {
            do {
                let result = try await myNetworkService.getMyPosts(page: startPage)

                // postId 누적
                let ids = result.postList.map { $0.postId }
                self.myPostIdSet.formUnion(ids)

                if result.isFirst {
                    self.currentPostsData = result.postList
                    self.totalPage = result.totalPage
                } else {
                    self.currentPostsData.append(contentsOf: result.postList)
                }
                self.currentPage = result.currentPage

                // 다음 페이지 있는 경우 재귀 호출
                if self.currentPage + 1 < self.totalPage {
                    self.getMyPostId(startPage: self.currentPage + 1)
                }

            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getIdolsPosts(idolId: Int, startPage: Int) {
        Task {
            do {
                self.isLoading = true
                startLoading()
                
                let result = try await networkService.getIdolPosts(idolId: idolId, page: startPage)
                
                if (result.isFirst) {
                    self.currentPostsData = result.postList
                    self.totalPage = result.totalPage
                } else {
                    self.currentPostsData.append(contentsOf: result.postList)
                }
                self.currentPage = result.currentPage
                
                DispatchQueue.main.async {
                    self.homeView.empty.isHidden = !self.currentPostsData.isEmpty
                    self.homeView.postsTableView.reloadData()
                }
                
                stopLoading()
                isLoading = false
            }
            catch {
                stopLoading()
                isLoading = false
                print(error.localizedDescription)
                Toaster.shared.makeToast("게시물 목록을 불러오지 못했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    func didSelectPost(_ post: PostDTO) {
        if myPostIdSet.contains(post.postId) {
            let vc = PostDetailViewController()
            vc.postId = post.postId
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = OtherPostDetailViewController()
            vc.postId = post.postId
            navigationController?.pushViewController(vc, animated: true)
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
        guard indexPath.row < currentPostsData.count else {
            print("indexPath.row 초과")
            return
        }
        print("📌 didSelectRowAt 호출됨 - IndexPath: \(indexPath.row)")

        let post = currentPostsData[indexPath.row]  // 선택한 게시물 가져오기
           
        didSelectPost(post)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight {
            guard !isLoading, currentPage + 1 < totalPage else { return }
            fetchPosts(startPage: currentPage + 1)
        }
    }
}

extension HomeViewController: CelebSelectionDelegate {
    func didTapIdolAdd() {
        
    }
    
    func didSelectCeleb(_ celeb: IdolListDTO?) {
        selectedCeleb = celeb
        homeView.celebNameLabel.text = celeb?.idolName ?? "모든 게시물 보기"
        fetchPosts(startPage: 0)
    }
}

extension HomeViewController: WriteViewControllerDelegate {
    func didUpdateSelectedCeleb(_ celeb: IdolListDTO?) {
        if let celeb = celeb {
            selectedCeleb = celeb
            homeView.celebNameLabel.text = celeb.idolName
            fetchPosts(startPage: 0)
        }
    }
}
