//
//  LoginViewModel.swift
//  XMPPSendApp
//
//  Created by xvacid on 10/1/17.
//  Copyright © 2017 WSG4FUN. All rights reserved.
//

import Foundation

class LoginViewModel: NSObject {
    private let model = LoginModel()

    override init() {
        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLogin),
                                               name: NSNotification.Name(rawValue: "LoginViewModel:onLogin"),
                                               object: nil)
    }
    
    func login(_ userName: String, _ userPassword: String) {
        self.model.login(userName, userPassword)
    }
    
    @objc func onLogin(notification: Notification) {
        let isSuccess = notification.object as? Bool
        NotificationCenter.default.post(name: NSNotification.Name.init("LoginView:onLogin"), object: isSuccess)
    }
}
