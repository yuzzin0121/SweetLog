//
//  FollowDetailView.swift
//  SweetLog
//
//  Created by 조유진 on 4/29/24.
//

import UIKit

final class FollowDetailView: BaseView {
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(14)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    override func configureView() {
        super.configureView()
        tableView.backgroundColor = .systemGray6
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FollowDetailTableViewCell.self, forCellReuseIdentifier: FollowDetailTableViewCell.identifier)
        tableView.rowHeight = 50
    }
}
