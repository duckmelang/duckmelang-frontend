//
//  HomeViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    //FIXME: - api로 수정 필요
    let postsData = PostModel.dummy1()

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedCeleb = selectedCeleb {
            homeView.celebNameLabel.text = selectedCeleb.name
        }
        self.navigationController?.isNavigationBarHidden = true
        homeView.postsTableView.isHidden = false
        homeView.postsTableView.reloadData() // 데이터를 다시 불러오기
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
        
        isSelectionOpen = true
        homeView.updateChevronIcon(isExpanded: true)
        
        selectionVC.dismissCompletion = { [weak self] in
            self?.isSelectionOpen = false
            self?.homeView.updateChevronIcon(isExpanded: false)
        }

        present(selectionVC, animated: true)
    }
    
    @objc private func bellIconTapped() {
        print("🔔 Bell icon tapped!")
    }

    @objc private func findIconTapped() {
        print("🔍 Find icon tapped!")
    }

    @objc private func writeButtonTapped() {
        print("📝 Write button tapped!")
        let writeVC = WriteViewController()
        writeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(writeVC, animated: true)
    }
}

// MARK: - Delegate
extension HomeViewController: CelebSelectionDelegate {
    func didSelectCeleb(_ celeb: Celeb) {
        selectedCeleb = celeb
        homeView.celebNameLabel.text = celeb.name
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(model: postsData[indexPath.row])
        return cell
    }
}


extension HomeViewController: WriteViewControllerDelegate {
    func didUpdateSelectedCeleb(_ celeb: Celeb?) {
        if let celeb = celeb {
            selectedCeleb = celeb
            homeView.celebNameLabel.text = celeb.name
        }
    }
}
