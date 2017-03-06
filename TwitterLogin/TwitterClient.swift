//
//  TwitterClient.swift
//  TwitterLogin
//
//  Created by Nam Pham on 3/2/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let baseUri = URL(string: "https://api.twitter.com/")
let consumerKey = "FSyqhVXhnoCUOck5vo419Ew5E"
let consumerSecret = "37lPo9snUqNPOKktMvQaPXfZGPBKJC5QIrsY9eaaEEHqxxsF6w"



class TwitterClient{
    
    var client: BDBOAuth1SessionManager?
    static var _shared: TwitterClient?
    static func shared() -> TwitterClient! {
        if _shared == nil {
            _shared = TwitterClient()
        }
        return _shared
    }
    
    private init(){
        client = BDBOAuth1SessionManager(baseURL: baseUri, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    

    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) ->()){
        
        loginSuccess = success
        loginFailure = failure
        
        client?.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string:"hnamtwitter://"), scope: nil, success: { (response: BDBOAuth1Credential?) in
            if let response = response {
                print(response.token)
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
                
            }
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
            self.loginFailure!(error!)
        })

    }
    
    //get user info
    func getUserInfo(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        _ = client?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            print("\(error)")
            failure(error!)
        })
    }
    
    //get accesstoken 
    func getAccessToken(queryString: String!){
        let requestToken = BDBOAuth1Credential(queryString: queryString)
        _ = client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
            if let response = response {
                print("access token = \(response.token!)")
                self.getUserInfo(success: { (user: User) in
                    User.currentUser = user
                    
                    self.loginSuccess!()
                }, failure: { (error: Error) in
                    self.loginFailure!(error)
                })
                
            }
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
            self.loginFailure!(error!)
        })
    }
    
    func checkAccessToken() -> Bool {
        return client?.requestSerializer.accessToken != nil
    }
    
    func getTweets(sucess: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        _ = client?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetsDictionaries = response as! [NSDictionary]
            let tweets = Tweet.getTweets(dictionaries: tweetsDictionaries)
            sucess(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
    
    func logout(){
        User.currentUser = nil
        client?.deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func tweet(tweet: String?, success: @escaping (Tweet) -> (), failure: @escaping (Error)->()){
        var parameters = [String: AnyObject]()
        if tweet != nil {
            parameters["status"] = tweet as AnyObject?
            _ = client?.post("/1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let tweetDictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDictionary)
                success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("\(error)")
                failure(error)
            })
        }
    }
    
    func favoriteTweet(tweetId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()){
        var parameters = [String: AnyObject]()
        parameters["id"] = tweetId as AnyObject?
        _ = client?.post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)

        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
    
    func removeFavoriteTweet(tweetId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()){
        var parameters = [String: AnyObject]()
        parameters["id"] = tweetId as AnyObject?
        _ = client?.post("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
    
        
    func retweet(tweetId: Int,success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()){
        _ = client?.post("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            
           
            
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
    
    func unRetweet(tweetId: Int,success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()){
        var parameters = [String: AnyObject]()
        parameters["id"] = tweetId as AnyObject?
        _ = client?.post("1.1/statuses/unretweet/\(tweetId).json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDictionary = response as! NSDictionary
            
            let jsonData = try! JSONSerialization.data(withJSONObject: tweetDictionary, options: .prettyPrinted)
            let result = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(result)
            
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
            
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
    
}
