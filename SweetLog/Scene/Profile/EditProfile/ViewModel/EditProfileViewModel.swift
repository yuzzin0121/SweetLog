//
//  EditProfileViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var currentProfileImageUrl: String?
    var currentNickname: String = ""
    
    struct Input {
        let nicknameText: Observable<String>
        let prfileImageData: Observable<Data?>
        let editProfileButtonTapped: Observable<Void>
    }
    
    struct Output {
        let validNickname: Driver<Bool>
        let totalValid: Driver<Bool>
        let editProfileSuccessTrigger: Driver<ProfileModel?>
    }
    
    func transform(input: Input) -> Output {
        let nicknameValid = BehaviorRelay(value: true)
        let imageDataValid = BehaviorRelay(value: true)
        let totalValid = PublishRelay<Bool>()
        let editProfileSuccessTrigger = PublishRelay<ProfileModel?>()
        
        // 닉네임 변경 시
        input.nicknameText
            .map {
                return $0.trimmingCharacters(in: [" "]).count > 1
            }
            .bind(with: self) { owner, isValid in
                nicknameValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        input.prfileImageData
            .subscribe { data in
                imageDataValid.accept(true)
            }
            .disposed(by: disposeBag)
        
        let isValid = Observable.combineLatest(nicknameValid, imageDataValid)
            .map { value in
                return value.0 && value.1
            }
        
        isValid
            .subscribe { isValid in
                totalValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        let editValue = Observable.combineLatest(input.nicknameText, input.prfileImageData)
            .map { value in
                print(value)
                return (value.0, value.1)
            }
        
        
        input.editProfileButtonTapped
            .withLatestFrom(editValue)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { editValue in
                print("클릭됨")
                return ProfileNetworkManager.shared.editMyProfile(nickname: editValue.0, profile: editValue.1)
                    .catch { error in
                        print(error.localizedDescription)
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profileModel in
                print(profileModel)
                editProfileSuccessTrigger.accept(profileModel)
            }
            .disposed(by: disposeBag)
        
        return Output(validNickname: nicknameValid.asDriver(onErrorJustReturn: false),
                      totalValid: totalValid.asDriver(onErrorJustReturn: false),
                      editProfileSuccessTrigger: editProfileSuccessTrigger.asDriver(onErrorJustReturn: nil))
    }
}
