//
//  ViewAppearanceProtocol.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 16/07/21.
//

import Foundation
import UIKit

protocol NavigationBarAppearance: class {
    func hideNavigationBar(isHidden: Bool)
}

extension NavigationBarAppearance where Self: UIViewController {
    func hideNavigationBar(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
    }
}
