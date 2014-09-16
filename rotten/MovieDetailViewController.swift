//
//  MovieDetailViewController.swift
//  rotten
//
//  Created by Faith Cox on 9/15/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var movieScrollView: UIScrollView!
    @IBOutlet weak var movieView: UIView!
    
    
    var movieId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "http://api.rottentomatoes.com/api/public/v1.0/movies/\(self.movieId).json?apikey=dagqdghwaq3e3mxyrp7kmmj5&country=us"
        
        var request = NSURLRequest (URL: NSURL(string: url))
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())   {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
        var yearInfo = String(object["year"] as Int)
        var titleInfo = object["title"] as String
        self.titleLabel.text = "\(titleInfo) (\(yearInfo))"
        self.navigationItem.title = titleInfo
        
        self.ratingLabel.text = object["mpaa_rating"] as? String
        self.synopsisLabel.text = object["synopsis"] as? String
        var synopsisText = object["synopsis"] as String
        self.synopsisLabel.sizeToFit()
        var viewSize = self.synopsisLabel.frame.height + 30.0 + 22.0 + 22.0
        println(self.synopsisLabel.frame.height)
        self.movieView.frame.size.height = viewSize
                
        var scoreInfo = object["ratings"] as NSDictionary
        var crScore = String(scoreInfo["critics_score"] as Int)
        var auScore = String(scoreInfo["audience_score"] as Int)
        self.scoreLabel.text = "Crtics Score: \(crScore), Audience Score: \(auScore)"
        var posterInfo = object["posters"] as NSDictionary
        var posterUrl = posterInfo["original"] as String
        self.posterImage.setImageWithURL(NSURL(string: posterUrl))
                
        var scrollSize = self.movieView.frame.height + self.movieView.frame.origin.y
        self.movieScrollView.contentSize = CGSize(width:320.0, height:scrollSize)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
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
