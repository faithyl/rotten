//
//  MoviesViewController.swift
//  rotten
//
//  Created by Faith Cox on 9/12/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary] = []
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        self.refresh(self)
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
        
        var request = NSURLRequest (URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
            self.movies = object["movies"] as [NSDictionary]
            
            self.tableView.reloadData()
            
            self.refreshControl.endRefreshing()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //println("I'm at row: \(indexPath.row), section: \(indexPath.section)")
    
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        
        var movie = movies[indexPath.row]
        
        cell.movieTitleLable.text = movie["title"] as? String
        var synopsisText = movie["synopsis"] as String
        var ratingText = movie["mpaa_rating"] as String
        var synopsisRating = "\(ratingText), \(synopsisText)"
        
        var wordRange = (synopsisRating as NSString).rangeOfString(ratingText)
        var sysnopsisrMutable = NSMutableAttributedString(string:synopsisRating)
        
        sysnopsisrMutable.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(13), range: wordRange)
        
        cell.synopsisLabel.attributedText = sysnopsisrMutable
        
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        
    //  var cell = UITableViewCell()
    //    cell.textLabel!.text = "Hello, I'm at row: \(indexPath.row), section: \(indexPath.section)"
       
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "segueMovie"){
            var indexPath = tableView.indexPathForSelectedRow()
            var movie = movies[indexPath!.row]
            var svc = segue.destinationViewController as MovieDetailViewController
            svc.movieId = movie["id"] as String
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
