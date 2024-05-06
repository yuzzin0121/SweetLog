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
    var currentNickname: String
    
    init(currentProfileImage: String?, currentNickname: String) {
        self.currentProfileImageUrl = currentProfileImage
        self.currentNickname = currentNickname
    }
    
    struct Input {
        let nicknameText: Observable<String>
        let prfileImageData: Observable<Data?>
        let editProfileButtonTapped: Observable<Void>
    }
    
    struct Output {
        let currentProfileImage: Driver<String?>
        let currentNicknameText: Driver<String>
        let nicknameText: Driver<String>
        let validNickname: Driver<Bool>
        let totalValid: Driver<Bool>
        let editProfileSuccessTrigger: Driver<ProfileModel?>
    }
    
    func transform(input: Input) -> Output {
        let currentProfileImage = BehaviorRelay<String?>(value: currentProfileImageUrl)
        let currentNicknameText = BehaviorRelay(value: currentNickname)
        let nicknameText = BehaviorRelay<String>(value: "")
        let imageData = BehaviorRelay<Data?>(value: nil)
        let nicknameValid = BehaviorRelay(value: true)
        let totalValid = PublishRelay<Bool>()
        let editProfileSuccessTrigger = PublishRelay<ProfileModel?>()
        
        // 닉네임 변경 시
        input.nicknameText
            .map {
                let text = $0.trimmingCharacters(in: [" "])
                nicknameValid.accept(text.count > 1)
                return text
            }
            .bind(with: self) { owner, nickname in
                nicknameText.accept(nickname)
            }
            .disposed(by: disposeBag)
        
        
        input.prfileImageData
            .subscribe { data in
                imageData.accept(data)
            }
            .disposed(by: disposeBag)
        
        input.editProfileButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { profileImageData in
                let nickname = nicknameText.value
                if nicknameValid.value == false {
                    return Single<ProfileModel>.never()
                }
                return ProfileNetworkManager.shared.editMyProfile(nickname: nickname, profile: imageData.value)
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
        
        return Output(currentProfileImage: currentProfileImage.asDriver(onErrorJustReturn: nil),
                      currentNicknameText: currentNicknameText.asDriver(),
                      nicknameText: nicknameText.asDriver(onErrorJustReturn: ""),
                      validNickname: nicknameValid.asDriver(onErrorJustReturn: false),
                      totalValid: totalValid.asDriver(onErrorJustReturn: false),
                      editProfileSuccessTrigger: editProfileSuccessTrigger.asDriver(onErrorJustReturn: nil))
    }
}
