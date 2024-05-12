//
//  PayViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import UIKit
import RxSwift
import iamport_ios

class PayViewController: BaseViewController {
    let mainView = PayView()
    var viewModel: PayViewModel
    
    init(postId: String, amount: String, name: String) {
        viewModel = PayViewModel(postId: postId, amount: amount, name: name)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        print(#function)
        Iamport.shared.paymentWebView(webViewMode: mainView.webView, userCode: APIKey.userCode.rawValue, payment: viewModel.getPayment()) { [weak self] iamportResponse in
            guard let self, let response = iamportResponse, let impUID = response.imp_uid else { return }
            
            self.viewModel.paymentResponse.accept(impUID)
        }
        
        viewModel.paymentResult
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.showAlert(title: "결제", message: message) {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationController?.isNavigationBarHidden = true
    }
}
