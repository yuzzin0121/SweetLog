//
//  PayDetailViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import UIKit
import RxSwift

class PayDetailViewController: BaseViewController {
    let mainView = PayDetailView()
    let viewModel = PayDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        let input = PayDetailViewModel.Input(fetchPayDetail: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.payDetailList
            .drive(mainView.tableView.rx.items(cellIdentifier: PayDetailTableViewCell.identifier, cellType: PayDetailTableViewCell.self)) { index, payDetail, cell in
                cell.selectionStyle = .none
                cell.configureCell(payDetail: payDetail)
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "결제 내역"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }
}
