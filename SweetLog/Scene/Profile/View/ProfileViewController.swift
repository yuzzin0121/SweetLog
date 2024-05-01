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
    let viewModel: ProfileViewModel
    let fetchProfileTrigger = PublishSubject<String>()
    
    init(isMyProfile: Bool = true, userId: String = UserDefaultManager.shared.userId) {
        print("isMyProfile: \(isMyProfile), userId: \(userId)")
        self.viewModel = ProfileViewModel(isMyProfile: isMyProfile, userId: userId)
        mainView.userPostSementedVC.isMyProfile = isMyProfile
        mainView.userPostSementedVC.userId = userId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    // 팔로우 클릭 시
    @objc func followInfoTapped() {
        if viewModel.isMyProfile {
            guard let myProfileModel = viewModel.myProfileModel else { return }
            showFollowOrFollowingDetailVC(followType: .follow, profileModel: myProfileModel)
        } else {
            guard let profileModel = viewModel.profileModel else { return }
            showFollowOrFollowingDetailVC(followType: .follow, profileModel: profileModel)
        }
        
    }
    
    // 팔로잉 클릭 시
    @objc func followingInfoTapped() {
        if viewModel.isMyProfile {
            guard let myProfileModel = viewModel.myProfileModel else {
                print("내 프로필 없음")
                return
            }
            showFollowOrFollowingDetailVC(followType: .following, profileModel: myProfileModel)
        } else {
            guard let profileModel = viewModel.profileModel else {
                print("없음")
                return
            }
            showFollowOrFollowingDetailVC(followType: .following, profileModel: profileModel)
        }
    }
    
    private func showFollowOrFollowingDetailVC(followType: FollowType, profileModel: ProfileModel) {
        guard let myProfileModel = viewModel.myProfileModel else {
            print("없음")
            return
        }
        let followDetailVC = FollowDetailViewController(followType: followType,
                                                        isMyProfile: viewModel.isMyProfile,
                                                        userId: profileModel.userId)
    
        followDetailVC.viewModel.myProfile = myProfileModel
        
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
        print(#function)
        
        let input = ProfileViewModel.Input(fetchProfileTrigger: fetchProfileTrigger,
                                           followButtonTapped: mainView.profileSectionView.followButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        fetchProfileTrigger.onNext(viewModel.userId)
        
        // 팔로우 또는 언팔로우 성공했을 때
        FetchTriggerManager.shared.followTrigger
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.fetchProfileTrigger.onNext(owner.viewModel.userId)
            }
            .disposed(by: disposeBag)
        
        // 내 프로필 조회했을 때
        output.fetchMyProfileSuccessTrigger
            .drive(with: self) { owner, profileModel in
                if owner.viewModel.isMyProfile {    // 내 프로필 화면일 경우
                    owner.mainView.profileSectionView.updateProfileInfo(profileModel, isMyProfile: owner.viewModel.isMyProfile)
                }
            }
            .disposed(by: disposeBag)
        
        // 다른 유저 프로필일 경우 -> 유저 프로필 뷰에 반영
        output.fetchUserProfileSuccessTrigger
            .drive(with: self) { owner, userProfileModel in
                owner.mainView.profileSectionView.updateProfileInfo(userProfileModel, isMyProfile: owner.viewModel.isMyProfile)
            }
            .disposed(by: disposeBag)
        
        // 팔로우 상태
        output.isFollowing
            .drive(with: self) { owner, followStatus in
                print("팔로우 상태\(followStatus)")
                owner.mainView.profileSectionView.setFollowStatus(status: followStatus)
            }
            .disposed(by: disposeBag)
        
        mainView.profileSectionView.followTapGesture.rx.event
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.followInfoTapped()
            }
            .disposed(by: disposeBag)
        
        mainView.profileSectionView.followingTapGesture.rx.event
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.followingInfoTapped()
            }
            .disposed(by: disposeBag)
        
        
        // 프로필 수정 버튼 클릭 시
        mainView.profileSectionView.editProfileButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showEditProfileVC()
            }
            .disposed(by: disposeBag)
        
        
        // 설정버튼 클릭 시
        settingButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showSettingVC()
            }
            .disposed(by: disposeBag)
    }
    
    // 프로필 수정버튼 클릭 시
    private func showEditProfileVC() {
        guard let profileModel = viewModel.myProfileModel else { return }
        let editProfileVC = EditProfileViewController(currentProfileImage: profileModel.profileImage, currentNickname: profileModel.nickname)
        editProfileVC.sendProfileDelegate = self
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    // 설정 화면으로 전환
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
        mainView.profileSectionView.updateProfileInfo(profileModel, isMyProfile: viewModel.isMyProfile)
    }
}

protocol SendProfileDelegate: AnyObject {
    func sendProfile(profileModel: ProfileModel)
}
