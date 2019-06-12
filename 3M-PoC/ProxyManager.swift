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
//    let appName = "DOOM"
//    let fullAppId = "666"

    let appName = "3M"
    let fullAppId = "1446742213"

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
                //self.initialize_buttons()
                //self.getSpeed()
                self.redirectHome()
                self.startBackgroundQueueListener()
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
            self.redirectHome()
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
        if let appImage = UIImage(named: "Assets/3m_ford_banner.png") {
            //let retrievedSoftButtonObject = self.sdlManager.screenManager.softButtonObjectNamed("Soft Button Object Name")
            //retrievedSoftButtonObject?.transitionToNextState()
            
            self.updateScreen(image: appImage, template: .largeGraphicOnly)
        }
    }

    func updateScreen(image: UIImage, text1: String = "", text2: String = "", template: SDLPredefinedLayout, imageFormat: SDLArtworkImageFormat = .JPG ) {
        sdlManager.screenManager.beginUpdates()

        let artwork = SDLArtwork(image: image, persistent: false, as: imageFormat)

        sdlManager.screenManager.primaryGraphic = artwork
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

    func uploadImage(path: String, imageType: SDLArtworkImageFormat) {
        if let image = UIImage(named: path) {
            let artwork = SDLArtwork(image: image, persistent: false, as: imageType)
            self.sdlManager.fileManager.upload(artwork: artwork) {
                (success, artworkName, bytesAvailable, error) in
                guard error == nil else { return }
            }
        }
    }

    func showCameraEvent(image: UIImage, text1: String = "", text2: String = "", template: SDLPredefinedLayout, speechMessage: String = "", delay:UInt32 = 10) {
        updateScreen(image: image, text1: text1, text2: text2, template: template)
        if speechMessage != "" {
            speak(speechMessage: speechMessage)
        }
        sleep(delay)
    }
    
    func speak(speechMessage: String) {
        let sdlChunk = [SDLTTSChunk(text: speechMessage, type: .text)]
        let sdlSpeak = SDLSpeak.init(ttsChunks: sdlChunk)
        sdlManager.send(sdlSpeak)
    }

    func getSpeed() {

        let getVehicleData = SDLGetVehicleData()
        getVehicleData.speed = true as NSNumber & SDLBool

        self.sdlManager.send(request:getVehicleData) { (request, response, error) in
            guard let response = response as? SDLGetVehicleDataResponse else { return }
            let isAllowed = self.sdlManager.permissionManager.isRPCAllowed("SDLGetVehicleData")
            let text2 = isAllowed.description

            if let error = error {
                print("Encountered Error sending GetVehicleData: \(error)")
                let joeLouisImage = UIImage(named: "Assets/JoeLouisWide.png")!
                let text1 = "Error: \(error)"
                ProxyManager.sharedManager.updateScreen(image: joeLouisImage, text1: text1, text2: text2, template: .graphicWithText)
                return
            }

            let speed = response.speed
            if speed != nil {
                print(speed as Any)
                let joeLouisImage = UIImage(named: "Assets/JoeLouisWide.png")!
                let text1 = "The speed is \(String(describing: speed))"
                ProxyManager.sharedManager.updateScreen(image: joeLouisImage, text1: text1, text2: text2, template: .graphicWithText)
                
            } else {
                print("Speed not found!")
                let joeLouisImage = UIImage(named: "Assets/JoeLouisWide.png")!
                let text1 = "Error: The speed is nil"
                ProxyManager.sharedManager.updateScreen(image: joeLouisImage, text1: text1, text2: text2, template: .graphicWithText)
            }
        }
    }

    func startBackgroundQueueListener() {
        Async.background {
            while(true) {
                if let message = self.popMessageQueue() {
                    print("Item in the queue: \(message)")
                    print(message.messageAttributes!["uuid"]!.stringValue!)
                    if message.messageAttributes!["uuid"]!.stringValue! == "B0EA8B0B1223" {
                        print("----- Found Joe Louis -----")
                        let navImage = UIImage(named: "Assets/JoeLouisMap240.png")!
                        //let longText = "Monument to Joe Louis. The 8000 pound, 24 foot long sculpture, honors boxer Joe Louis, who grew up in Black Bottom, a former African-American neighborhood on Detroit’s east side. Lewis was the heavyweight champion of the world from 1937 to 1950. He is largely regarded as the first African American to become a national hero, with his 1938 defeat of the German boxer Max Schmeling coming to symbolize both the breaking of racial barriers and the rise of American power leading up to World War 2"
                        let longText = message.messageAttributes!["text_to_speech"]!.stringValue!
                        self.showCameraEvent(image: navImage, template: .largeGraphicOnly, speechMessage: longText, delay:10)
                        let image = UIImage(named: "Assets/JoeLouisWide.png")!
                        self.showCameraEvent(image: image, template: .largeGraphicOnly, delay:23)
                        
                    } else if message.messageAttributes!["uuid"]!.stringValue! == "0A8E4C5B4892"  || message.messageAttributes!["uuid"]!.stringValue! == "749324AD9639" {
                        print("----- Found Detroit Chimera -----")
                        //let longText = "On a large wall of Russell Industrial Center is Michigan's largest graffiti mural. Measuring 8,750 square feet, the mural is the work of artist Kobie Solomon. The symbolism is a Chimera representing Detroit’s official teams: head — The Detroit Lions (football), stripe — The Detroit Tigers (baseball),  wings — The Detroit Redwings (hockey), and chest/joints — The Detroit Pistons (basketball)."
                        let longText = message.messageAttributes!["text_to_speech"]!.stringValue!

                        let navImage = UIImage(named: "Assets/ChimeraMap240.png")!
                        self.showCameraEvent(image: navImage, template: .largeGraphicOnly, speechMessage: longText, delay:10)
                        let image = UIImage(named: "Assets/ChimeraWide.png")!
                        self.showCameraEvent(image: image, template: .largeGraphicOnly, delay:16)
                    } else if message.messageAttributes!["uuid"]!.stringValue! == "B9378CE25608" {
                        print("----- Found Work Zone Ahead -----")
                        let image = UIImage(named: "Assets/sync_road_work.png")!
                        //let longText = "Caution, there are workers present performing road work ahead.  Please reduce speed."
                        let longText = message.messageAttributes!["text_to_speech"]!.stringValue!
                        let text_field1 = message.messageAttributes!["text_field1"]!.stringValue!
                        let text_field2 = message.messageAttributes!["text_field2"]!.stringValue!

                        
                        self.showCameraEvent(image: image, text1: text_field1, text2: text_field2 , template: .graphicWithText, speechMessage: longText)
                        
                        //Post back Speed and Location
                        let randomSpeed = String(Int.random(in:30 ... 55))
                        let randomLat = String(Float.random(in: 44.85 ... 44.9))
                        let randomLong = String(Float.random(in: -93.5 ... -93))
                        self.postSQSMessage(urlString: "https://k28dw5onac.execute-api.us-east-2.amazonaws.com/prod/vehicle-data", uuid: message.messageAttributes!["uuid"]!.stringValue!, speed: randomSpeed, lat:randomLat, long:randomLong)

                    }
                } else {
                    print("Nothing in the queue!")
                }
                
                
                ProxyManager.sharedManager.redirectHome()

            }
        }
    }
    
    func postSQSMessage(urlString:String, uuid: String, speed: String="0", lat: String="0", long: String="0", workers:String="0"){
        print("UUID: \(uuid)")
        print("Speed: \(speed)")
        print("Lat: \(lat)")
        print("Long: \(long)")
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        var parameters : [String:Any]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        if lat != "0" && long != "0"{
             parameters = [
                "uuid": uuid,
                "speed" : speed,
                "latitude" : lat,
                "longitude" : long
            ]
        } else if workers == "0" {
            parameters = [
                "uuid": uuid,
                "contrast": 0.5
            ]
        } else {
            request.addValue("Bearer FSmybd40tZMepnG0xBAelCavjruDqP", forHTTPHeaderField: "Authorization")
            
            if workers == "present"{
                parameters = [
                    "uuid": uuid,
                    "dynamic_data": [
                        "work_zone" : "true",
                        "message": "message_text",
                        "contact": "www.3m.com"
                        ]
                    ]
       
            }else{
                parameters = [
                    "uuid": uuid,
                    "dynamic_data": [
                        "message": "message_text",
                        "contact": "www.3m.com"
                    ]
                ]
            }
        }
        print(parameters)
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
        
        task.resume()
        
    }
    
    

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



