//
//  ChatRoomListViewController.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import UIKit

final class ChatRoomListViewController: BaseViewController {
    private let mainView = ChatRoomListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "채팅방 리스트"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }
}
