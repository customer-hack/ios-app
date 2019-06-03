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
    
    func initialize_buttons() {
        self.sdlManager.screenManager.softButtonObjects = []
        
        if let joeLouisImage = UIImage(named: "JoeLouis.jpg"){
            let joeLouisArtwork = SDLArtwork(image: joeLouisImage, persistent: false, as: .JPG)
            let joeLouisSoftButtonState1 = SDLSoftButtonState(stateName: "Joe Louis Soft Button State 1", text: "Joe Louis", artwork: joeLouisArtwork)
            let joeLouisSoftButtonState2 = SDLSoftButtonState(stateName: "Joe Louis Soft Button State 2", text: "Go Back", artwork: joeLouisArtwork)
            let joeLouisSoftButtonObject = SDLSoftButtonObject(name: "Show Joe Louis", states: [joeLouisSoftButtonState1, joeLouisSoftButtonState2],
                                                              initialStateName: "Joe Louis Soft Button State 1") { (buttonPress, buttonEvent) in
                                                                guard buttonPress != nil else { return }
                                                                ProxyManager.sharedManager.updateScreen(image: joeLouisImage, text1: "Joe", text2: "Louis",
                                                                                                        template: .largeGraphicOnly)
            }
            self.sdlManager.screenManager.softButtonObjects.append(joeLouisSoftButtonObject)
        }
        
        if let chimeraImage = UIImage(named: "DetroitChimera.jpg"){
            let chimeraArtwork = SDLArtwork(image: chimeraImage, persistent: false, as: .JPG)
            let chimeraSoftButtonState1 = SDLSoftButtonState(stateName: "Chimera Soft Button State 1", text: "Detroit Chimera", artwork: chimeraArtwork)
            let chimeraSoftButtonState2 = SDLSoftButtonState(stateName: "Chimera Soft Button State 2", text: "Go Back", artwork: chimeraArtwork)
            let chimeraSoftButtonObject = SDLSoftButtonObject(name: "Show Chimera", states: [chimeraSoftButtonState1, chimeraSoftButtonState2],
                                                       initialStateName: "Chimera Soft Button State 1") { (buttonPress, buttonEvent) in
                guard buttonPress != nil else { return }
                ProxyManager.sharedManager.updateScreen(image: chimeraImage, text1: "Detroit", text2: "Chimera",
                                                        template: .largeGraphicOnly)
            }
            self.sdlManager.screenManager.softButtonObjects.append(chimeraSoftButtonObject)
        }
    }

    func connect() {
        // Start watching for a connection with a SDL Core
        sdlManager.start { (success, error) in
            if success {
                // Your app has successfully connected with the SDL Core
                self.initialize_buttons()
                if let appImage = UIImage(named: "JoeLouis.jpg") {
                    let retrievedSoftButtonObject = self.sdlManager.screenManager.softButtonObjectNamed("Soft Button Object Name")
                    retrievedSoftButtonObject?.transitionToNextState()
                    self.updateScreen(image: appImage, text1: "Joe", text2: "Louis", template: .graphicWithTextAndSoftButtons)
                }
            }
        }
    }

    func updateScreen(image: UIImage, text1: String, text2: String, template: SDLPredefinedLayout) {
        sdlManager.screenManager.beginUpdates()

        let artwork = SDLArtwork(image: image, persistent: false, as: .JPG)
        
        self.sdlManager.fileManager.upload(artwork: artwork) {
            (success, artworkName, bytesAvailable, error) in
            guard error == nil else { return }
            self.sdlManager.screenManager.primaryGraphic = artwork
        }

        sdlManager.screenManager.textField1 = text1
        sdlManager.screenManager.textField2 = text2

        sdlManager.screenManager.endUpdates { (error) in
            if error != nil {
                print("Error in sdlManager.screenManager.endUpdates")
            }
        }
        let display = SDLSetDisplayLayout(predefinedLayout: template)
        self.sdlManager.send(request: display) { (request, response, error) in
            if response?.resultCode == .success {
                // The template has been set successfully
            }
        }
    }
}
