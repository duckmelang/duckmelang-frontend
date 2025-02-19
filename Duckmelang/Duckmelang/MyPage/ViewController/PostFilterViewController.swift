//
//  PostFilterViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/5/25.
//

import UIKit
import Moya

class PostFilterViewController: UIViewController {
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

    // 필터 데이터
    private var selectedGender: String? = nil // "MALE" / "FEMALE"
    private var minAge: Int? = nil
    private var maxAge: Int? = nil
    
    // 현재 확장된 섹션 (없으면 nil)
    private var expandedSection: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = postFilterView
        navigationController?.isNavigationBarHidden = true
        setupDelegate()
        fetchFilterSettings() // ✅ 뷰 로드 시 필터 설정 불러오기
    }
    
    private lazy var postFilterView = PostFilterView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.finishBtn.addTarget(self, action: #selector(saveFilterSettings), for: .touchUpInside)
    }
    
    private lazy var tableView = postFilterView.postFilterTableView
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func backBtnDidTap() {
        self.dismiss(animated: true)
    }
    
    /// ✅ 필터 데이터를 서버에서 불러오기 (GET 요청)
    private func fetchFilterSettings() {
        provider.request(.getFilters) { result in
            switch result {
            case .success(let response):
                do {
                    // ✅ 원본 JSON을 직접 파싱
                    if let jsonObject = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
                       let result = jsonObject["result"] as? [String: Any] {
                        
                        print("📌 JSON 원본: \(result)")
                        
                        // ✅ 성별 데이터 적용
                        if let gender = result["gender"] as? String {
                            self.selectedGender = gender
                            print("✅ selectedGender 적용됨: \(self.selectedGender!)")
                        } else {
                            self.selectedGender = "BOTH"
                            print("⚠️ selectedGender가 nil이므로 BOTH로 설정됨")
                        }

                        // ✅ 나이 데이터 적용 (nil이면 기본값 18~50 적용)
                        let fetchedMinAge = result["minAge"] as? Int ?? 18
                        let fetchedMaxAge = result["maxAge"] as? Int ?? 50

                        self.minAge = fetchedMinAge
                        self.maxAge = fetchedMaxAge

                        print("✅ minAge 적용됨: \(self.minAge!)")
                        print("✅ maxAge 적용됨: \(self.maxAge!)")

                        DispatchQueue.main.async {
                            self.tableView.reloadData() // ✅ UI 업데이트
                            
                            // ✅ 값이 설정된 후에만 `updateUI()` 실행
                            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AgeSelectionCell {
                                cell.minAge = self.minAge
                                cell.maxAge = self.maxAge
                                cell.updateUI()  // 🎯 여기서 updateUI() 실행!
                            }
                        }
                    }
                } catch {
                    print("❌ JSON 파싱 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 필터 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }


    
    /// ✅ 필터 데이터를 서버로 저장하기 (POST 요청)
    @objc private func saveFilterSettings() {
        let value: String? = (selectedGender == "BOTH") ? nil : selectedGender
        let filterRequest = FilterRequest(
            gender: value,
            minAge: minAge,
            maxAge: maxAge
        )
        
        provider.request(.postFilters(FilterRequest: filterRequest)) { result in
            switch result {
            case .success:
                print("✅ 필터 설정 저장 성공")
                self.dismiss(animated: true)
            case .failure(let error):
                print("❌ 필터 설정 저장 실패: \(error.localizedDescription)")
            }
        }
    }

    @objc private func handleSectionTap(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        
        let previousExpandedSection = expandedSection
        expandedSection = (previousExpandedSection == section) ? nil : section

        tableView.performBatchUpdates({
            if let previousSection = previousExpandedSection {
                tableView.reloadSections(IndexSet(integer: previousSection), with: .automatic)
            }
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }, completion: nil)
    }
    
    @objc private func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        let previousExpandedSection = expandedSection
        expandedSection = (previousExpandedSection == section) ? nil : section

        tableView.performBatchUpdates({
            if let previousSection = previousExpandedSection {
                tableView.reloadSections(IndexSet(integer: previousSection), with: .automatic)
            }
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }, completion: nil)
    }
}

extension PostFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSection == section ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // ✅ 성별 선택 UI 반영
            guard let genderCell = tableView.dequeueReusableCell(withIdentifier: GenderSelectionCell.identifier, for: indexPath) as? GenderSelectionCell else {
                return UITableViewCell()
            }
            genderCell.selectedGender = selectedGender
            genderCell.onGenderSelected = { gender in
                self.selectedGender = gender
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            print("cellForRowAt - 적용된 selectedGender: \(selectedGender ?? "nil")")
            genderCell.updateGenderUI()
            return genderCell
        } else { // ✅ 나이 선택 UI 반영
            guard let ageCell = tableView.dequeueReusableCell(withIdentifier: AgeSelectionCell.identifier, for: indexPath) as? AgeSelectionCell else {
                return UITableViewCell()
            }
            // ✅ minAge, maxAge 값 적용 후 UI 업데이트
            ageCell.minAge = minAge
            ageCell.maxAge = maxAge
            ageCell.updateUI()
            
            ageCell.onAgeChanged = { min, max in
                self.minAge = min
                self.maxAge = max
                print("📌 PostFilterViewController - minAge: \(self.minAge!), maxAge: \(self.maxAge!)")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData() // ✅ UI 즉시 반영
                }
            }
            
            return ageCell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView().then {
            $0.backgroundColor = .white
            $0.tag = section
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSectionTap(_:))))
        }

        let label = Label(text: section == 0 ? "성별" : "나이", font: .ptdSemiBoldFont(ofSize: 17), color: .grey800)
        
        let toggleButton = UIButton().then {
            let isExpanded = expandedSection == section
            let imageName = isExpanded ? "chevron.up" : "chevron.down"
            $0.setImage(UIImage(systemName: imageName), for: .normal)
            $0.tintColor = .grey500
            $0.addTarget(self, action: #selector(toggleSection), for: .touchUpInside)
        }
        
        let separator = UIView().then {
            $0.backgroundColor = .grey200
            $0.tag = 100  // 태그 지정하여 구분선 숨김 처리 가능하게
        }

        [label, toggleButton, separator].forEach({ headerView.addSubview($0) })
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        toggleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }

        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        // ✅ 구분선 숨김 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            separator.isHidden = (self.expandedSection == section)
        }
        
        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // ✅ 셀이 표시될 때 구분선 추가
        let separatorTag = 200
        let existingSeparator = cell.contentView.viewWithTag(separatorTag)
        
        if existingSeparator == nil {
            let separator = UIView().then {
                $0.backgroundColor = .grey200
                $0.tag = separatorTag  // 태그 지정하여 중복 추가 방지
            }
            cell.contentView.addSubview(separator)
            
            if indexPath.section == 0 {
                separator.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalToSuperview()
                    $0.height.equalTo(1)
                }
            } else {
                separator.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalToSuperview()
                    $0.height.equalTo(1)
                }
            }
        }
    }
}
