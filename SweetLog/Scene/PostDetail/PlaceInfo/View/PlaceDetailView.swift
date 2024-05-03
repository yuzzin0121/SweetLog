//
//  PlaceView.swift
//  SweetLog
//
//  Created by 조유진 on 5/2/24.
//

import Foundation
import MapKit
import LinkPresentation

final class PlaceDetailView: BaseView {
    private let mapView = MKMapView()
    private let placeNameLabel = UILabel()
    let markImageView = UIImageView()
    let placeAddressLabel = UILabel()
    let placeStackView = UIStackView()
    let placeBackgroundView = UIView()
    private let linkView = LPLinkView(frame: .zero)
    
    func setLinkView(metaData: LPLinkMetadata?) {
        guard let metaData else {
            return
        }
        linkView.isHidden = false
        linkView.metadata = metaData
    }
    
    func setCoordinate(center: CLLocationCoordinate2D, placeName: String) {
        // 값이 낮을수록 화면을 확대/높으면 축소
        setLocation(center: center)
        setAnnotation(center: center, placeName: placeName)
    }
    
    func setLocation(center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005,
                                    longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    func setAnnotation(center: CLLocationCoordinate2D, placeName: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        
        annotation.title = placeName
        
        // 맵뷰에 Annotaion 추가
        mapView.addAnnotation(annotation)
    }
    
    func setPlaceAddress(placeName: String, address: String) {
        placeNameLabel.text = placeName
        placeAddressLabel.text = address
        adjustLabelHeight()
    }
    
    func adjustLabelHeight() {
        let maxSize = CGSize(width: placeStackView.frame.width - 30, height: CGFloat.greatestFiniteMagnitude) // 여백 고려
        let expectedSize = placeAddressLabel.sizeThatFits(maxSize)
        print("expectedSize \(expectedSize)")
        // 텍스트 길이에 따라 조건적으로 높이 업데이트
        placeAddressLabel.snp.updateConstraints { make in
            if expectedSize.height > 20 { // someThreshold는 조건에 맞는 텍스트 높이입니다.
                make.height.equalTo(42) // 텍스트 높이의 2배로 설정
            } else {
                make.height.equalTo(21) // 예상된 텍스트 높이로 설정
            }
        }
    }
    
    override func configureHierarchy() {
        addSubviews([mapView, placeNameLabel, placeBackgroundView, linkView])
        placeBackgroundView.addSubview(placeStackView)
        [markImageView, placeAddressLabel].forEach {
            placeStackView.addArrangedSubview($0)
        }
    }
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(UIScreen.main.bounds.height * 0.35)
        }
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        placeBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        placeStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(placeBackgroundView).inset(12)
            $0.top.equalTo(placeBackgroundView).offset(8)
            $0.bottom.equalTo(placeBackgroundView).offset(-8)
        }
        
        markImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        linkView.snp.makeConstraints { make in
            make.top.equalTo(placeBackgroundView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
    override func configureView() {
        super.configureView()
        
        mapView.layer.cornerRadius = 8
        mapView.clipsToBounds = true
        
        
        placeNameLabel.design(textColor: Color.darkBrown, font: .pretendard(size: 20, weight: .semiBold))
        placeStackView.design(axis: .horizontal, alignment: .center, spacing: 12)
   
        
        placeBackgroundView.backgroundColor = Color.gray2
        placeBackgroundView.layer.cornerRadius = 10
        
        markImageView.image = Image.markFill
        markImageView.contentMode = .scaleAspectFit
        
        placeAddressLabel.design(textColor: Color.gray3, font: .pretendard(size: 16, weight: .medium), numberOfLines: 2)
        
        linkView.isHidden = true
    }
}
