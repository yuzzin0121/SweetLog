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
    
    let viewModel = FollowDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func bind() {
        guard let users = viewModel.users, let followType = viewModel.followType else { return }
        let input = FollowDetailViewModel.Input(userList: Observable.just(users))
        
        let output = viewModel.transform(input: input)
        
        output.userList
            .drive(mainView.tableView.rx.items(cellIdentifier: FollowDetailTableViewCell.identifier, cellType: FollowDetailTableViewCell.self)) { index, user, cell in
                cell.configureCell(user: user, type: followType)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationItem() {
        // TODO: - 팔로우 or 팔로잉
        if let followType = viewModel.followType {
            navigationItem.title = followType.rawValue
        }
    }
    
    override func loadView() {
        view = mainView
    }
}
