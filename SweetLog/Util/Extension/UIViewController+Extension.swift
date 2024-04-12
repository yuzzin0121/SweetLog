//
//  UIViewController+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

extension UIViewController {
    func changeRootView(to viewController: UIViewController, isNav: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let vc = isNav ? UINavigationController(rootViewController: viewController) : viewController
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKey()
    }

    func changeHome() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let tab = TabBarController()
        sceneDelegate?.window?.rootViewController = tab
        sceneDelegate?.window?.makeKey()
    }
}
