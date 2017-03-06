//
//  TweetCell.swift
//  TwitterLogin
//
//  Created by Nam Pham on 3/4/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var ivThumbnail: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTagName: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblRetweetCount: UILabel!
    @IBOutlet weak var lblFavoriteCount: UILabel!
    @IBOutlet weak var retweet: UILabel!
    
    @IBOutlet weak var retweetControlHeight: NSLayoutConstraint!
    
    var tweet: Tweet! {
        didSet{
            lblName.text = tweet.name
            //todo here
            lblTagName.text = "@" + tweet.screenName!
            lblRetweetCount.text = String(tweet.retweetCount)
            lblFavoriteCount.text = String(tweet.favoriteCount)
            lblText.text = tweet.text
            ivThumbnail.setImageWith(tweet.profileUrl!)
            lblDate.text = tweet.timeStamp
            
            if !tweet.isTweet {
                retweet.isHidden = false
                retweetControlHeight.constant = 17
                if tweet.isYouRetweet {
                    retweet.text = "You Retweeted"
                } else {
                    retweet.text = tweet.retweetName! + " Retweeted"
                }
            } else {
                retweet.isHidden = true
                retweetControlHeight.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ivThumbnail.layer.cornerRadius = self.ivThumbnail.frame.width/8.0
        ivThumbnail.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
