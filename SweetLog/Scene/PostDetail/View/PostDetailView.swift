//
//  PostDetailView.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit

final class PostDetailView: BaseView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        tableView.backgroundColor = Color.white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 0   // sticky header 해제
        
        tableView.register(PostDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: PostDetailHeaderView.identifier)
        tableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: PostCommentTableViewCell.identifier)
        
    }
}

