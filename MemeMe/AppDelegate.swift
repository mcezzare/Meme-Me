//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Mario Cezzare on 03/12/18.
//  Copyright © 2018 Mario Cezzare. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: - The shared model
    var memes = [Meme]()
    
    // MARK: - Default
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
}
