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
    
    init(followType: FollowType, isMyProfile: Bool, users: [User]) {
        viewModel = FollowDetailViewModel(followType: followType, isMyProfile: isMyProfile, users: users)
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
        
        
        output.userList
            .drive(with: self) { owner, users in
                print("userList \(users)")
                owner.mainView.emptyLabel.isHidden = users.isEmpty ? false : true
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationItem() {
        // TODO: - 팔로우 or 팔로잉
        navigationItem.title = viewModel.followType.rawValue
    }
    
    override func loadView() {
        view = mainView
    }
}
