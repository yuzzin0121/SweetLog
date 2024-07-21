//
//  ChatRoomViewController.swift
//  SweetLog
//
//  Created by 조유진 on 7/21/24.
//

import UIKit
import RxSwift

final class ChatRoomViewController: BaseViewController {
    private let mainView = ChatRoomView()
    private var viewModel: ChatRoomViewModel
    
    init(chatRoom: ChatRoom) {
        self.viewModel = ChatRoomViewModel(chatRoom: chatRoom)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        setNavigationTitle(userName: viewModel.chatRoom.participants[1].nick)
        
        let input = ChatRoomViewModel.Input(viewDidLoad: Observable.just(()))
        let output = viewModel.transform(input: input)
     
        
    }
    
    private func setNavigationTitle(userName: String) {
        navigationItem.title = userName
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }
}
