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
        
        let tagSearchVC = TagSearchViewController()
        let tagSearchNav = UINavigationController(rootViewController: tagSearchVC)
        tagSearchNav.tabBarItem = UITabBarItem(title: nil, image: TabItem.tagSearch.image.resized(to: CGSize(width: 30, height: 30)), selectedImage: TabItem.tagSearch.selectedImage.resized(to: CGSize(width: 30, height: 30)))
  
        let mapVC = MapViewController()
        let mapNav = UINavigationController(rootViewController: mapVC)
        mapNav.tabBarItem = UITabBarItem(title: nil, image: TabItem.map.image, selectedImage: TabItem.map.selectedImage)
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: nil, image: TabItem.profile.image, selectedImage: TabItem.profile.selectedImage)
        
        
        self.viewControllers = [homeNav, tagSearchNav, mapNav, profileNav]
    }
}
