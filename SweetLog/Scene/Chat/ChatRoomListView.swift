//
//  ChatRoomListView.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import UIKit

final class ChatRoomListView: BaseView {
    let tableView = UITableView()
    let emptyLabel = UILabel()
    
    func setEmptyLabel(_ isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
    }
    
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(emptyLabel)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(14)
            make.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
        tableView.backgroundColor = Color.white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.identifier)
        tableView.rowHeight = 70
        
        emptyLabel.design(text: "현재 채팅하는 유저가 없습니다", textColor: Color.gray, font: .pretendard(size: 15, weight: .medium), textAlignment: .center, numberOfLines: 2)
        emptyLabel.setLineSpacing(spacing: 8)
        emptyLabel.textAlignment = .center
    }
}
