//
//  HomeViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class HomeViewController: BaseViewController {
    let mainView = HomeView()

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func loadView() {
        view = mainView
    }
   
}
