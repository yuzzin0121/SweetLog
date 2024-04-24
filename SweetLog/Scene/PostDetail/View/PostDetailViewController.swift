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

        
    }
    
    private func setData(fetchPostItem: FetchPostItem?) {
        guard let fetchPostItem else { return }
        
        navigationItem.title = "\(fetchPostItem.creator.nickname)님의 후기"
    }
    
    override func bind() {
        guard let postId = viewModel.postId else { return }
        print("postId: \(postId)")
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
