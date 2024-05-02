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
    let mapView = MKMapView()
    private let linkView = LPLinkView(frame: .zero)
    
    func setLinkView(metaData: LPLinkMetadata) {
        print(metaData)
        linkView.metadata = metaData
    }
    
    override func configureHierarchy() {
        addSubviews([mapView, linkView])
    }
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(UIScreen.main.bounds.height * 0.4)
        }
        linkView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
    override func configureView() {
        super.configureView()
        
        mapView.layer.cornerRadius = 8
        mapView.clipsToBounds = true
    }
}
