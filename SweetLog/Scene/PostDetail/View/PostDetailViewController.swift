//
//  PostDetailViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit
import RxSwift

final class PostDetailViewController: BaseViewController {
    let mainView = PostDetailView()
    
    let viewModel = PostDetailViewModel()
    var fetchPostItem: FetchPostItem? {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    let likeStatus = PublishSubject<Bool>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
    }
    
    private func setDelegate() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    private func setData(fetchPostItem: FetchPostItem?) {
        guard let fetchPostItem else { return }
        self.fetchPostItem = fetchPostItem
        mainView.tableView.reloadData()
        navigationItem.title = "\(fetchPostItem.creator.nickname)님의 후기"
    }
    
    override func bind() {
        guard let postId = viewModel.postId else { return }
        
        let postIdSubejct = BehaviorSubject(value: postId)
        let input = PostDetailViewModel.Input(postId: postIdSubejct.asObserver(),
                                              commentText: mainView.commentTextField.rx.text.orEmpty.asObservable(),
                                              commentCreateButtonTapped: mainView.commentTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
                                              likeButtonStatus: likeStatus.asObservable())
        let output = viewModel.transform(input: input)
        
        output.fetchPostItem
            .drive(with: self) { owner, fetchPostItem in
                owner.setData(fetchPostItem: fetchPostItem)
            }
            .disposed(by: disposeBag)
        
        output.createCommentSuccessTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.mainView.tableView.reloadData()
                owner.mainView.commentTextField.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "후기"
    }
    
    @objc
    private func profileButtonTapped(_ sender: ProfileTapGestureRecognizer) {
        print(#function)
        guard let userId = sender.userId else { return }
        let profileVC = ProfileViewController(isMyProfile: userId == UserDefaultManager.shared.userId, userId: userId)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}


extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PostDetailHeaderView.identifier) as? PostDetailHeaderView, let fetchPostItem = viewModel.fetchPostItem  else {
            return UITableViewHeaderFooterView()
        }
        
        headerView.configureHeader(fetchPostItem: fetchPostItem)
        headerView.likeButton.rx.tap
            .subscribe(with: self) { owner, _ in
                headerView.likeButton.isSelected.toggle()
                owner.likeStatus.onNext(headerView.likeButton.isSelected)
            }
            .disposed(by: headerView.disposeBag)
        
        let profileTapGesture = ProfileTapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        profileTapGesture.userId = fetchPostItem.creator.userId
        
        headerView.profileImageView.addGestureRecognizer(profileTapGesture)
        headerView.userNicknameLabel.addGestureRecognizer(profileTapGesture)
        
        headerView.profileImageView.isUserInteractionEnabled = true
        headerView.userNicknameLabel.isUserInteractionEnabled = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchPostItem = self.fetchPostItem else { return 0 }
        return fetchPostItem.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCommentTableViewCell.identifier, for: indexPath) as? PostCommentTableViewCell,
                let fetchPostItem = self.fetchPostItem else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let comment = fetchPostItem.comments[indexPath.row]
        cell.configureCell(comment: comment)
        
        let profileTapGesture = ProfileTapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        profileTapGesture.userId = comment.creator.userId
        
        cell.profileImageView.addGestureRecognizer(profileTapGesture)
        cell.nicknameLabel.addGestureRecognizer(profileTapGesture)
        
        cell.profileImageView.isUserInteractionEnabled = true
        cell.nicknameLabel.isUserInteractionEnabled = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
}


class ProfileTapGestureRecognizer: UITapGestureRecognizer {
    var userId: String?
}
