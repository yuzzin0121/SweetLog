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
    let fetchObservable = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchObservable.onNext(())
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
        followDetailVC.viewModel.isMyProfile = viewModel.isMyProfile
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
        
        
        let input = ProfileViewModel.Input(fetchProfileTrigger: fetchObservable,
                                           followButtonTapped: mainView.profileSectionView.followButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        
        output.fetchMyProfileSuccessTrigger
            .drive(with: self) { owner, profileModel in
                guard let profileModel else { return }
                if owner.viewModel.isMyProfile {
                    owner.updateProfileInfo(profileModel)
                }
            }
            .disposed(by: disposeBag)
        
        // 다른 유저 프로필일 경우 -> 나의 프로필에서 팔로잉 리스트, 유저 프로필 조회
        output.fetchMeAndUserProfileSuccessTrigger
            .drive(with: self) { owner, listAndUserProfileModel in
                guard let userProfileModel = listAndUserProfileModel.1 else { return }
                owner.viewModel.setFollowing(myFollowingList: listAndUserProfileModel.0, userId: userProfileModel.userId)
                owner.mainView.profileSectionView.setFollowStatus(status: owner.viewModel.isFollowing)
                owner.updateProfileInfo(userProfileModel)
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
                owner.mainView.profileSectionView.setFollowCount(status: status)
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
        
        print("내 프로필이야? --- \(viewModel.isMyProfile), 팔로우중? \(viewModel.isFollowing)")
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
