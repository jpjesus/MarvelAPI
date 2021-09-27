//
//  UINavigationController+Extensions.swift
//  MarvelApp
//
//  Created by Jesus Parada on 26/09/21.
//

import Foundation
import UIKit

// MARK: - Navigation Animations
extension UINavigationController {
    
    func clearNavigationBackground() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
    
    func pushFadeAnimation(viewController: UIViewController) {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
        view.layer.removeAllAnimations()
    }
    
    func popFadeAnimation() {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
        view.layer.removeAllAnimations()
    }
}
