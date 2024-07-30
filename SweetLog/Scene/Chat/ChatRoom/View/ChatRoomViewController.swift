//
//  ChatRoomViewController.swift
//  SweetLog
//
//  Created by 조유진 on 7/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ChatRoomViewController: BaseViewController {
    private let mainView = ChatRoomView()
    private var viewModel: ChatRoomViewModel
    private let isTextEmpty = BehaviorRelay(value: true)
    let sendContent = PublishRelay<String>()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfChat>!
    
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
        configureCollectionViewDataSource()
        
        
        let input = ChatRoomViewModel.Input(viewDidLoad: Observable.just(()),
                                            sendButtonTapped: mainView.sendButton.rx.tap.asObservable(), 
                                            sendContent: sendContent.asObservable())
        let output = viewModel.transform(input: input)
        
        output.sectionChatDataList
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
   
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
        
        output.sendContentSuccess
            .drive(with: self) { owner, _ in
                owner.mainView.setEmptyInputTextView()
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
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        let text = textView.text.trimmingCharacters(in: [" "])
//        
//    }
}

extension ChatRoomViewController {
    private func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfChat>(configureCell: { dataSource, collectionView, indexPath, chatData in
//            print(chatData)
            switch dataSource[indexPath] {
            case .userChatData(let userChat):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserChatCollectionViewCell.identifier, for: indexPath) as? UserChatCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configureCell(chat: userChat)
                
                return cell
            case .myChatData(let myChat):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChatCollectionViewCell.identifier, for: indexPath) as? MyChatCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configureCell(chat: myChat)
                
                return cell
                
            case .dateData(let dateData):
                return UICollectionViewCell()
            }
        })
    }
}
