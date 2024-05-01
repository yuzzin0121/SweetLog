//
//  FollowDetailViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/29/24.
//

import UIKit
import RxSwift

final class FollowDetailViewController: BaseViewController {
    let mainView = FollowDetailView()
    
    let viewModel: FollowDetailViewModel
    let fetchUserList = PublishSubject<Void>()
    
    init(followType: FollowType, isMyProfile: Bool, userId: String) {
        viewModel = FollowDetailViewModel(followType: followType,
                                          isMyProfile: isMyProfile,
                                          userId: userId)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func bind() {
        
        let followButtonTapped = PublishSubject<User>()
        
        let input = FollowDetailViewModel.Input(fetchUserList: fetchUserList,
                                                followButtonTapped: followButtonTapped.asObservable())
        
        let output = viewModel.transform(input: input)
        
        fetchUserList.onNext(())
        
        // 유저들 셀에 표현
        output.userList
            .drive(mainView.tableView.rx.items(cellIdentifier: FollowDetailTableViewCell.identifier, cellType: FollowDetailTableViewCell.self)) { [weak self] index, user, cell in
                print("하이하이")
                guard let self, let myProfile = viewModel.myProfile else {
                    return
                }
                cell.selectionStyle = .none
                print(user)
                cell.configureCell(user: user,
                                   followType: viewModel.followType,
                                   isMyProfile: self.viewModel.isMyProfile,
                                   following: myProfile.following)
                
                cell.followButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        followButtonTapped.onNext(user)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(User.self)
            .asDriver()
            .drive(with: self) { owner, user in
                owner.showProfileVC(userId: user.user_id)
            }
            .disposed(by: disposeBag)
        
        output.userFollow
            .drive(with: self) { owner, _ in
                FetchTriggerManager.shared.profileFetchTrigger.onNext(())
                owner.fetchUserList.onNext(())
            }
            .disposed(by: disposeBag)
        
        output.userList
            .drive(with: self) { owner, users in
                print("userList \(users)")
                owner.mainView.emptyLabel.isHidden = users.isEmpty ? false : true
            }
            .disposed(by: disposeBag)
    }
    
    private func showProfileVC(userId: String?) {
        guard let userId else { return }
        let profileVC = ProfileViewController(isMyProfile: userId == UserDefaultManager.shared.userId, userId: userId)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    override func configureNavigationItem() {
        // TODO: - 팔로우 or 팔로잉
        navigationItem.title = viewModel.followType.rawValue
    }
    
    override func loadView() {
        view = mainView
    }
}
