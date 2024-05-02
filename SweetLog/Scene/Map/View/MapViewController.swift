//
//  MapViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class MapViewController: UIViewController {
    let mainView = MapView()
    let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func loadView() {
        view = mainView
    }
}
