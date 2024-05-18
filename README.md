# 달콤로그

## 한줄 소개
> 달콤로그는 빵, 케이크 등 빵을 좋아하는 사람들이 후기를 공유하고 소통할 수 있는 앱입니다.
<br>


## 스크린샷



## 핵심 기능
- 회원가입, 이메일 중복 확인, 로그인, 로그아웃, 탈퇴
- 후기 | 작성, 조회, 수정, 삭제
- 판매글 | 작성, 조회, 수정, 삭제
- 좋아요, 댓글 작성
- 태그 조회
- 팔로우, 팔로잉
- 프로필 화면 - 내가 쓴 후기, 좋아요한 후기 조회
- 지도에서 빵집 탐색, 상세 정보 조회 및 리뷰 조회
- 결제, 결제 내역 확인
<br><br>


## 주요 기술
- Router Pattern / Delegate Pattern 
- Alamofire / Codable 
- MVVM / RxSwift / RxDataSources
- Code-Based UI / SnapKit / Kingfisher
- TabMan, FloatingPanel
- CompositionalLayout, MapKit
<br><br>

## 핵심 구현
- MVVM 디자인 패턴을 적용하여 뷰와 비즈니스 로직을 분리
- Input / Output 패턴을 활용해 뷰모델의 입력과 출력을 명확하게 분리
- RxSwift을 활용하여 반응적인 비동기 처리 구현
- Alamofire에 Router 패턴과 Generic을 통해 네트워크 통신의 구조화 및 확장성 있는 네트워킹 구현
- 공통적인 디자인의 뷰를 재사용하기 위해 커스텀 뷰로 구성
- 이미지 및 컬러 등 반복적으로 사용되는 에셋을 enum을 통해 네임스페이스화하여 관리
- NotificationCenter를 활용해 다른 계층에 있는 뷰에 데이터 갱신
- protocol을 구현하여 셀에 공통적으로 사용되는 identifier, ViewModel에 Input-Output 패턴을 를 사용하도록 구성
- Alamofire RequestInterceptor를 활용한 accessToken 갱신 구현 JWT
- 후기 조회, 태그 검색에서 커서 기반 페이지네이션을 적용하여 뷰에 보여지는 만큼의 리소스만 요청
- 네트워크 요청에 대한 응답을 Single<Result<>> 타입으로 반환함으로써 명시적이고 간결하게 상태 처리
- RxDataSource를 활용하여 유연하고 확장 가능한 데이터 관리 구성
- multipart-form을 활용해 이미지를 서버에 전송

<br><br>

## 트러블 슈팅
1. **셀 재사용 시 이미지가 다른 포스트의 이미지로 나오는 문제**
- imageStackView = UIStackView가 아닌 서브뷰를 제거하여 해결
```
 override func prepareForReuse() {
    super.prepareForReuse()
	imageStackView.arrangedSubviews.forEach {
	  $0.removeFromSuperview()
	}
}
```
<br><br>

2. **Sever와 통신하면서 발생하는 공통적인 에러에 대한 처리**
- enum에 `LocalizedError` 프로토콜을 채택하여 각 상태 코드에 errorDescription을 정의
  → print(”에러 메시지”) 가 아닌 ```print(error.localizedDescription)```으로 에러 문구를 출력
  <br><br>
<Image src="https://github.com/yuzzin0121/SweetLog/assets/77273340/0dd178b7-7ae5-4bee-871f-76c61c944027" width=400 height=500></Image>
