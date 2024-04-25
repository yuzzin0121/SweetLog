//
//  PostDetailView.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit

final class PostDetailView: BaseView {
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.register(PostDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: PostDetailHeaderView.identifier)
    }
}

