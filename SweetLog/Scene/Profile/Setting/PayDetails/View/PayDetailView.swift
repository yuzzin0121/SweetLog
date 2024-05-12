//
//  PayDetailView.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import UIKit

final class PayDetailView: BaseView {
    let tableView = UITableView()
    override func configureHierarchy() {
        addSubview(tableView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = Color.white
        tableView.backgroundColor = Color.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(PayDetailTableViewCell.self, forCellReuseIdentifier: PayDetailTableViewCell.identifier)
    }
}
