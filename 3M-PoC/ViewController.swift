//
//  ViewController.swift
//  3M-PoC
//
//  Created by Justin Hoyt on 5/29/19.
//  Copyright © 2019 Justin Hoyt. All rights reserved.
//

import UIKit
import AWSAppSync

class ViewController: UIViewController {
    var appSyncClient: AWSAppSyncClient?
    let proxyManager = ProxyManager.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        // Do any additional setup after loading the view.
        

        
        
        //Joe Louis AWS Queue Button Styling
        AddJoeLouisToQueue.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        AddJoeLouisToQueue.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        AddJoeLouisToQueue.layer.shadowOpacity = 1.0
        AddJoeLouisToQueue.layer.shadowRadius = 0.0
        AddJoeLouisToQueue.layer.masksToBounds = true
        AddJoeLouisToQueue.layer.cornerRadius = 10
        AddJoeLouisToQueue.titleLabel?.textAlignment = NSTextAlignment.center
        
        AddJoeLouisToQueue.titleEdgeInsets = UIEdgeInsets(top: 10, left: 150, bottom: 10, right: 10)
        AddJoeLouisToQueue.setTitleColor(UIColor.black, for: .normal)
        AddJoeLouisToQueue.setBackgroundImage(UIImage(named: "Assets/ipad_button_joe_louis.png"), for: .normal)

        //AddJoeLouisToQueue.imageView?.contentMode = .scaleAspectFit
        //AddJoeLouisToQueue.imageEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
        
        //Detroit Chimera AWS Queue Button Styling
        AddChimeraToQueue.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        AddChimeraToQueue.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        AddChimeraToQueue.layer.shadowOpacity = 1.0
        AddChimeraToQueue.layer.shadowRadius = 0.0
        AddChimeraToQueue.layer.masksToBounds = true
        AddChimeraToQueue.layer.cornerRadius = 10
        AddChimeraToQueue.titleLabel?.textAlignment = NSTextAlignment.center
        
        AddChimeraToQueue.titleEdgeInsets = UIEdgeInsets(top: 10, left: 150, bottom: 10, right: 10)
        AddChimeraToQueue.setTitleColor(UIColor.black, for: .normal)
        AddChimeraToQueue.setBackgroundImage(UIImage(named: "Assets/ipad_button_detroit_chimera.png"), for: .normal)
        //AddChimeraToQueue.imageView?.contentMode = .scaleAspectFit
        //AddChimeraToQueue.imageEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)

        //Construction AWS Queue Button Styling
        ConstructionToQueueButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        ConstructionToQueueButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        ConstructionToQueueButton.layer.shadowOpacity = 1.0
        ConstructionToQueueButton.layer.shadowRadius = 0.0
        ConstructionToQueueButton.layer.masksToBounds = true
        ConstructionToQueueButton.layer.cornerRadius = 10
        ConstructionToQueueButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        ConstructionToQueueButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 150, bottom: 10, right: 10)
        ConstructionToQueueButton.setTitleColor(UIColor.black, for: .normal)
        ConstructionToQueueButton.setBackgroundImage(UIImage(named: "Assets/ipad_button_road_work.png"), for: .normal)
  
        //Set Workers Present in 3M Database Button Styling
        SetWorkersPresentButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        SetWorkersPresentButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        SetWorkersPresentButton.layer.shadowOpacity = 1.0
        SetWorkersPresentButton.layer.shadowRadius = 0.0
        SetWorkersPresentButton.layer.masksToBounds = true
        SetWorkersPresentButton.layer.cornerRadius = 10
        SetWorkersPresentButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        SetWorkersPresentButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 150, bottom: 10, right: 10)
        SetWorkersPresentButton.setTitleColor(UIColor.black, for: .normal)
        SetWorkersPresentButton.setBackgroundImage(UIImage(named: "Assets/ipad_button_workers_present.png"), for: .normal)
        
        //Set No Workers Present in 3M Database Button Styling
        SetNoWorkersPresentButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        SetNoWorkersPresentButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        SetNoWorkersPresentButton.layer.shadowOpacity = 1.0
        SetNoWorkersPresentButton.layer.shadowRadius = 0.0
        SetNoWorkersPresentButton.layer.masksToBounds = true
        SetNoWorkersPresentButton.layer.cornerRadius = 10
        SetNoWorkersPresentButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        SetNoWorkersPresentButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 150, bottom: 10, right: 10)
        SetNoWorkersPresentButton.setTitleColor(UIColor.black, for: .normal)
        SetNoWorkersPresentButton.setBackgroundImage(UIImage(named: "Assets/ipad_button_workers_not_present.png"), for: .normal)
        
    }


    @IBAction func AddJoeLouistoQueue(_ sender: UIButton) {
        ProxyManager.sharedManager.postSQSMessage(urlString: "https://k28dw5onac.execute-api.us-east-2.amazonaws.com/prod/uuid", uuid: "B0EA8B0B1223")
    }
  
    
    @IBOutlet weak var AddJoeLouisToQueue: UIButton!
    @IBOutlet weak var AddChimeraToQueue: UIButton!
    @IBOutlet weak var ConstructionToQueueButton: UIButton!
    @IBOutlet weak var SetWorkersPresentButton: UIButton!
    @IBOutlet weak var SetNoWorkersPresentButton: UIButton!
    
    
    @IBAction func AddChimeratoAWSQueue(_ sender: UIButton) {
        ProxyManager.sharedManager.postSQSMessage(urlString: "https://k28dw5onac.execute-api.us-east-2.amazonaws.com/prod/uuid", uuid: "0A8E4C5B4892")
    }
    
    
    @IBAction func SetWorkersPresent(_ sender: UIButton) {
        print("Set Workers Present")
        ProxyManager.sharedManager.postSQSMessage(urlString: "http://3.214.237.29/sc_dynamic/smart_code/update_view/", uuid: "B9378CE25608", workers:"present")
    }
    
    @IBAction func SetNoWorkersPresent(_ sender: UIButton) {
        print("Set No Workers Present")
        ProxyManager.sharedManager.postSQSMessage(urlString: "http://3.214.237.29/sc_dynamic/smart_code/update_view/", uuid: "B9378CE25608", workers:"not present")
    }
    
    @IBAction func AddConstructiontoQueue(_ sender: UIButton) {
        ProxyManager.sharedManager.postSQSMessage(urlString: "https://k28dw5onac.execute-api.us-east-2.amazonaws.com/prod/uuid", uuid: "B9378CE25608")
//        let randomSpeed = String(Int.random(in:30 ... 55))
//        let randomLat = String(Float.random(in: 44.85 ... 44.9))
//        let randomLong = String(Float.random(in: -93.5 ... -93))
//        ProxyManager.sharedManager.postSQSMessage(urlString: "https://k28dw5onac.execute-api.us-east-2.amazonaws.com/prod/vehicle-data", uuid: "B9378CE25608", speed: randomSpeed, lat:randomLat, long:randomLong)
    }
    
    
    
    @IBAction func ResetUIButton(_ sender: UIButton) {
        ProxyManager.sharedManager.redirectHome()
    }
    
    //    func runMutation(){
//        let mutationInput = CreateTodoInput(name: "Use AppSync", description:"Realtime and Offline")
//        appSyncClient?.perform(mutation: CreateTodoMutation(input: mutationInput)) { (result, error) in
//            if let error = error as? AWSAppSyncClientError {
//                print("Error occurred: \(error.localizedDescription )")
//            }
//            if let resultError = result?.errors {
//                print("Error saving the item on server: \(resultError)")
//                return
//            }
//        }
//    }
//
//    func runQuery(){
//        appSyncClient?.fetch(query: ListTodosQuery(), cachePolicy: .returnCacheDataAndFetch) {(result, error) in
//            if error != nil {
//                print(error?.localizedDescription ?? "")
//                return
//            }
//            result?.data?.listTodos?.items!.forEach { print(($0?.name)! + " " + ($0?.description)!) }
//        }
//    }
//
//    func runMutation(){
//        let mutationInput = CreateTodoInput(name: "Use AppSync", description:"Realtime and Offline")
//        appSyncClient?.perform(mutation: CreateTodoMutation(input: mutationInput)) { [weak self] (result, error) in
//            // ... do whatever error checking or processing you wish here
//            self?.runQuery()
//        }
//    }
//
//    var discard: Cancellable?
//
//    func subscribe() {
//        do {
//            discard = try appSyncClient?.subscribe(subscription: OnCreateTodoSubscription(), resultHandler: { (result, transaction, error) in
//                if let result = result {
//                    print(result.data!.onCreateTodo!.name + " " + result.data!.onCreateTodo!.description!)
//                } else if let error = error {
//                    print(error.localizedDescription)
//                }
//            })
//        } catch {
//            print("Error starting subscription.")
//        }
//    }
}

