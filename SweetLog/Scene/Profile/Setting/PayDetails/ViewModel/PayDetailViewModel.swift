//
//  PayDetailViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PayDetailViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let fetchPayDetail: Observable<Void>
    }
    
    struct Output {
        let payDetailList: Driver<[PayDetail]>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let payDetailList = BehaviorRelay<[PayDetail]>(value: [])
        let errorString = PublishRelay<String>()

        input.fetchPayDetail
            .flatMap {
                NetworkManager.shared.requestToServer(model: PayDetailModel.self, router: PaymentRouter.payDetail)
            }
            .bind { result in
                switch result {
                case .success(let paymentDetailModel):
                    payDetailList.accept(paymentDetailModel.data)
                case .failure(let error):
                    errorString.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(payDetailList: payDetailList.asDriver(), errorString: errorString.asDriver(onErrorJustReturn: ""))
    }
}
