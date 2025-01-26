//
//  HomeViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class HomeViewController: UIViewController {

    private lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()
    
    private var selectedCeleb: Celeb?
    private var isSelectionOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(showCelebSelection)
        )
        homeView.celebNameLabel.addGestureRecognizer(tapGesture)
        
        homeView.bellIcon
            .addTarget(
                self,
                action: #selector(bellIconTapped),
                for: .touchUpInside
            )
        homeView.findIcon
            .addTarget(
                self,
                action: #selector(findIconTapped),
                for: .touchUpInside
            )
        homeView.writeButton
            .addTarget(
                self,
                action: #selector(writeButtonTapped),
                for: .touchUpInside
            )
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

// MARK: - CelebSelectionDelegate
extension HomeViewController: CelebSelectionDelegate {
    func didSelectCeleb(_ celeb: Celeb) {
        selectedCeleb = celeb
        homeView.celebNameLabel.text = celeb.name
    }
}
