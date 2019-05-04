//
//  AppDelegate.swift
//  getty
//
//  Created by Raven Weitzel on 5/2/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ModelManager.setProdConfigForDefaultRealm()

        return true
    }
}

