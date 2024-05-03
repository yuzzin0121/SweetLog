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
    let placeInfoView = PlaceInfoView()
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
        placeInfoView.placeNameLabel.text = placeName
        placeInfoView.addressLabel.text = address
    }
    
    override func configureHierarchy() {
        addSubviews([mapView, placeInfoView, linkView])
    }
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(UIScreen.main.bounds.height * 0.35)
        }
        
        placeInfoView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        linkView.snp.makeConstraints { make in
            make.top.equalTo(placeInfoView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            linkView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        }
    }
    override func configureView() {
        super.configureView()
        
        mapView.layer.cornerRadius = 8
        mapView.clipsToBounds = true
        
        placeNameLabel.design(textColor: Color.darkBrown, font: .pretendard(size: 20, weight: .semiBold))
        
        markImageView.image = Image.markFill
        markImageView.contentMode = .scaleAspectFit
        
        linkView.isHidden = true
    }
}
