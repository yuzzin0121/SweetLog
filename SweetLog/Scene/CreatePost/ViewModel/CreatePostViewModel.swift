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
        let starButtonTapped: Driver<Int>
        let reviewText: Driver<String>
        let imageDataList: Driver<[Data]>
        let tagList: Driver<[String]>
        let tagTextToEmpty: Driver<Void>
        let tagError: Driver<String>
        let createValid: Driver<Bool>
        let createPostSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let starButtonTapped = PublishRelay<Int>()
        let reviewText = BehaviorRelay<String>(value: "")
        let tagText = BehaviorRelay<String>(value: "")
        let tagValid = PublishRelay<Bool>()
        let tagList = BehaviorRelay<[String]>(value: [])
        let tagTextToEmpty = PublishRelay<Void>()
        let tagError = PublishRelay<String>()
        let createValid = BehaviorRelay(value: false)
        let imageDataList = BehaviorRelay<[Data]>(value: [])
        let fileStringList = PublishSubject<[String]>()
        let createPostSuccessTrigger = PublishRelay<Void>()
        
        let contentObservable = Observable.combineLatest(input.categoryString, input.starValue, input.reviewText, tagList, fileStringList)
            .map { [weak self] categoryString, star, review, tagList, fileStringList in
                let postRequestModel = self?.getPostRequestModel(categoryString: categoryString,
                                                                 star: star,
                                                                 review: review,
                                                                 tagList: tagList,
                                                                 fileStringList: fileStringList)
                return postRequestModel
            }
        
        input.imageDataList
            .debug()
            .bind { dataList in
                imageDataList.accept(dataList)
            }
            .disposed(by: disposeBag)
        
        input.starValue
            .subscribe(with: self) { owner, index in
                print("starValue")
                starButtonTapped.accept(index)
            }
            .disposed(by: disposeBag)
        
        input.editPostItem
            .debug()
            .bind(with: self) { owner, postItem in
                guard let postItem, let starValue = Int(postItem.star) else { return }  // nil이면 그냥 return
                print("별 \(starValue)")
                reviewText.accept(String.unTaggedText(text: postItem.review))
                var list = postItem.hashTags
                list.remove(at: 0)
                tagList.accept(list)
                let dataList = owner.getImageDatas(files: postItem.files)
                imageDataList.accept(dataList)
                starButtonTapped.accept(starValue)
            }
            .disposed(by: disposeBag)

        
        input.viewDidLoadTrigger
            .subscribe(with: self) { owner, _ in
                var tagListValue = tagList.value
                let placeName = owner.getFirstWord(fullText: owner.placeItem.placeName)
                tagListValue.insert(placeName, at: 0)
                tagList.accept(tagListValue)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.reviewText, input.imageDataList)
            .map {
                let text = $0.0.trimmingCharacters(in: [" "])
                return !text.isEmpty && !$0.1.isEmpty
            }
            .subscribe { isValid in
                createValid.accept(isValid)
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
            .debug()
            .subscribe(with: self) { owner, filesModel in
                fileStringList.onNext(filesModel.files)
            }
            .disposed(by: disposeBag)
        
        fileStringList
            .withLatestFrom(contentObservable)
            .flatMap { postRequestModel in
                PostNetworkManager.shared.createPost(postRequestModel: postRequestModel)
                    .catch { error in
                        return Single<FetchPostItem>.never()
                    }
            }
            .debug()
            .subscribe { fetchPostItem in
                createPostSuccessTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        
        return Output(starButtonTapped: starButtonTapped.asDriver(onErrorJustReturn: 5),
                      reviewText: reviewText.asDriver(),
                      imageDataList: imageDataList.asDriver(onErrorJustReturn: []),
                      tagList: tagList.asDriver(onErrorJustReturn: []),
                      tagTextToEmpty: tagTextToEmpty.asDriver(onErrorJustReturn: ()),
                      tagError: tagError.asDriver(onErrorJustReturn: ""),
                      createValid: createValid.asDriver(onErrorJustReturn: false),
                      createPostSuccessTrigger: createPostSuccessTrigger.asDriver(onErrorJustReturn: ()))
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
        guard let x = Double(placeItem.x), let y = Double(placeItem.y) else { return nil }
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
