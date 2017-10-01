//
//  MessageViewController.swift
//  XMPPSendApp
//
//  Created by xvacid on 10/1/17.
//  Copyright © 2017 WSG4FUN. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var messageTextView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSendPressed(_ sender: UIButton) {
        let userId = XMPPApi.shared.findUserName(firstChar: "s")
//        let userId = XMPPApi.shared.findUserName(firstChar: "e")
        XMPPApi.shared.sendMessage(toUserName: userId, withMessage: messageTextView.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
