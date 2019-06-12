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
        AddJoeLouisToQueue.layer.masksToBounds = false
        AddJoeLouisToQueue.layer.cornerRadius = 10
        AddJoeLouisToQueue.titleLabel?.textAlignment = NSTextAlignment.center
        
        AddJoeLouisToQueue.titleEdgeInsets = UIEdgeInsets(top: 10, left: 150, bottom: 10, right: 10)
        AddJoeLouisToQueue.setTitleColor(UIColor.black, for: .normal)
 
        AddJoeLouisToQueue.setBackgroundImage(UIImage(named: "Assets/aws_logo.png"), for: .normal)
        AddJoeLouisToQueue.imageView?.contentMode = .scaleAspectFit
        AddJoeLouisToQueue.imageEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
        
        
        
    }


    @IBAction func AddJoeLouistoQueue(_ sender: UIButton) {
        ProxyManager.sharedManager.postSQSMessage(uuid: "830C2041195F")
    }
  
    
    @IBOutlet weak var AddJoeLouisToQueue: UIButton!
    @IBOutlet weak var AddChimeraToQueue: UIButton!
    @IBOutlet weak var AddHistoricalToQueue: UIButton!
    @IBOutlet weak var ConstructionToQueueButton: UIButton!
    
    
    @IBAction func AddChimeratoAWSQueue(_ sender: UIButton) {
        ProxyManager.sharedManager.postSQSMessage(uuid: "038B4453676B")
    }
    
    
    @IBAction func AddHistoricaltoQueue(_ sender: UIButton) {
        ProxyManager.sharedManager.postSQSMessage(uuid: "9D6FFC8BCBEA")
    }
    
    
    @IBAction func AddConstructiontoQueue(_ sender: UIButton) {
        ProxyManager.sharedManager.postSQSMessage(uuid: "9D6FFC8BCBEA")
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

