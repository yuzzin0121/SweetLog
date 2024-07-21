//
//  ChatRoomListViewController.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import UIKit
import RxSwift

final class ChatRoomListViewController: BaseViewController {
    private let mainView = ChatRoomListView()
    private let viewModel = ChatRoomListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = ChatRoomListViewModel.Input(viewDidLoad: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.chatRoomList
            .drive(mainView.tableView.rx.items(cellIdentifier: ChatRoomTableViewCell.identifier, cellType: ChatRoomTableViewCell.self)) { index, chatRoom, cell in
                print(chatRoom)
                cell.configureCell(chatRoom: chatRoom)
            }
            .disposed(by: disposeBag)
        
        output.chatRoomList
            .drive(with: self) { owner, chatRoomList in
                owner.mainView.setEmptyLabel(chatRoomList.isEmpty)
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "채팅방 리스트"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }
}
