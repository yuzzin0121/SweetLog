//
//  TabBarController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addViewControllers()
    }
    
    private func configureView() {
        tabBar.backgroundColor = Color.white
        tabBar.tintColor = Color.black
        tabBar.unselectedItemTintColor = Color.gray
    }
    
    private func addViewControllers() {
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: nil, image: TabItem.home.image, selectedImage: TabItem.home.selectedImage)
  
        let mapVC = MapViewController()
        let mapNav = UINavigationController(rootViewController: mapVC)
        mapNav.tabBarItem = UITabBarItem(title: nil, image: TabItem.map.image, selectedImage: TabItem.map.selectedImage)
        
        let profileVC = ProfileViewController()
        profileVC.viewModel.isMyProfile = true
        profileVC.viewModel.userId = UserDefaultManager.shared.userId
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: nil, image: TabItem.profile.image, selectedImage: TabItem.profile.selectedImage)
        
        
        self.viewControllers = [homeNav, mapNav, profileNav]
    }
}
