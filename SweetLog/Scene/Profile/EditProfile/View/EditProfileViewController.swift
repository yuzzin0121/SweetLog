//
//  EditProfileViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

class EditProfileViewController: BaseViewController {
    let mainView = EditProfileView()
    
    let viewModel = EditProfileViewModel()
    let profileImageData = PublishRelay<Data?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentProfile()
        
    }
    
    override func bind() {
        mainView.editProfileImageButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.editProfileImageButtonTapped()
            }
            .disposed(by: disposeBag)
        
        profileImageData
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, profileImageData in
                guard let profileImageData else { return }
                owner.setProfileImage(profileImageData)
            }
            .disposed(by: disposeBag)
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
    
    private func setProfileImage(_ data: Data) {
        mainView.profileImageView.image = UIImage(data: data)
    }
    
    @objc private func editProfileImageButtonTapped() {
        print(#function)
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    override func configureNavigationItem() {
        navigationItem.title = "프로필 수정"
    }
    
    override func loadView() {
        view = mainView
    }
}

// MARK: - 이미지 추가 delegate 설정
extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if !(results.isEmpty) {
            for result in results {
                
                let itemProvider = result.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self = self else { return }
                        if let image = image as? UIImage {
                            guard let data = image.jpegData(compressionQuality: 0.4) else { return }
                            self.profileImageData.accept(data)
                        }
                        
                        if error != nil {
                            return
                        }
                    }
                } else {
                    print("이미지 가져오기 실패")
                }
            }
        } else  {
            picker.dismiss(animated: true)
            return
        }
    }
}
