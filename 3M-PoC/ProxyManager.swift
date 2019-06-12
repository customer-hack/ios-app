//
//  ProxyManager.swift
//  3M-PoC
//
//  Created by Justin Hoyt on 5/30/19.
//  Copyright © 2019 Justin Hoyt. All rights reserved.
//

import Foundation
import SmartDeviceLink
import AWSSQS
import AWSCore
import Async

class ProxyManager: NSObject, XMLParserDelegate {
    let appName = "DOOM"
    let fullAppId = "666"

//    let appName = "3M"
//    let fullAppId = "1446742213"

    // Manager
    fileprivate var sdlManager: SDLManager!

    // Singleton
    static let sharedManager = ProxyManager()
    static let sqs = AWSSQS.default()
    static var latestSQSMessage: AWSSQSMessage?

//    for mac emulator
//    let lifecycleConfiguration = SDLLifecycleConfiguration(appName: "App Name", fullAppId: "App Id", ipAddress: "IP Address", port: Port))

    private override init() {
        super.init()
        SDLLogConfiguration.default()

        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: fullAppId)

        if let appImage = UIImage(named: "Assets/fordicon.jpg") {
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
                self.uploadImage(path: "Assets/FordLarge.png", imageType: .PNG)
                self.uploadImage(path: "Assets/DetroitChimera.jpg", imageType: .JPG)
                self.uploadImage(path: "Assets/JoeLouis.jpg", imageType: .JPG)
                self.uploadImage(path: "Assets/JoeLouisWide.png", imageType: .PNG)
                self.uploadImage(path: "Assets/JoeLouisMap240.png", imageType: .PNG)
                self.uploadImage(path: "Assets/ChimeraMap240.png", imageType: .PNG)
                self.uploadImage(path: "Assets/ChimeraWide.png", imageType: .PNG)
                self.initialize_buttons()
                self.redirectHome()
//                self.startBackgroundQueueListener()
            }
        }
    }

    func popMessageQueue() -> AWSSQSMessage? {
        let semaphore = DispatchSemaphore(value: 0)

        let reqReceive = AWSSQSReceiveMessageRequest()
        reqReceive?.queueUrl = "https://sqs.us-east-2.amazonaws.com/371900921998/camera_queue.fifo"
//        reqReceive?.waitTimeSeconds = 20
        reqReceive?.maxNumberOfMessages = 1
        reqReceive?.messageAttributeNames = ["All"]

        ProxyManager.sqs.receiveMessage(reqReceive!){ (result, err) in

            if let result = result {
                if let message = result.messages?[0] {
//                    print("TYPE: \(type(of: result.messages![0]))")
//                    print("SQS result: \(result)")
//                    print(self.get(attribute: "lat", from: result))

                    let reqDelete = AWSSQSDeleteMessageRequest()
                    reqDelete?.queueUrl = "https://sqs.us-east-2.amazonaws.com/371900921998/camera_queue.fifo"
                    reqDelete?.receiptHandle = result.messages![0].receiptHandle

//                    print("deleting item at: \(result.messages![0].body!))")
                    ProxyManager.sqs.deleteMessage(reqDelete!) { (err) in
                        if let err = err {
                            print("SQS Delete Error: \(err)")
                        } else {
//                            print("deleted item at: \(result.messages![0].body!))")
                        }
                    }
                    ProxyManager.latestSQSMessage = message
                } else {
                    ProxyManager.latestSQSMessage = nil
                }
            }
            if let err = err {
                print("SQS error: \(err)")
            }
            semaphore.signal()
        }

        semaphore.wait()

        return ProxyManager.latestSQSMessage
    }

    func get(attribute: String, from result: AWSSQSReceiveMessageResult) -> String {
        return result.messages![0].messageAttributes![attribute]!.stringValue!
    }

    func initialize_buttons() {
        self.sdlManager.screenManager.softButtonObjects = []
        let joeLouisImage = UIImage(named: "Assets/JoeLouisWide.png")!
        let joeLouisArtwork = SDLArtwork(image: joeLouisImage, persistent: false, as: .PNG)
        let joeLouisSoftButtonState1 = SDLSoftButtonState(stateName: "Joe Louis Soft Button State 1", text: "Joe Louis", artwork: joeLouisArtwork)
        let joeLouisSoftButtonState2 = SDLSoftButtonState(stateName: "Joe Louis Soft Button State 2", text: "Go Back", artwork: joeLouisArtwork)
        let joeLouisSoftButtonObject = SDLSoftButtonObject(name: "Show Joe Louis", states: [joeLouisSoftButtonState1, joeLouisSoftButtonState2], initialStateName: "Joe Louis Soft Button State 1") { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.showJoeLouisScreen()
        }
        self.sdlManager.screenManager.softButtonObjects.append(joeLouisSoftButtonObject)

        let chimeraImage = UIImage(named: "Assets/ChimeraWide.png")!
        let chimeraArtwork = SDLArtwork(image: chimeraImage, persistent: false, as: .PNG)
        let chimeraSoftButtonState1 = SDLSoftButtonState(stateName: "Chimera Soft Button State 1", text: "Detroit Chimera", artwork: chimeraArtwork)
        let chimeraSoftButtonState2 = SDLSoftButtonState(stateName: "Chimera Soft Button State 2", text: "Go Back", artwork: chimeraArtwork)
        let chimeraSoftButtonObject = SDLSoftButtonObject(name: "Show Chimera", states: [chimeraSoftButtonState1, chimeraSoftButtonState2],
                                                   initialStateName: "Chimera Soft Button State 1") { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            ProxyManager.sharedManager.updateScreen(image: chimeraImage, text1: "Detroit", text2: "Chimera", template: .largeGraphicOnly)
            sleep(5)
            ProxyManager.sharedManager.redirectHome()
        }
        self.sdlManager.screenManager.softButtonObjects.append(chimeraSoftButtonObject)
    }

    func redirectHome() {
        if let appImage = UIImage(named: "Assets/FordLarge.png") {
            let retrievedSoftButtonObject = self.sdlManager.screenManager.softButtonObjectNamed("Soft Button Object Name")
            retrievedSoftButtonObject?.transitionToNextState()
            let text1 = ("my speed is \(String(describing: getSpeed()))")
//            let text1 = "Ford"
            self.updateScreen(image: appImage, text1: text1, text2: "Mobility", template: .graphicWithTextAndSoftButtons)
        }
    }

    func updateScreen(image: UIImage, text1: String, text2: String, template: SDLPredefinedLayout) {
        sdlManager.screenManager.beginUpdates()

        let artwork = SDLArtwork(image: image, persistent: false, as: .JPG)

        sdlManager.screenManager.primaryGraphic = artwork
        sdlManager.screenManager.textField1 = text1
        sdlManager.screenManager.textField2 = text2

        let sdlChunk = [SDLTTSChunk(text: "i bleed oval blue!", type: .text)]
        let sdlSpeak = SDLSpeak.init(ttsChunks: sdlChunk)
        sdlManager.send(sdlSpeak)
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

    func uploadImage(path: String, imageType: SDLArtworkImageFormat) {
        if let image = UIImage(named: path) {
            let artwork = SDLArtwork(image: image, persistent: false, as: imageType)
            self.sdlManager.fileManager.upload(artwork: artwork) {
                (success, artworkName, bytesAvailable, error) in
                guard error == nil else { return }
            }
        }
    }

    func showJoeLouisScreen() {
        let joeLouisImage = UIImage(named: "Assets/JoeLouisWide.png")!
        ProxyManager.sharedManager.updateScreen(image: joeLouisImage, text1: "Joe", text2: "Louis", template: .largeGraphicOnly)
        sleep(5)
        ProxyManager.sharedManager.redirectHome()
    }

    func getSpeed() -> (NSNumber & SDLFloat)? {
        var speed: (NSNumber & SDLFloat)?
        let semaphore = DispatchSemaphore(value: 0)
        let getVehicleData = SDLGetVehicleData(accelerationPedalPosition: false, airbagStatus: false, beltStatus: false, bodyInformation: false, clusterModeStatus: false, deviceStatus: false, driverBraking: false, eCallInfo: false, emergencyEvent: false, engineTorque: false, externalTemperature: false, fuelLevel: false, fuelLevelState: false, gps: false, headLampStatus: false, instantFuelConsumption: false, myKey: false, odometer: false, prndl: false, rpm: false, speed: true, steeringWheelAngle: false, tirePressure: false, vin: false, wiperStatus: false)

        self.sdlManager.send(request:getVehicleData) { (request, response, error) in
            guard let response = response as? SDLGetVehicleDataResponse else { return }

            if let error = error {
                print("Encountered Error sending GetVehicleData: \(error)")
                let joeLouisImage = UIImage(named: "Assets/JoeLouisWide.png")!
                let text1 = "Error: \(error)"
                ProxyManager.sharedManager.updateScreen(image: joeLouisImage, text1: text1, text2: "Louis", template: .largeGraphicOnly)
                semaphore.signal()
                return
            }

            speed = response.speed
            if speed != nil {
                print(speed as Any)
            } else {
                print("Speed not found!")
            }
            semaphore.signal()
        }
        semaphore.wait()
        return speed
    }

    func startBackgroundQueueListener() {
        Async.background {
            while(true) {
                if let message = self.popMessageQueue() {
                    print("Item in the queue: \(message)")
                    print(message.messageAttributes!["uuid"]!.stringValue!)
                    if message.messageAttributes!["uuid"]!.stringValue! == "830C2041195F" {
                        print("----- Found 830C2041195F -----")
                        self.showJoeLouisScreen()
                    }
                } else {
                    print("Nothing in the queue!")
                }
            }
        }
    }
    
    func postSQSMessage(uuid:String){
        print("UUID: \(uuid)")
        let url = URL(string: "https://k28dw5onac.execute-api.us-east-2.amazonaws.com/prod/uuid")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "uuid": uuid,
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options:.prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        print("Request: \(request)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        
        task.resume()    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
