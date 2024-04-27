//
//  EditProfileViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import UIKit

class EditProfileViewController: BaseViewController {
    let mainView = EditProfileView()
    
    let viewModel = EditProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentProfile()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.nicknameTextField.becomeFirstResponder()
    }
    
    override func bind() {
        
    }
    
    private func setCurrentProfile() {
        if let profileImageUrl = viewModel.currentProfileImageUrl {
            mainView.profileImageView.kf.setImageWithAuthHeaders(with: profileImageUrl) { isSuccess in
                if !isSuccess {
                    print("프로필 이미지 로드 실패")
                }
            }
        }
        if !viewModel.currentNickname.isEmpty {
            mainView.nicknameTextField.text = viewModel.currentNickname
        }
    }
    


    override func configureNavigationItem() {
        navigationItem.title = "프로필 수정"
    }
    
    override func loadView() {
        view = mainView
    }
}
