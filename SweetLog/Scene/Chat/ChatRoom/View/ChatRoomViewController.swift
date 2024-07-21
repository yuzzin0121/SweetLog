//
//  ChatRoomViewController.swift
//  SweetLog
//
//  Created by 조유진 on 7/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatRoomViewController: BaseViewController {
    private let mainView = ChatRoomView()
    private var viewModel: ChatRoomViewModel
    private let isTextEmpty = BehaviorRelay(value: true)
    let sendContent = PublishRelay<String>()
    
    init(chatRoom: ChatRoom) {
        self.viewModel = ChatRoomViewModel(chatRoom: chatRoom)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
    }
    
    override func bind() {
        setNavigationTitle(userName: viewModel.chatRoom.participants[1].nick)
        
        let input = ChatRoomViewModel.Input(viewDidLoad: Observable.just(()),
                                            sendButtonTapped: mainView.sendButton.rx.tap.asObservable(), 
                                            sendContent: sendContent.asObservable())
        let output = viewModel.transform(input: input)
     
        isTextEmpty
            .asDriver()
            .drive(with: self) { owner, isTextEmpty in
                owner.mainView.isTextEmpty(isTextEmpty)
            }
            .disposed(by: disposeBag)
        
        output.sendButtonTapped
            .drive(with: self) { owner, _ in
                owner.sendConent()
            }
            .disposed(by: disposeBag)
    }
    
    private func sendConent() {
        let content = mainView.inputTextView.text.trimmingCharacters(in: [" "])
        if !content.isEmpty {
            sendContent.accept(content)
        }
    }
    
    private func setDelegate() {
        mainView.inputTextView.delegate = self
    }
    
    @objc private func sendButtonTapped(_ button: UIButton) {
        let content = mainView.inputTextView.text.trimmingCharacters(in: [" "])
        
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

extension ChatRoomViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: [" "])
        isTextEmpty.accept(text.isEmpty)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: [" "])
        
    }
}
