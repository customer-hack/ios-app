//
//  ProxyManager.swift
//  3M-PoC
//
//  Created by Justin Hoyt on 5/30/19.
//  Copyright © 2019 Justin Hoyt. All rights reserved.
//

import Foundation
import SmartDeviceLink

class ProxyManager: NSObject {
//    let appName = "DOOM"
//    let fullAppId = "666"
    
    let appName = "3M"
    let fullAppId = "1446742213"
    
    // Manager
    fileprivate var sdlManager: SDLManager!

    // Singleton
    static let sharedManager = ProxyManager()


//    for mac emulator
//    let lifecycleConfiguration = SDLLifecycleConfiguration(appName: "App Name", fullAppId: "App Id", ipAddress: "IP Address", port: Port))

    private override init() {
        super.init()
        SDLLogConfiguration.default()

        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: fullAppId)

        let green = SDLRGBColor(red: 126, green: 188, blue: 121)
        let white = SDLRGBColor(red: 249, green: 251, blue: 254)
        let grey = SDLRGBColor(red: 186, green: 198, blue: 210)
        let darkGrey = SDLRGBColor(red: 57, green: 78, blue: 96)
        lifecycleConfiguration.dayColorScheme = SDLTemplateColorScheme(primaryRGBColor: green, secondaryRGBColor: grey, backgroundRGBColor: white)
        lifecycleConfiguration.nightColorScheme = SDLTemplateColorScheme(primaryRGBColor: green, secondaryRGBColor: grey, backgroundRGBColor: darkGrey)
        
        if let appImage = UIImage(named: "iconLogo") {
            let appIcon = SDLArtwork(image: appImage, name: "fordicon.jpg", persistent: true, as: .JPG)
            lifecycleConfiguration.appIcon = appIcon
        }
        
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .disabled(), logging: .default(), fileManager: .default())
        
        sdlManager = SDLManager(configuration: configuration, delegate: self as? SDLManagerDelegate)

    }
    
    func connect() {
        // Start watching for a connection with a SDL Core
        sdlManager.start { (success, error) in
            if success {
                // Your app has successfully connected with the SDL Core
                let display = SDLSetDisplayLayout(predefinedLayout: .graphicWithText)
                self.sdlManager.send(request: display) { (request, response, error) in
                    if response?.resultCode == .success {
                        // The template has been set successfully
                    }
                }
            }
        }
    }
    
    func insertText() {
        sdlManager.screenManager.beginUpdates()
        
        sdlManager.screenManager.textField1 = "hello"
        sdlManager.screenManager.textField2 = "world"
//        sdlManager.screenManager.primaryGraphic =
//        sdlManager.screenManager.softButtonObjects = [, ]
        
        sdlManager.screenManager.endUpdates { (error) in
            if error != nil {
//                Error Updating UI
            } else {
//                Update to UI was Successful
            }
        }
        
    }
}

