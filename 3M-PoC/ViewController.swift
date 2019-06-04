//
//  ViewController.swift
//  3M-PoC
//
//  Created by Justin Hoyt on 5/29/19.
//  Copyright © 2019 Justin Hoyt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let proxyManager = ProxyManager.self

    override func viewDidLoad() {
        super.viewDidLoad()
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
}

