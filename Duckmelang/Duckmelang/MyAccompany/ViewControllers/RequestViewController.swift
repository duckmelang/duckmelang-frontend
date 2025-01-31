//
//  RequestViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var requestData = MyAccompanyModel.dummy()
    
    var selectedTag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = requestView
        setupDelegate()
        setupAction()
        updateBtnSelected()
    }
    
    private lazy var requestView: RequestView = {
        let view = RequestView()
        return view
    }()

    private func setupDelegate() {
        requestView.requestTableView.delegate = self
        requestView.requestTableView.dataSource = self
    }
    
    private func setupAction() {
        requestView.sentBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        requestView.awaitingBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        requestView.receivedBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
    }
    
    @objc private func clickBtn(_ sender: UIButton) {
        selectedTag = sender.tag
        updateBtnSelected()
    }
    
    private func updateBtnSelected() {
        for btn in [requestView.awaitingBtn, requestView.sentBtn, requestView.receivedBtn] {
            if btn.tag == selectedTag {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAccompanyCell.identifier, for: indexPath) as? MyAccompanyCell else {
            return UITableViewCell()
        }
        cell.configure(model: requestData[indexPath.row])
        return cell
    }
}
