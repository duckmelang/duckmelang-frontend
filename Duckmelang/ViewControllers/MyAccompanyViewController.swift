//
//  MyAccompanyViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/13/25.
//

import UIKit

class MyAccompanyViewController: UIViewController {
    var selectedTag: Int = 0
    
    let data1 = MyAccompanyModel.dummy()
    let data2 = PostModel.dummy1()
    let data3 = PostModel.dummy2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "나의 동행"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
        self.view = myAccompanyView
        setupDelegate()
        setupAction()
        updateBtnSelected()
    }
    
    private lazy var myAccompanyView: MyAccompanyView = {
        let view = MyAccompanyView()
        
        return view
    }()
    
    @objc func clickBtn(_ sender: UIButton) {
        selectedTag = sender.tag
        updateBtnSelected()
    }
    
    private func setupDelegate() {
        myAccompanyView.myAccompanyTableView.dataSource = self
        myAccompanyView.myAccompanyTableView.delegate = self
        
        myAccompanyView.scrapTableView.dataSource = self
        myAccompanyView.scrapTableView.delegate = self
        
        myAccompanyView.myPostsTableView.dataSource = self
        myAccompanyView.myPostsTableView.delegate = self
    }
    
    private func setupAction() {
        // segmentedControl
        myAccompanyView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
        
        // Btns
        myAccompanyView.awaitingBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        myAccompanyView.sentBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        myAccompanyView.receivedBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
    }
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            myAccompanyView.myAccompanyTableView.isHidden = false
            myAccompanyView.scrapTableView.isHidden = true
            myAccompanyView.myPostsTableView.isHidden = true
        } else if segment.selectedSegmentIndex == 1 {
            myAccompanyView.myAccompanyTableView.isHidden = true
            myAccompanyView.scrapTableView.isHidden = false
            myAccompanyView.myPostsTableView.isHidden = true
        } else {
            myAccompanyView.myAccompanyTableView.isHidden = true
            myAccompanyView.scrapTableView.isHidden = true
            myAccompanyView.myPostsTableView.isHidden = false
        }
        
        let width = myAccompanyView.segmentedControl.frame.width / CGFloat(myAccompanyView.segmentedControl.numberOfSegments)
        let xPosition = myAccompanyView.segmentedControl.frame.origin.x + (width * CGFloat(myAccompanyView.segmentedControl.selectedSegmentIndex))
                
        UIView.animate(withDuration: 0.2) {
            self.myAccompanyView.underLineView.frame.origin.x = xPosition
        }
    }
    
    private func updateBtnSelected() {
        for btn in [myAccompanyView.awaitingBtn, myAccompanyView.sentBtn, myAccompanyView.receivedBtn] {
            if btn.tag == selectedTag {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
    }
}

extension MyAccompanyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == myAccompanyView.myAccompanyTableView) {
            return data1.count
        } else if (tableView == myAccompanyView.scrapTableView) {
            return data2.count
        } else if (tableView == myAccompanyView.myPostsTableView) {
            return data3.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == myAccompanyView.myAccompanyTableView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAccompanyCell.identifier, for: indexPath) as? MyAccompanyCell else {
                return UITableViewCell()
            }
            cell.configure(model: data1[indexPath.row])
            return cell
            
        } else if (tableView == myAccompanyView.scrapTableView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                return UITableViewCell()
            }
            cell.configure(model: data2[indexPath.row])
            return cell
        } else if (tableView == myAccompanyView.myPostsTableView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                return UITableViewCell()
            }
            cell.configure(model: data3[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}
