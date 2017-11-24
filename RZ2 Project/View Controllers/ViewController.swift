//
//  ViewController.swift
//  RZ2 Project
//
//  Created by Eduardo Thiesen on 22/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didAuthenticateUser(notification:)), name: NSNotification.Name(rawValue: "kDidAuthenticateUser"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveAuthenticationError(notification:)), name: NSNotification.Name(rawValue: "kDidReceiveLoginError"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveInternetConnectionError(notification:)), name: NSNotification.Name(rawValue: "kNoInternetConnection"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func userDidTouchUpInsideLoginButton(_ sender: Any) {
        
        let networkController = NetworkController()

        if emailTextField.text != "" && passwordTextField.text != "" {
            networkController.login(email: emailTextField.text!, password: passwordTextField.text!)
            loader.startAnimating()
        } else {
            let alert = UIAlertController(title: "Atenção", message: "Preencha o campo de e-mail e senha para prosseguir", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func enableFields() {
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        loginButton.isEnabled = true
    }
    
    func disableFields() {
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
    }
    
    @objc func didAuthenticateUser(notification: Notification) {
        DispatchQueue.main.async(execute: {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            self.enableFields()
            self.loader.stopAnimating()
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.performSegue(withIdentifier: "main", sender: self)
        })
    }
    
    @objc func didReceiveInternetConnectionError(notification: Notification) {
        let userInfo = notification.userInfo as! [String : Any]
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "", message: userInfo["Error"] as? String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.enableFields()
            self.loader.stopAnimating()
        })
    }
    
    @objc func didReceiveAuthenticationError(notification: Notification) {
        let userInfo = notification.userInfo as! [String : Any]

        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "", message: userInfo["Error"] as? String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.enableFields()
            self.loader.stopAnimating()
        })
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            userDidTouchUpInsideLoginButton(self)
        }
        
        return true
    }
}
