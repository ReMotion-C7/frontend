//
//  AppDelegate.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.landscapeLeft

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
