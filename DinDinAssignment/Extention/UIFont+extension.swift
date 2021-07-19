//
//  UIFont+extension.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 17/07/21.
//

import UIKit

extension UIFont {
    class func regular(of size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    class func bold(of size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
