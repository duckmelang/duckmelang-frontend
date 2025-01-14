//
//  MyAccompanyViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/13/25.
//

import UIKit

class MyAccompanyViewController: UIViewController {
    var data = MyAccompanyModel.dummy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view = myAccompanyView
        setupDelegate()
        setupAction()
    }
    
    private lazy var myAccompanyView: MyAccompanyView = {
        let view = MyAccompanyView()
        return view
    }()
    
    private func setupDelegate() {
        myAccompanyView.tableView.dataSource = self
        myAccompanyView.tableView.delegate = self
    }
    
    private func setupAction() {
        myAccompanyView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        /*
        if segment.selectedSegmentIndex == 0 {
            myAccompanyView.homeScrollView.isHidden = false
        }
        else {
            homeView.homeScrollView.isHidden = true
        }
         */
        let width = myAccompanyView.segmentedControl.frame.width / CGFloat(myAccompanyView.segmentedControl.numberOfSegments)
        let xPosition = myAccompanyView.segmentedControl.frame.origin.x + (width * CGFloat(myAccompanyView.segmentedControl.selectedSegmentIndex))
                
        UIView.animate(withDuration: 0.2) {
            self.myAccompanyView.underLineView.frame.origin.x = xPosition
        }
    }
}

extension MyAccompanyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAccompanyCell.identifier, for: indexPath) as? MyAccompanyCell else {
                return UITableViewCell()
            }
            
            cell.configure(model: data[indexPath.row])
            
            return cell
    }
}
