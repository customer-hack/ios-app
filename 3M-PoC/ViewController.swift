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
    }

    @IBAction func showChimera(_ sender: Any) {
        if let detroitChimeraImage = UIImage(named: "Assets/DetroitChimera.jpg") {
            ProxyManager.sharedManager.updateScreen(image: detroitChimeraImage, text1: "Detroit", text2: "Chimera", template: .graphicWithText)
            sleep(5)
            ProxyManager.sharedManager.redirectHome()
        }
    }

    @IBAction func showLargeGraphic(_ sender: Any) {
        if let detroitChimeraImage = UIImage(named: "Assets/DetroitChimera.jpg") {
            ProxyManager.sharedManager.updateScreen(image: detroitChimeraImage, text1: "Detroit", text2: "Chimera", template: .largeGraphicOnly)
            sleep(5)
            ProxyManager.sharedManager.redirectHome()
        }
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

