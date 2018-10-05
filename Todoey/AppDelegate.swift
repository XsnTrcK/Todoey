//
//  AppDelegate.swift
//  Todoey
//
//  Created by Alberto Ayala on 9/25/18.
//  Copyright © 2018 Alberto A Ayala. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let realmConfig = Realm.Configuration(schemaVersion: 1, migrationBlock: {
            migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Item.className(), { (_, newObject) in
                    if let newItem = newObject {
                        newItem["dateCreated"] = Date(timeIntervalSinceReferenceDate: 0)
                    }
                })
            }
        })
        
        Realm.Configuration.defaultConfiguration = realmConfig
        
        return true
    }
}

