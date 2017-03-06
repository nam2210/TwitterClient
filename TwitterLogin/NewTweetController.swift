//
//  NewTweetController.swift
//  TwitterLogin
//
//  Created by Nam Pham on 3/5/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit
import AFNetworking


@objc protocol NewTweetDelegate {
    @objc optional func onTweetSuccess(tweet: Tweet)
}

class NewTweetController: UIViewController {
    
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var lblScreenName: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var lblTweet: UIBarButtonItem!
    
    weak var delegate: NewTweetDelegate?
    var countLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ivThumbnail.setImageWith((User.currentUser?.profileUrl)!)
        ivThumbnail.layer.cornerRadius = self.ivThumbnail.frame.width/8.0
        ivThumbnail.layer.masksToBounds = true
        
        lblName.text = User.currentUser?.name
        lblScreenName.text = "@" + (User.currentUser?.screenName)!
        textField.delegate = self
        
        if let navigationBar = self.navigationController?.navigationBar {
            let barButtonItem = self.navigationItem.rightBarButtonItem!
            let buttonItemView = barButtonItem.value(forKey: "view")
            
            let buttonItemSize = (buttonItemView as AnyObject).size.width
            
            let secondFrame = CGRect(x: navigationBar.frame.width - buttonItemSize * 2.1 , y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
    
            
            countLabel = UILabel(frame: secondFrame)
            countLabel?.text = "140"
            countLabel?.textColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1.0)
            
            navigationBar.addSubview(countLabel!)
        }
        
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
    
    @IBAction func onBackClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onTweetClick(_ sender: Any) {
        let tweet = textField.text
        print("\(tweet)")
        TwitterClient.shared().tweet(tweet: tweet, success: { (t: Tweet) in
            self.delegate?.onTweetSuccess?(tweet: t)
            self.dismiss(animated: true, completion: nil)
        }) { (error: Error) in
            print("\(error.localizedDescription)")
        }
        
    }
    
    var count: Int = 0
    static var MAX: Int = 140
}

extension NewTweetController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let c = string.characters.count
        if c == 1 {
            self.count += 1
        } else {
            self.count -= 1
        }
        print("\(self.count)")
        countLabel?.text = "\(NewTweetController.MAX - self.count)"
        return true
    }
}
