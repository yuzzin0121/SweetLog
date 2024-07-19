//
//  FollowDetailView.swift
//  SweetLog
//
//  Created by 조유진 on 4/29/24.
//

import UIKit

final class FollowDetailView: BaseView {
    let tableView = UITableView()
    let emptyLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(emptyLabel)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(14)
            make.horizontalEdges.bottom.equalToSuperview()
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
        tableView.register(FollowDetailTableViewCell.self, forCellReuseIdentifier: FollowDetailTableViewCell.identifier)
        tableView.rowHeight = 60
        
        emptyLabel.design(text: "유저가 없습니다. \n팔로우 또는 팔로잉을 해보세요", textColor: Color.gray, font: .pretendard(size: 15, weight: .medium), textAlignment: .center, numberOfLines: 2)
        emptyLabel.setLineSpacing(spacing: 8)
        emptyLabel.textAlignment = .center
    }
}
