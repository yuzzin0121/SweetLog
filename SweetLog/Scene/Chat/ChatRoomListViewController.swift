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

        // Do any additional setup after loading the view.
    }

    override func loadView() {
        view = mainView
    }
}
