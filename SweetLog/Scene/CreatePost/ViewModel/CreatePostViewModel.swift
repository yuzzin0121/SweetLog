//
//  CreatePostViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CreatePostViewModel: ViewModelType {
    var placeItem: PlaceItem
    let filterList = FilterItem.allCases
    let contentTextViewPlaceholder = "후기를 작성해주세요"
    var disposeBag = DisposeBag()
    let postItem = BehaviorRelay<FetchPostItem?>(value: nil)
    var cuMode: CUMode
    
    init(placeItem: PlaceItem, cuMode: CUMode) {
        self.placeItem = placeItem
        self.cuMode = cuMode
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let editPostItem: Observable<FetchPostItem?>
        let categoryString: Observable<String>
        let starValue: Observable<Int>
        let reviewText: Observable<String>
        let tagText: Observable<String>
        let tagTextFieldEditDone: Observable<Void>
        let removeTag: Observable<Int>
        let imageDataList: Observable<[Data]>
        let createPostButtonTapped: Observable<Void>
    }
    
    struct Output {
        let categoryName: Driver<String>
        let starButtonTapped: Driver<Int>
        let reviewText: Driver<String>
        let imageDataList: Driver<[Data]>
        let tagList: Driver<[String]>
        let tagTextToEmpty: Driver<Void>
        let tagError: Driver<String>
        let createValid: Driver<Bool>
        let createPostSuccessTrigger: Driver<Void>
        let editImageDataList: Driver<[Data]>
        let editValid: Driver<Bool>
        let editPostSuccessTrigger: Driver<FetchPostItem>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let categoryName = BehaviorRelay(value: FilterItem.bread.title)
        let starButtonTapped = BehaviorRelay<Int>(value: 1)
        let reviewText = BehaviorRelay<String>(value: "")
        
        let tagText = BehaviorRelay<String>(value: "")
        let tagValid = PublishRelay<Bool>()
        let tagList = BehaviorRelay<[String]>(value: [])
        let tagTextToEmpty = PublishRelay<Void>()
        let tagError = PublishRelay<String>()
        
        let createValid = BehaviorRelay(value: false)
        let editValid = BehaviorRelay(value: true)
        let imageDataList = BehaviorRelay<[Data]>(value: [])
        let fileStringList = BehaviorRelay<[String]>(value: [])
        let createPostSuccessTrigger = PublishRelay<Void>()
        let editImageDataList = BehaviorRelay<[Data]>(value: [])
        let editPostSuccessTrigger = PublishRelay<FetchPostItem>()
        let errorMessage = PublishRelay<String>()
        
        input.viewDidLoadTrigger
            .subscribe(with: self) { owner, _ in
                var tagListValue = tagList.value
                let placeName = owner.getFirstWord(fullText: owner.placeItem.placeName)
                tagListValue.insert(placeName, at: 0)
                tagList.accept(tagListValue)
            }
            .disposed(by: disposeBag)
        
        input.categoryString
            .bind { categoryValue in
                categoryName.accept(categoryValue)
            }
            .disposed(by: disposeBag)
        
        input.imageDataList
            .bind { dataList in
                imageDataList.accept(dataList)
            }
            .disposed(by: disposeBag)
    
        
        if cuMode == .edit {
            input.editPostItem
                .bind(with: self) { owner, postItem in
                    guard let postItem, let starValue = Int(postItem.star), let categoryString = postItem.productId else { return }  // nil이면 그냥 return
                    reviewText.accept(String.unTaggedText(text: postItem.review))
                    var list = postItem.hashTags
                    list.remove(at: 0)
                    let placeName = owner.getFirstWord(fullText: owner.placeItem.placeName)
                    list.insert(placeName, at: 0)
                    tagList.accept(list)
                    let dataList = owner.getImageDatas(files: postItem.files)
                    editImageDataList.accept(dataList)
                    starButtonTapped.accept(starValue)
                    categoryName.accept(categoryString)
                }
                .disposed(by: disposeBag)
        }
        
        input.starValue
            .subscribe(with: self) { owner, index in
                print("starValue")
                starButtonTapped.accept(index)
            }
            .disposed(by: disposeBag)
        
        if cuMode == .create {
            Observable.combineLatest(input.reviewText, input.imageDataList)
                .map {
                    let text = $0.0.trimmingCharacters(in: [" "])
                    return !text.isEmpty && !$0.1.isEmpty
                }
                .subscribe { isValid in
                    createValid.accept(isValid)
                }
                .disposed(by: disposeBag)
        } else if cuMode == .edit {
            Observable.combineLatest(reviewText, imageDataList)
                .map {
                    let text = $0.0.trimmingCharacters(in: [" "])
                    return !text.isEmpty && !$0.1.isEmpty
                }
                .subscribe { isValid in
                    editValid.accept(isValid)
                }
                .disposed(by: disposeBag)
        }
        
        input.reviewText
            .bind { reviewTextValue in
                reviewText.accept(reviewTextValue)
            }
            .disposed(by: disposeBag)
        
        input.tagText
            .map { text in
                let trimmedText = text.trimmingCharacters(in: [" "])
                let isValid = trimmedText.count > 0 && trimmedText.count <= 10 && tagList.value.count <= 10
                return (trimmedText, isValid)
            }
            .subscribe { tagInfo in
                let (trimmedText, isValid) = tagInfo
                tagText.accept(trimmedText)
                tagValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        input.tagTextFieldEditDone
            .withLatestFrom(Observable.combineLatest(tagText, tagValid))
            .subscribe(with: self) { owner, tagInfo in
                let (tagText, tagValid) = tagInfo
                if tagValid {
                    var tagListValue = tagList.value
                    print("태그 값: \(tagText)")
                    let tagText =  owner.getFirstWord(fullText: tagText)
                    tagListValue.append(tagText)
                    tagList.accept(tagListValue)
                    tagTextToEmpty.accept(())
                    
                } else {
                    tagError.accept("1~10글자 범위로 입력해야합니다.")
                }
            }
            .disposed(by: disposeBag)
        
        input.removeTag
            .subscribe(with: self) { owner, index in
                let removedTagList = owner.removeTag(tagList: tagList.value, index: index)
                tagList.accept(removedTagList)
            }
            .disposed(by: disposeBag)
        
        let createObservable = Observable.combineLatest(input.categoryString, input.starValue, input.reviewText, tagList, fileStringList)
            .map { [weak self] categoryString, star, review, tagList, fileStringList in
                let postRequestModel = self?.getPostRequestModel(categoryString: categoryString,
                                                                 star: star,
                                                                 review: review,
                                                                 tagList: tagList,
                                                                 fileStringList: fileStringList)
                return postRequestModel
            }
        
        let editObservable = Observable.combineLatest(categoryName, starButtonTapped, reviewText, tagList, fileStringList)
            .map { [weak self] categoryString, star, review, tagList, fileStringList in
                print("할수있다 \(categoryString) \(star) \(review) \(tagList) \(fileStringList)")
                let postRequestModel = self?.getPostRequestModel(categoryString: categoryString,
                                                                 star: star,
                                                                 review: review,
                                                                 tagList: tagList,
                                                                 fileStringList: fileStringList)
                return postRequestModel
            }
        
        if cuMode == .create {  // 포스트 생성일 경우
            fileStringList
                .withLatestFrom(createObservable)
                .flatMap { [weak self] postRequestModel in
                    guard let self, let postRequestModel else { return Single<Result<FetchPostItem, Error>>.never() }
                    return NetworkManager.shared.requestToServer(model: FetchPostItem.self, router: PostRouter.createPost(postQuery: postRequestModel))
                }
                .subscribe { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(_):
                        createPostSuccessTrigger.accept(())
                    case .failure(let error):
                        errorMessage.accept(error.localizedDescription)
                    }
                }
                .disposed(by: disposeBag)
        } else if cuMode == .edit { // 포스트 수정일 경우
            fileStringList
                .withLatestFrom(editObservable)
                .flatMap { [weak self] postRequestModel in
                    print("우잉 \(postRequestModel)")
                    if fileStringList.value.isEmpty {
                        return Single<Result<FetchPostItem, Error>>.never()
                    }
                    guard let self, let postRequestModel, let postItem = self.postItem.value else {
//                        print(postRequestModel, self.postItem.value)
                        return Single<Result<FetchPostItem, Error>>.never()
                    }
                    return NetworkManager.shared.requestToServer(model: FetchPostItem.self, router: PostRouter.editPost(postId: postItem.postId, postQuery: postRequestModel))
                }
                .subscribe { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let fetchPostItem):
                        print("포스트 수정 성공")
                        editPostSuccessTrigger.accept((fetchPostItem))
                    case .failure(let error):
                        errorMessage.accept(error.localizedDescription)
                    }
                }
                .disposed(by: disposeBag)
        }
        
        // 이미지 파일들 서버로 post
        input.createPostButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.imageDataList)
            .flatMap { imageDataList in
                return PostNetworkManager.shared.uploadImages(imageDataList: imageDataList)
                    .catch { error in
                        return Single<FilesModel>.never()
                    }
            }
            .subscribe(with: self) { owner, filesModel in
                print("이미지 서버에 Post 성공")
                fileStringList.accept(filesModel.files)
            }
            .disposed(by: disposeBag)
        
        
        return Output(categoryName: categoryName.asDriver(),
                      starButtonTapped: starButtonTapped.asDriver(onErrorJustReturn: 5),
                      reviewText: reviewText.asDriver(),
                      imageDataList: imageDataList.asDriver(onErrorJustReturn: []),
                      tagList: tagList.asDriver(onErrorJustReturn: []),
                      tagTextToEmpty: tagTextToEmpty.asDriver(onErrorJustReturn: ()),
                      tagError: tagError.asDriver(onErrorJustReturn: ""),
                      createValid: createValid.asDriver(onErrorJustReturn: false),
                      createPostSuccessTrigger: createPostSuccessTrigger.asDriver(onErrorJustReturn: ()), 
                      editImageDataList: editImageDataList.asDriver(),
                      editValid: editValid.asDriver(),
                      editPostSuccessTrigger: editPostSuccessTrigger.asDriver(onErrorDriveWith: .empty()),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    private func getImageDatas(files: [String]) -> [Data] {
        var dataList: [Data] = []
        for file in files {
            PostNetworkManager.shared.getImageData(file: file) { data in
                if let data {
                    dataList.append(data)
                }
            }
        }
        print(#function, dataList)
        return dataList
    }
    
    private func removeTag(tagList: [String], index: Int) -> [String] {
        var tagList = tagList
        tagList.remove(at: index)
        return tagList
    }
 
    private func getPostRequestModel(categoryString: String, star: Int, review: String, tagList: [String] ,fileStringList: [String]) -> PostRequestModel? {
//        print(#function, placeItem.x, placeItem.y)
        guard let x = Double(placeItem.x), let y = Double(placeItem.y) else {
            print("여기 왜 nil이야? \(placeItem.x), \(placeItem.y) -> \(Double(placeItem.x)), \(Double(placeItem.y))")
            return nil }
        let lonLat = [x, y].description
        
        let review = appendTag(review: review, tagList: tagList)
        
        let postRequestModel = PostRequestModel(review: review,
                                                placeName: placeItem.placeName,
                                                address: placeItem.address,
                                                link: placeItem.placeUrl,
                                                lonlat: lonLat,
                                                star: String(star),
                                                product_id: categoryString,
                                                files: fileStringList)
        print("postRequestModel: \(postRequestModel)")
        return postRequestModel
    }
    
    
    private func appendTag(review: String, tagList: [String]) -> String {
        var review = review
        if !tagList.isEmpty {
            for tag in tagList {
                review.append(" #\(tag)")
            }
        }
        return review
    }
    
    private func getFirstWord(fullText: String) -> String {
        if let range = fullText.range(of: " ") { // 첫 번째 공백의 범위를 찾음
            let firstWord = fullText[..<range.lowerBound] // 공백 전까지의 범위를 추출
            return String(firstWord)
        }
        return fullText
    }
}
