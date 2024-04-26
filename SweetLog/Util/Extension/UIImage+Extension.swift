//
//  UIImage+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//

import UIKit

extension UIImage {

    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
