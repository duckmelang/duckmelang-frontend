//
//  SearchViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit
import Then
import SnapKit
import Moya

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let provider = MoyaProvider<SearchAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private let searchManager = SearchHistoryManager()
    
    private let searchView = SearchView()
    
    private var recentSearches: [String] = []
    private var searchData: [PostDTO] = []
    
    var isLoading = false   // 중복 로딩 방지
    var isLastPage = false  // 마지막 페이지인지 여부
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchView
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        setupDelegate()
        updateSearchResults()
        
        recentSearches = searchManager.getSearchHistory() // 저장된 최근 검색어 불러오기
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
    
    // MARK: - Delegate 설정
    private func setupDelegate() {
        searchView.recentSearchTableView.delegate = self
        searchView.recentSearchTableView.dataSource = self
        
        searchView.searchDataTableView.delegate = self
        searchView.searchDataTableView.dataSource = self
        
        searchView.searchTextField.delegate = self
    }
    
    // MARK: - 검색어 UI 업데이트
    private func updateSearchResults() {
        recentSearches = searchManager.getSearchHistory() // 최근 검색어 가져오기
        searchView.recentSearchTableView.reloadData() // 테이블 뷰 업데이트
    }
    
    // MARK: - UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return recentSearches.count
        } else {
            return searchData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: recentSearches[indexPath.row], at: indexPath.row, deleteAction: { [weak self] in
                self?.deleteRecentSearch(at: indexPath)
            })
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                return UITableViewCell()
            }
            
            if indexPath.row < searchData.count {
                cell.configure(model: searchData[indexPath.row])
            }
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - tableViewHeight * 2 {
            if !isLoading && !isLastPage {
                currentPage += 1
                getSearchData(searchView.searchTextField.text ?? "")
            }
        }
    }
    
    // MARK: - 최근 검색어 삭제 기능
    private func deleteRecentSearch(at indexPath: IndexPath) {
        let keywordIndex = indexPath.row
        guard keywordIndex < recentSearches.count else { return }
        
        recentSearches.remove(at: keywordIndex)
        // 키체인에 삭제 반영
        searchManager.deleteSearchQuery(at: keywordIndex)
        
        DispatchQueue.main.async {
            self.searchView.recentSearchTableView.beginUpdates()
            self.searchView.recentSearchTableView.deleteRows(at: [indexPath], with: .fade)
            self.searchView.recentSearchTableView.endUpdates()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.searchView.recentSearchTableView.reloadData()
            }
        }
    }
    
    // MARK: - 검색 키워드에 따라 데이터 불러오기
    private func getSearchData(_ keyword: String) {
        guard !isLoading && !isLastPage else { return } // 중복 호출 & 마지막 페이지 방지
        isLoading = true
        
        if (keyword.isEmpty) { return }
        
        provider.request(.getSearch(page: currentPage, searchKeyword: keyword)) { result in
            print("getsearch 실행")
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    let response = try? response.map(ApiResponse<PostResponse>.self)
                    guard let result = response?.result?.postList else { return }
                    guard let isLast = response?.result?.isLast else { return }
                    self.searchData.append(contentsOf: result)
                    print("검색 결과: \(self.searchData)")
                    
                    DispatchQueue.main.async {
                        self.searchView.empty.isHidden = !result.isEmpty
                        self.isLastPage = isLast
                        self.isLoading = false
                        self.searchView.loadingIndicator.stopLoading()
                        self.searchView.searchDataTableView.reloadData()
                        
                        if isLast {
                            self.searchView.searchDataTableView.tableFooterView = nil
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.searchView.loadingIndicator.stopLoading()
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    // MARK: - TextField에서 엔터를 입력했을 때 실행되는 함수
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            updateSearchResults()
            
            searchView.searchDataTableView.isHidden = true
            searchView.empty.isHidden = true
            searchView.recentSearchTableView.isHidden = false
            return false // 공백이면 최근 검색어를 띄움
        }
        
        // 엔터를 누르면 새로운 데이터를 받아야하므로 모든 값을 초기화
        searchData.removeAll()
        currentPage = 0
        isLoading = false
        isLastPage = false
        
        searchView.searchDataTableView.reloadData()
        searchView.searchDataTableView.isHidden = false
        searchView.empty.isHidden = true
        searchView.recentSearchTableView.isHidden = true
        
        // 최근 검색어에 값을 저장하고 검색을 실행
        searchView.loadingIndicator.startLoading()
        searchManager.saveSearchQuery(text)
        getSearchData(text)
        return true
    }
}
