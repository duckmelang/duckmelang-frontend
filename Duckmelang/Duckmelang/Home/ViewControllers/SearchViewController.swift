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

    private let searchView = SearchView()

    private var recentSearches: [String] = SearchKeyword.dummy1().map { $0.keyword }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchView
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        setupActions()
        setupTableView()
        updateSearchResults()
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

    // MARK: - 검색어 입력 이벤트 추가
    private func setupActions() {
        searchView.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        print("입력된 검색어: \(textField.text ?? "")")
    }

    // MARK: - UITableView 설정
    private func setupTableView() {
        searchView.recentSearchTableView.delegate = self
        searchView.recentSearchTableView.dataSource = self
    }

    // MARK: - 검색어 UI 업데이트
    private func updateSearchResults() {
        searchView.recentSearchView0.subviews.forEach { $0.removeFromSuperview() }

        if let firstKeyword = recentSearches.first {
            let keywordLabel = UILabel().then {
                $0.text = firstKeyword
                $0.font = UIFont.systemFont(ofSize: 16)
                $0.textColor = .black
            }

            searchView.recentSearchView0.addSubview(keywordLabel)
            keywordLabel.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(8)
            }
        }

        searchView.recentSearchTableView.reloadData() // 최근 검색어 리스트 업데이트
    }

    // MARK: - UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(recentSearches.count - 1, 0) // 첫 번째 검색어 제외
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchCell else {
            return UITableViewCell()
        }

        let keywordIndex = indexPath.row + 1 // 첫 번째 검색어 제외
        cell.configure(with: recentSearches[keywordIndex], at: keywordIndex, deleteAction: { [weak self] in
            self?.deleteRecentSearch(at: indexPath)
        })

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - 최근 검색어 삭제 기능
    private func deleteRecentSearch(at indexPath: IndexPath) {
        let keywordIndex = indexPath.row + 1 // 첫 번째 검색어 제외
        guard keywordIndex < recentSearches.count else { return }

        recentSearches.remove(at: keywordIndex)

        DispatchQueue.main.async {
            self.searchView.recentSearchTableView.beginUpdates()
            self.searchView.recentSearchTableView.deleteRows(at: [indexPath], with: .fade)
            self.searchView.recentSearchTableView.endUpdates()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.searchView.recentSearchTableView.reloadData()
            }
        }
    }
}
