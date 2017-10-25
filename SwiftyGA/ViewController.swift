//
//  ViewController.swift
//  SwiftyGA
//
//  Created by Arash Z.Jahangiri on 10/21/17.
//  Copyright © 2017 Arash Z.Jahangiri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        SwiftyGA.shared.screenView(Utility.screenName(obj: self))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func tapMeAction(_ sender: Any) {
        SwiftyGA.shared.event(category: Track.Category.click, action: Track.Action.tap, label: Utility.screenName(obj: self), value: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            SwiftyGA.shared.event(category: Track.Category.click, action: Track.Action.next, label: Utility.screenName(obj: self), value: nil)
        }
    }
}

