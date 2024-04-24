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

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
    }
    
    private func setDelegate() {
        mainView.tableView.dataSource = self
    }
    
    private func setData(fetchPostItem: FetchPostItem?) {
        guard let fetchPostItem else { return }
        
        navigationItem.title = "\(fetchPostItem.creator.nickname)님의 후기"
        mainView.tableView.reloadData()
    }
    
    override func bind() {
        guard let postId = viewModel.postId else { return }
        let postIdSubejct = BehaviorSubject(value: postId)
        let input = PostDetailViewModel.Input(postId: postIdSubejct.asObserver())
        let output = viewModel.transform(input: input)
        
        output.fetchPostItem
            .drive(with: self) { owner, fetchPostItem in
                owner.setData(fetchPostItem: fetchPostItem)
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "후기"
    }
}


extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostInfoTableViewCell.identifier, for: indexPath) as? PostInfoTableViewCell,
                let fetchPostItem = viewModel.fetchPostItem else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configureCell(fetchPostItem: fetchPostItem)
        cell.imageCollectionView.dataSource = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PostDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchPostItem = viewModel.fetchPostItem else { return 0 }
        return fetchPostItem.files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCollectionViewCell.identifier, for: indexPath) as? PostImageCollectionViewCell,
              let fetchPostItem = viewModel.fetchPostItem else {
            return UICollectionViewCell()
        }
        
        let fileString = fetchPostItem.files[indexPath.item]
        cell.configureCell(fileString: fileString)
        
        return cell
    }
}
