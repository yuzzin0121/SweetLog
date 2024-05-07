//
//  ClusterAnnotationView.swift
//  SweetLog
//
//  Created by 조유진 on 5/8/24.
//

import UIKit
import MapKit

class ClusterAnnotationView: MKAnnotationView {
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let places = cluster.memberAnnotations.count
            
            if count() > 0 {
                image = drawPlaceCount(count: places)
            }
        }
    }
    
    private func drawPlaceCount(count: Int) -> UIImage {
        return drawRatio(0, to: count, fractionColor: nil, wholeColor: UIColor.orangee)
    }

    
    private func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
            
            let attributes:[NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: Color.white,
                                                             NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 20)!]
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
    
    private func count() -> Int {
        guard let cluster = annotation as? MKClusterAnnotation else {
            return 0
        }
        return cluster.memberAnnotations.count
    }
}
