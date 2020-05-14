//
//  LoginViewController.swift
//  Instagram
//
//  Created by 井上真悠子 on 2020/05/12.
//  Copyright © 2020 taro.kirameki. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!
    
    @IBAction func handleLoginButton(_ sender: Any) {
        
        if let address = mailAddressTextField.text,let password = passwordTextField.text {
            
            if address.isEmpty || password.isEmpty {
                return
            }
            
            SVProgressHUD.show()
            
            
            Auth.auth().signIn(withEmail: address,password: password) { authResult,error in
                if let error = error {
                    print("DEBUG_PRINT:"+error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT:ログインに成功しました。")
                
                SVProgressHUD.dismiss()
                
                self.dismiss(animated:true,completion: nil)
            }
        }
    }
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT:何かが空文字です。")
                return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().createUser(withEmail: address, password: password) {authResult,error in
                if let error = error {
                    print("DEBUG_PRINT:"+error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    return
                }
                print("DEBUG_PRINT:ユーザー作成に成功しました。")
                
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("DEBUG_PRINT:"+error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT:[displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        SVProgressHUD.dismiss()
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
