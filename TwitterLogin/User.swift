//
//  User.swift
//  TwitterLogin
//
//  Created by Nam Pham on 3/4/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagLine: String?
    
    var dictionary: NSDictionary?
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    
    init(dictionary: NSDictionary){
        
        self.dictionary = dictionary
        
        //name: key name
        name = dictionary["name"] as? String
        //screen_name
        screenName = dictionary["screen_name"] as? String
        //profile_image_url_https
        if let url = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: url)
        }
        //description
        tagLine = dictionary["description"] as? String
    }
    static var _currentUser: User?
    class var currentUser: User?{
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? NSData
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUser")

            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            defaults.synchronize()
            
            
        }
    }
}
