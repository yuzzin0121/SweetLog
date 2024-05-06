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

final class EditProfileViewController: BaseViewController {
    let mainView = EditProfileView()
    
    let viewModel: EditProfileViewModel
    let profileImageData = PublishRelay<Data?>()
    weak var sendProfileDelegate: SendProfileDelegate?
    
    init(currentProfileImage: String?, currentNickname: String) {
        viewModel = EditProfileViewModel(currentProfileImage: currentProfileImage, currentNickname: currentNickname)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        let input = EditProfileViewModel.Input(nicknameText: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
                                               prfileImageData: profileImageData.asObservable(),
                                               editProfileButtonTapped: mainView.editProfileButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.currentProfileImage
            .drive(with: self) { owner, url in
                owner.mainView.setCurrentProfile(url: url)
            }
            .disposed(by: disposeBag)
        
        output.currentNicknameText
            .drive(with: self) { owner, nickname in
                owner.mainView.setNickname(currentNickname: nickname)
            }
            .disposed(by: disposeBag)
        
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
                owner.mainView.setProfileImage(profileImageData)
            }
            .disposed(by: disposeBag)
        
        output.validNickname
            .drive(with: self) { owner, isValid in
                owner.mainView.nicknameValidMessage.text = isValid ? "" : "2글자 이상 입력해주세요"
            }
            .disposed(by: disposeBag)
        
        output.validNickname
            .drive(with: self) { owner, isValid in
                owner.mainView.setEditButtonStyle(isValid: isValid)
            }
            .disposed(by: disposeBag)
        
        output.editProfileSuccessTrigger
            .drive(with: self) { owner, profileModel in
                owner.editSuccess(profileModel)
            }
            .disposed(by: disposeBag)
    }
    
    private func editSuccess(_ profileModel: ProfileModel?) {
        guard let profileModel else { return }
        sendProfileDelegate?.sendProfile(profileModel: profileModel)
        navigationController?.popViewController(animated: true)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
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
