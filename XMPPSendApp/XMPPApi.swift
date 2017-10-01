//
//  XMPPApi.swift
//  XMPPSendApp
//
//  Created by xvacid on 10/1/17.
//  Copyright © 2017 WSG4FUN. All rights reserved.
//

import UIKit
import XMPPFramework

protocol XMPPApiDelegate: class {
    func onLoginSuccess()
    func onLoginError()
}

class XMPPApi: NSObject {
    private let stream = XMPPStream()
    private let roster = XMPPRoster(rosterStorage: XMPPRosterCoreDataStorage(), dispatchQueue: DispatchQueue.main)
    private var userName: String? = nil
    private var password: String? = nil
    private var users = [String: String]()
    
    weak var delegate: XMPPApiDelegate? = nil
    
    enum Status {
        case Online
        case Offline
    }
    
    static let shared: XMPPApi = { return XMPPApi() }()
    
    func setupApi(_ serverUrl: String, _ port: UInt16, _ delegate: XMPPApiDelegate?) {
        self.delegate           = delegate
        stream?.hostName        = serverUrl
        stream?.hostPort        = port
        stream?.startTLSPolicy  = .required
        stream?.enableBackgroundingOnSocket = true

        roster?.activate(stream)
        stream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        roster?.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    func login(withUserName userName: String, andPassword password: String) {
        self.userName = userName
        self.password = password
        stream?.myJID = XMPPJID.init(string: self.userName) 
        
        do {
            try stream?.oldSchoolSecureConnect(withTimeout: XMPPStreamTimeoutNone)
        } catch {
            if self.delegate != nil {
                self.delegate?.onLoginError()
            }
        }
    }
    
    func changeStatus(_ status: Status) {
        let presence = XMPPPresence()
        
        switch status {
        case .Online:
            presence?.addAttribute(withName: "status", stringValue: "online")
        case .Offline:
            presence?.addAttribute(withName: "status", stringValue: "unavailable")
        }
        
        self.stream?.send(presence)
    }
    
    func sendMessage(toUserName userName: String, withMessage message: String) {
        let user = XMPPJID.init(string: userName)
        let msg = XMPPMessage(type: "chat", to: user)
        msg?.addBody(message)
        self.stream?.send(msg)
    }
    
    func findUserName(firstChar char: Character) -> String {
        for (_, jid) in self.users {
            let lowerCaseJid = jid.lowercased()
            if lowerCaseJid.first == char {
                return jid
            }
        }
        
        return ""
    }
}

//MARK: - XMPPRosterDelegate
extension XMPPApi : XMPPRosterDelegate {
    func xmppRoster(_ sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        let jid = item.attribute(forName: "jid")
        let name = item.attribute(forName: "name")
        self.users[(name?.stringValue)!] = jid?.stringValue
    }
}

//MARK: - XMPPStreamDelegate
extension XMPPApi : XMPPStreamDelegate {
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        do {
            try stream?.authenticate(withPassword: self.password)
        } catch {
            if self.delegate != nil {
                self.delegate?.onLoginError()
            }
        }
    }

    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        self.changeStatus(.Online)
        
        if self.delegate != nil {
            self.delegate?.onLoginSuccess()
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive trust: SecTrust!, completionHandler: ((Bool) -> Void)!) {
        completionHandler(true)
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!) {
        let messageStr = message.body()
        print("Did send message \(String(describing: messageStr))")
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        let messageStr = message.body()
        print("Did receive message \(String(describing: messageStr))")
    }
    
    func xmppStream(_ sender: XMPPStream!, willSecureWithSettings settings: NSMutableDictionary!) {
        settings.setObject(sender.hostName, forKey: kCFStreamSSLPeerName as! NSCopying)
        settings.setObject(true, forKey: GCDAsyncSocketManuallyEvaluateTrust as NSCopying)
    }
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
    }
}
