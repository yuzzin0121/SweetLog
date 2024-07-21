//
//  ChatRoomViewController.swift
//  SweetLog
//
//  Created by 조유진 on 7/21/24.
//

import UIKit

final class ChatRoomViewController: BaseViewController {
    private let mainView = ChatRoomView()
    private var viewModel: ChatRoomViewModel
    
    init(roomId: String) {
        self.viewModel = ChatRoomViewModel(roomId: roomId)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }
}
