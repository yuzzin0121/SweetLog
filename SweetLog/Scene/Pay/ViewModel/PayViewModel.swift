//
//  PayViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class PayViewModel {
    var disposeBag = DisposeBag()
    var postId: String
    var amount: String
    var name: String
    let paymentResponse = PublishRelay<String>()
    let paymentResult = PublishRelay<String>()
    
    init(postId: String, amount: String, name: String) {
        self.postId = postId
        self.amount = amount
        self.name = name
        transform()
    }
    
    private func transform() {
        guard let amountValue = Int(amount) else { return }
        paymentResponse
            .map {
                PaymentValidationQuery(impUID: $0, postId: self.postId, productName: self.name, price: amountValue)
            }
            .flatMap {
                return NetworkManager.shared.requestToServerNoModel(router: PaymentRouter.validation($0))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.paymentResult.accept("결제가 완료됐습니다")
                case .failure(_):
                    owner.paymentResult.accept("결제를 실패하였습니다")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getPayment() -> IamportPayment {
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
            amount: amount).then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = name
                $0.buyer_name = "조유진"
                $0.app_scheme = APIKey.appScheme.rawValue
        }
        return payment
    }
    
}
