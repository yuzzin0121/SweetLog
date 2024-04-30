//
//  ProfileViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit
import RxSwift

final class ProfileViewController: BaseViewController {
    lazy var settingButton = UIBarButtonItem(image: Image.setting, style: .plain, target: self, action: nil)
    let mainView = ProfileView()
    let viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setAction()
    }
    
    private func setAction() {
        let followInfoTapGesture = UITapGestureRecognizer(target: self, action: #selector(followInfoTapped))
        mainView.profileSectionView.followInfoView.addGestureRecognizer(followInfoTapGesture)
        mainView.profileSectionView.followInfoView.isUserInteractionEnabled = true
        
        let followingInfoTapGesture = UITapGestureRecognizer(target: self, action: #selector(followingInfoTapped))
        mainView.profileSectionView.followingInfoView.addGestureRecognizer(followingInfoTapGesture)
        mainView.profileSectionView.followingInfoView.isUserInteractionEnabled = true
    }
    
    // 팔로우 클릭 시
    @objc func followInfoTapped() {
        print(#function)
        guard let profileModel = viewModel.profileModel else { return }
        showFollowOrFollowingDetailVC(followType: .follow, users: profileModel.followers)
    }
    
    // 팔로잉 클릭 시
    @objc func followingInfoTapped() {
        print(#function)
        guard let profileModel = viewModel.profileModel else { return }
        showFollowOrFollowingDetailVC(followType: .following, users: profileModel.following)
    }
    
    private func showFollowOrFollowingDetailVC(followType: FollowType, users: [User]) {
        let followDetailVC = FollowDetailViewController()
        followDetailVC.viewModel.followType = followType
        followDetailVC.viewModel.users = users
        navigationController?.pushViewController(followDetailVC, animated: true)
    }
    
    private func configureView() {
        addChild(mainView.userPostSementedVC)
        mainView.containerView.addSubview(mainView.userPostSementedVC.view)
        mainView.userPostSementedVC.didMove(toParent: self)
        mainView.userPostSementedVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        print(viewModel.isMyProfile, viewModel.userId)
        mainView.userPostSementedVC.isMyProfile = viewModel.isMyProfile
        mainView.userPostSementedVC.userId = viewModel.userId
        
        // 설정버튼 클릭 시
        settingButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showSettingVC()
            }
            .disposed(by: disposeBag)
        let followStatus = PublishSubject<Bool>()
        
        mainView.profileSectionView.followButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.mainView.profileSectionView.followButton.isSelected.toggle()
                followStatus.onNext(owner.mainView.profileSectionView.followButton.isSelected)
            }
            .disposed(by: disposeBag)
        
        let input = ProfileViewModel.Input(fetchProfileTrigger: Observable.just(()),
                                           followButtonTapped: followStatus.asObserver())
        let output = viewModel.transform(input: input)
        
        if viewModel.isMyProfile {
            output.fetchMyProfileSuccessTrigger
                .drive(with: self) { owner, profileModel in
                    guard let profileModel else { return }
                    owner.updateProfileInfo(profileModel)
                }
                .disposed(by: disposeBag)
        }
        
        output.fetchUserProfileSuccessTrigger
            .drive(with: self) { owner, profileModel in
                guard let profileModel else { return }
                owner.updateProfileInfo(profileModel)
            }
            .disposed(by: disposeBag)
        
        mainView.profileSectionView.editProfileButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showEditProfileVC()
            }
            .disposed(by: disposeBag)
        
        output.followStatusSuccessTrigger
            .drive(with: self) { owner, followStatus in
                guard let followStatus else { return }
                let status = followStatus.followingStatus
                owner.mainView.profileSectionView.setFollowStatus(status: status)
            }
            .disposed(by: disposeBag)
    }
    
    private func showEditProfileVC() {
        guard let profileModel = viewModel.profileModel else { return }
        let editProfileVC = EditProfileViewController()
        editProfileVC.sendProfileDelegate = self
        editProfileVC.viewModel.currentProfileImageUrl = profileModel.profileImage
        editProfileVC.viewModel.currentNickname = profileModel.nickname
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func updateProfileInfo(_ profileModel: ProfileModel) {
        if let profileImageUrl = profileModel.profileImage {
            setProfileImage(imageUrl: profileImageUrl)
        }
        
        print("내 프로필이야? --- \(viewModel.isMyProfile)")
        mainView.profileSectionView.setFollowStatus(status: viewModel.isFollowing())
        mainView.profileSectionView.followButton.isHidden = viewModel.isMyProfile
        mainView.profileSectionView.editProfileButton.isHidden = !(viewModel.isMyProfile)
        
        mainView.profileSectionView.nicknameLabel.text = profileModel.nickname
        mainView.profileSectionView.emailLabel.text = profileModel.email
        
        mainView.profileSectionView.postInfoView.countLabel.text = "\(profileModel.posts.count)"
        mainView.profileSectionView.followInfoView.countLabel.text = "\(profileModel.followers.count)"
        mainView.profileSectionView.followingInfoView.countLabel.text = "\(profileModel.following.count)"
    }
    
    private func setProfileImage(imageUrl: String) {
        mainView.profileSectionView.profileImageView.kf.setImageWithAuthHeaders(with: imageUrl) { isSuccess in
            if !isSuccess {
                print("프로필 사진 로드 실패")
            }
        }
    }
    
    private func showSettingVC() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "내 프로필"
        navigationItem.rightBarButtonItem = settingButton
    }
}

extension ProfileViewController: SendProfileDelegate {
    func sendProfile(profileModel: ProfileModel) {
        updateProfileInfo(profileModel)
    }
}

protocol SendProfileDelegate: AnyObject {
    func sendProfile(profileModel: ProfileModel)
}
