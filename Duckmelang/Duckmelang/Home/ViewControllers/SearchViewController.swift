//
//  SearchViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit
import Then
import SnapKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let searchTextField = UITextField().then {
        $0.placeholder = "텍스트 입력"
        $0.borderStyle = .roundedRect

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        $0.leftView = leftPaddingView
        $0.leftViewMode = .always

        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        searchIcon.center = CGPoint(x: rightPaddingView.frame.width / 2, y: rightPaddingView.frame.height / 2)
        rightPaddingView.addSubview(searchIcon)

        $0.rightView = rightPaddingView
        $0.rightViewMode = .always
    }
    
    private let recentSearchTableView = UITableView().then {
        $0.register(RecentSearchCell.self, forCellReuseIdentifier: "RecentSearchCell")
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
    }

    private var recentSearches: [String] = SearchKeyword.dummy1().map { $0.keyword }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        setupView()
    }
    
    // MARK: - 네비게이션 바 설정
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "검색"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = .gray
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - 뷰 설정
    private func setupView() {
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self

        [
            searchTextField,
            recentSearchTableView
        ].forEach {
            view.addSubview($0)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.height.equalTo(40)
        }
        
        recentSearchTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: recentSearches[indexPath.row], deleteAction: { [weak self] in
            self?.deleteRecentSearch(at: indexPath)
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - 최근 검색어 삭제 기능
    private func deleteRecentSearch(at indexPath: IndexPath) {
        guard indexPath.row < recentSearches.count else { return }
        
        recentSearches.remove(at: indexPath.row)

        DispatchQueue.main.async {
            self.recentSearchTableView.beginUpdates()
            self.recentSearchTableView.deleteRows(at: [indexPath], with: .fade)
            self.recentSearchTableView.endUpdates()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.recentSearchTableView.reloadData()
            }
        }
    }
}
