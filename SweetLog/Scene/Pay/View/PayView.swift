//
//  PayView.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import Foundation
import WebKit
import iamport_ios

final class PayView: BaseView {
    lazy var webView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    func showPay(payment: IamportPayment) {
        print(#function)
        Iamport.shared.paymentWebView(webViewMode: webView,
                                      userCode: APIKey.userCode.rawValue,
                                      payment: payment) { iamportResponse in
            print(String(describing: iamportResponse))
        }
    }
    
    override func configureHierarchy() {
        addSubview(webView)
    }
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = Color.white
    }
}
