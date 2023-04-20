//
//  AppDelegate.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        openFile()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func openFile()
    {
           let datos = UserData.sharedData()
           let ruta = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/Conf.plist"
           let urlArchivo = URL(fileURLWithPath: ruta)
           
           do {
               let archivo = try Data.init(contentsOf: urlArchivo)
               let diccionario = try PropertyListSerialization.propertyList(from: archivo, format: nil) as! [String:Any]
               
               datos.id = diccionario["id"] as! Int
               datos.name = diccionario["name"] as! String
               datos.ap_paterno = diccionario["app"] as! String
               datos.ap_materno = diccionario["apm"] as! String
               datos.email = diccionario["email"] as! String
               datos.phone_number = diccionario["phn"] as! String
               datos.rol_id = diccionario["rol"] as! Int
               datos.token = diccionario["tok"] as! String
               datos.rememberMe = diccionario["rmm"] as! Bool
               datos.signedRoute = diccionario["sgr"] as! String
           } catch {
               print("Algo salió mal")
           }
       }

}

