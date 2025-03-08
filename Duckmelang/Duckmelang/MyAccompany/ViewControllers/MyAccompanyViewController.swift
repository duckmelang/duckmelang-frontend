//
//  MyAccompanyViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/13/25.
//

import UIKit
import Moya

class MyAccompanyViewController: UIViewController {
    private var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myAccompanyView
        
        setupNavigationBar()
        setupAction()
        switchSegment(segment: myAccompanyView.segmentedControl)
    }
    
    private lazy var myAccompanyView: MyAccompanyView = {
        let view = MyAccompanyView()
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationItem.title = "나의 동행"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(clickBell))
        rightBarButton.tintColor = .grey500
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc private func clickBell() {
        print("알림 버튼 클릭")
        let noticeVC = NoticeViewController()
        noticeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(noticeVC, animated: true)
    }
    
    private func setupAction() {
        myAccompanyView.segmentedControl.addTarget(self, action: #selector(switchSegment(segment:)), for: .valueChanged)
    }

    @objc private func switchSegment(segment: UISegmentedControl) {
        let selectedIndex = segment.selectedSegmentIndex
        let newViewController: UIViewController
        
        switch selectedIndex {
        case 0:
            newViewController = RequestViewController()
        case 1:
            newViewController = BookmarksViewController()
        case 2:
            newViewController = MyPostsViewController()
        default:
            return
        }
        
        moveUnderline()
        switchToViewController(newViewController)
    }
    
    private func moveUnderline() {
        // 세그먼트 컨트롤 하단바 이동
        let width = self.myAccompanyView.segmentedControl.frame.width / CGFloat(self.myAccompanyView.segmentedControl.numberOfSegments)
        let xPosition = self.myAccompanyView.segmentedControl.frame.origin.x + (width * CGFloat(self.myAccompanyView.segmentedControl.selectedSegmentIndex))
                
        UIView.animate(withDuration: 0.2) {
            self.myAccompanyView.underLineView.transform = CGAffineTransform(translationX: xPosition, y: 0)
        }
    }
    
    private func switchToViewController(_ newViewController: UIViewController) {
        if let currentVC = currentViewController {
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        addChild(newViewController)
        newViewController.view.frame = myAccompanyView.bounds
        myAccompanyView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
        
        newViewController.view.snp.makeConstraints {
            $0.top.equalTo(myAccompanyView.underLineView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        currentViewController = newViewController
    }
}
