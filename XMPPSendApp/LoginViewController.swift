//
//  ViewController.swift
//  XMPPSendApp
//
//  Created by xvacid on 9/28/17.
//  Copyright © 2017 WSG4FUN. All rights reserved.
//

import UIKit
import XMPPFramework
import MBProgressHUD

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    private var progressHud: MBProgressHUD? = nil
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLogin),
                                               name: NSNotification.Name(rawValue: "LoginView:onLogin"),
                                               object: nil)
        
        userNameTextField.text      = "improver@im-test.sbr.local"
        userPasswordTextField.text  = "Bcn0hb9"
    }

    @IBAction func onLoginPressed(_ sender: UIButton) {
        loginButton.isEnabled           = false
        userNameTextField.isEnabled     = false
        userPasswordTextField.isEnabled = false
        
        progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud?.label.text = "Authorization"
        
        self.viewModel.login(userNameTextField.text!, userPasswordTextField.text!)
    }
    
    @objc func onLogin(notification: Notification) {
        loginButton.isEnabled           = true
        userNameTextField.isEnabled     = true
        userPasswordTextField.isEnabled = true
        
        progressHud?.hide(animated: true)
        let isSuccess = notification.object as? Bool
        
        if isSuccess! {
            let storyboard = UIStoryboard(name: "Message", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MessageViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

