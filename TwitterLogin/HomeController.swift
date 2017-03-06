//
//  HomeController.swift
//  TwitterLogin
//
//  Created by Nam Pham on 3/4/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    
    var tweets = [Tweet]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        
        //dymanic height according to the content height
        tweetTableView.estimatedRowHeight = 100
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        //remove divider when no data in tableView
        tweetTableView.tableFooterView = UIView()
        
        //intialize a UI Refresh controller
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshHomeLines(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tweetTableView.insertSubview(refreshControl, at: 0)
        //load data
        loadHome()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutClick(_ sender: UIBarButtonItem) {
        TwitterClient.shared().logout()
        
    }

    func loadHome(){
        TwitterClient.shared().getTweets(sucess: { (result: [Tweet]?) in
            if let result = result {
                self.tweets = result
                self.tweetTableView.reloadData()
            }
            
        }) { (error: Error) in
            //empty
        }
    }
    
    func refreshHomeLines(_ refreshControl: UIRefreshControl){
        TwitterClient.shared().getTweets(sucess: { (result: [Tweet]?) in
            if let result = result {
                self.tweets = result
                self.tweetTableView.reloadData()
                refreshControl.endRefreshing()
            }
            
        }) { (error: Error) in
            //empty
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onNewClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "sequeNewTweet", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navNewVC = segue.destination as? UINavigationController
        if let navNewVC = navNewVC {
            let newVC = navNewVC.topViewController as! NewTweetController
            newVC.delegate = self
        }
        
        let detailVc = segue.destination as? TweetDetailController
        if let detailVc = detailVc {
            let indexPath = tweetTableView.indexPathForSelectedRow
            detailVc.tweet = tweets[(indexPath?.row)!]
        }
        
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tweetTableView.deselectRow(at: indexPath, animated: true)
    }
}


extension HomeController: NewTweetDelegate{
    func onTweetSuccess(tweet: Tweet) {
        //add to tweets array at index 0 
        tweets.insert(tweet, at: 0)
        //refresh table view
        tweetTableView.reloadData()
    }
}
