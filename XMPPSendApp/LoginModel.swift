//
//  LoginModel.swift
//  XMPPSendApp
//
//  Created by xvacid on 10/1/17.
//  Copyright © 2017 WSG4FUN. All rights reserved.
//

import Foundation

class LoginModel: NSObject {
    func login(_ userName: String, _ userPassword: String) {
        XMPPApi.shared.setupApi("xmpp.im.sbr.local", 443, self)
        XMPPApi.shared.login(withUserName: userName, andPassword: userPassword)
    }
}

extension LoginModel: XMPPApiDelegate {
    func onLoginSuccess() {
        NotificationCenter.default.post(name: NSNotification.Name.init("LoginViewModel:onLogin"), object: true)
    }
    
    func onLoginError() {
        NotificationCenter.default.post(name: NSNotification.Name.init("LoginViewModel:onLogin"), object: false)
    }
}
