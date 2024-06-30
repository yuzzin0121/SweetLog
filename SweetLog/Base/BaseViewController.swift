//
//  BaseViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureNavigationItem()
        setSwipe()
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginVC), name: .refreshTokenExpired, object: nil)
    }
    
    private func setSwipe() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeRecognizer.direction = .right
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            popView()
        }
    }
    
    func bind() {
        
    }
    
    @objc func showLoginVC(notification: Notification) {
        showAlert(title: "세션이 만료되었습니다", message: "다시 로그인해주세요") { [weak self] in
            self?.changeRootView(to: SignInViewController(), isNav: true)
            [UserDefaultManager.UDKey.userId.rawValue, UserDefaultManager.UDKey.accessToken.rawValue, UserDefaultManager.UDKey.refreshToken.rawValue].forEach {
                UserDefaults.standard.removeObject(forKey: $0)
            }
        }
    }
    
    func showAlert(title: String, message: String, actionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            actionHandler?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlertWithCancel(title: String, message: String, actionTitle: String, actionHandler: (() -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: actionTitle, style: .destructive) { _ in
            actionHandler?()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func configureNavigationItem() {
        
    }
    
    @objc
    func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
