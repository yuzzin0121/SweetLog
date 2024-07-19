//
//  PlaceAnnotation.swift
//  SweetLog
//
//  Created by 조유진 on 5/5/24.
//

import UIKit
import MapKit

final class PlaceAnnotation: NSObject, MKAnnotation {
    var title: String?
    @objc dynamic var coordinate: CLLocationCoordinate2D

    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

final class PlaceAnnotationView: MKAnnotationView {
    static var identifier = "PlaceAnnotationView"
    
    private let backgroundView = UIView()
    private let nameLabel = UILabel()
    let markImageView = UIImageView()
    lazy var stackView = UIStackView(arrangedSubviews: [nameLabel, markImageView])
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "place"
        configureHierachy()
        configureLayout()
        configureView()
    }
    private func configureHierachy() {
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
    }
    
    private func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(90)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView).inset(4)
        }
        markImageView.snp.makeConstraints { make in
            make.size.equalTo(34)
        }
    }
    
    private func configureView() {stackView.design(alignment: .center)
        nameLabel.design(textColor: Color.black, font: .pretendard(size: 12, weight: .semiBold), textAlignment: .center)
        markImageView.contentMode = .scaleAspectFit
        markImageView.tintColor = Color.brown
        stackView.design(spacing: 0)
    }
    
    // annotation이 뷰에서 표시되기 전에 호출된다.
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let annotation = annotation as? PlaceAnnotation else { return }
        PlaceAnnotationView.identifier = "PlaceAnnotationView"
        
        nameLabel.text = annotation.title
        markImageView.image = Image.markFill
        
        // 이미지의 크기 및 레이블의 사이즈가 변경될 수도 있으므로 레이아웃을 업데이트 한다.
        setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = CGSize(width: 90, height: 70)
        centerOffset = CGPoint(x: 0, y: 30)
    }
}
