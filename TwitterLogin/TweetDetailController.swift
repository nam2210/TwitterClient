//
//  TweetDetailController.swift
//  TwitterLogin
//
//  Created by Nam Pham on 3/5/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetDetailController: UIViewController {

    
    @IBOutlet weak var ivThumbnail: UIImageView!
    
    @IBOutlet weak var lblReTweeted: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblNameScreen: UILabel!
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblCreatedAt: UILabel!
    
    
    @IBOutlet weak var lblReTweetCount: UILabel!
    
    @IBOutlet weak var lblFavoriteCount: UILabel!
    
    @IBOutlet weak var btnFavorited: UIButton!
    
    @IBOutlet weak var btnRetweet: UIButton!
    
    @IBOutlet weak var retweetConstraintHeight: NSLayoutConstraint!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //update UI
        updateUI()
    }
    
    func updateUI(){
        // Do any additional setup after loading the view.
        lblName.text = tweet.name
        //todo here
        lblNameScreen.text = "@" + tweet.screenName!
        lblReTweetCount.text = String(tweet.retweetCount)
        lblFavoriteCount.text = String(tweet.favoriteCount)
        lblText.text = tweet.text
        ivThumbnail.setImageWith(tweet.profileUrl!)
        ivThumbnail.layer.cornerRadius = self.ivThumbnail.frame.width/8.0
        ivThumbnail.layer.masksToBounds = true
        lblCreatedAt.text = tweet.fullTimeStamp
        
        if !tweet.isTweet {
            lblReTweeted.isHidden = false
            retweetConstraintHeight.constant = 17
            if tweet.isYouRetweet {
                lblReTweeted.text = "You Retweeted"
            } else {
                lblReTweeted.text = tweet.retweetName! + " Retweeted"
            }
        } else {
            lblReTweeted.isHidden = true
            retweetConstraintHeight.constant = 0
        }
        
        if tweet.isYouFavorited {
            //set image favorited
            btnFavorited.setImage(#imageLiteral(resourceName: "ic_clicked_favorite"), for: .normal)
        } else {
            btnFavorited.setImage(#imageLiteral(resourceName: "ic_favorite"), for: .normal)
            
        }
        
        //print("\(tweet.isYouRetweet)")
        if tweet.isYouRetweet {
            //set image retweet
            btnRetweet.setImage(#imageLiteral(resourceName: "ic_retweeted"), for: .normal)
        } else {
            btnRetweet.setImage(#imageLiteral(resourceName: "ic_retweet"), for: .normal)
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

    @IBAction func onFavoriteClick(_ sender: Any) {
        showLoading()
        if !tweet.isYouFavorited {
            print("favorited")
            TwitterClient.shared().favoriteTweet(tweetId: tweet.tweetId, success: { (tweet: Tweet) in
                self.hideLoading()
                self.tweet = tweet
                self.updateUI()
            }) { (error: Error) in
                self.hideLoading()
                print("\(error)")
            }
        } else {
            print("remove favorited")
            TwitterClient.shared().removeFavoriteTweet(tweetId: tweet.tweetId, success: { (tweet: Tweet) in
                self.hideLoading()
                self.tweet = tweet
                self.updateUI()
            }, failure: { (error: Error) in
                self.hideLoading()
                print("\(error)")
            })
        }
    }
    
    @IBAction func onRetweetClick(_ sender: Any) {
        showLoading()
        if !tweet.isYouRetweet {
            print("retweet")
            TwitterClient.shared().retweet(tweetId: tweet.tweetId, success: { (tweet: Tweet) in
                self.hideLoading()
                self.tweet = tweet
                self.updateUI()
            }) { (error: Error) in
                print("\(error)")
            }
        } else {
            print("unretweet")
            TwitterClient.shared().unRetweet(tweetId: tweet.tweetId, success: { (tweet: Tweet) in
                self.hideLoading()
                self.tweet = tweet
                self.updateUI()
            }, failure: { (error: Error) in
                print("\(error)")
                self.hideLoading()
            })
        }
    }
    
    
    @IBAction func onReplyClick(_ sender: Any) {
        
    }
    
    func showLoading(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideLoading(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    

    
    
}
