//
//  MyPageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = myPageView
    }
    
    private lazy var myPageView = MyPageView().then {_ in}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
