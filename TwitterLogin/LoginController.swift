//
//  LoginController.swift
//  TwitterLogin
//
//  Created by Nam Pham on 3/2/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = 8
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onLoginClicked(_ sender: Any) {
        TwitterClient.shared().login(success: { 
            print("tui da logged roi nha")
            self.performSegue(withIdentifier: "homeScreen", sender: nil)
        }) { (error: Error) in
            print("\(error.localizedDescription)")
        }
        
    }
}
