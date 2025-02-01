//
//  HomeViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    //FIXME: - 동적 모델로 수정 필요
    let celebData1 = PostModel.dummyBlackPink()
    let celebData2 = PostModel.dummyRiize()
    let celebData3 = PostModel.dummyNewJeans()
    
    private var currentPostsData: [PostModel] = []

    private lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()
    
    private var selectedCeleb: Celeb?
    private var isSelectionOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        setupDelegate()
        setupActions()
        
        //FIXME: - 기본 아이돌 설정 (현재:블랙핑크)
        selectedCeleb = Celeb.dummy1().first
        homeView.celebNameLabel.text = selectedCeleb?.name
                
        updatePostsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedCeleb = selectedCeleb {
            homeView.celebNameLabel.text = selectedCeleb.name
        }
        self.navigationController?.isNavigationBarHidden = true
        homeView.postsTableView.isHidden = false
        homeView.postsTableView.reloadData() // 데이터를 다시 불러오기
        
        updatePostsData()
    }
    
    private func setupDelegate() {
        homeView.postsTableView.dataSource = self
        homeView.postsTableView.delegate = self
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCelebSelection))
        homeView.celebNameLabel.addGestureRecognizer(tapGesture)
        
        homeView.bellIcon.addTarget(self, action: #selector(bellIconTapped), for: .touchUpInside)
        homeView.findIcon.addTarget(self, action: #selector(findIconTapped), for: .touchUpInside)
        homeView.writeButton.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
        }

    @objc private func showCelebSelection() {
        let selectionVC = CelebSelectionViewController(
            celebs: homeView.celebs,
            selectedCeleb: selectedCeleb
        )
        selectionVC.delegate = self
        selectionVC.modalPresentationStyle = .pageSheet

        if let sheet = selectionVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(selectionVC, animated: true)
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
    
    //FIXME: - post data 동적 수정 필요
    private func updatePostsData() {
        guard let selectedCeleb = selectedCeleb else { return }

        if selectedCeleb.name == "블랙핑크" {
            currentPostsData = celebData1
        } else if selectedCeleb.name == "라이즈" {
            currentPostsData = celebData2
        } else if selectedCeleb.name == "뉴진스" {
            currentPostsData = celebData3
        } else {
            currentPostsData = [] // 다른 아이돌 선택 시 빈 배열
        }
        
        homeView.postsTableView.reloadData()
    }
}

// MARK: - Delegate
extension HomeViewController: CelebSelectionDelegate {
    func didSelectCeleb(_ celeb: Celeb) {
        selectedCeleb = celeb
        homeView.celebNameLabel.text = celeb.name
        updatePostsData()
    }
}

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
}


extension HomeViewController: WriteViewControllerDelegate {
    func didUpdateSelectedCeleb(_ celeb: Celeb?) {
        if let celeb = celeb {
            selectedCeleb = celeb
            homeView.celebNameLabel.text = celeb.name
            updatePostsData()
        }
    }
}
