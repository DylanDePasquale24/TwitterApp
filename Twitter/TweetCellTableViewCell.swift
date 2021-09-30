//This is the file we linked to just that one cell. We will drag all the ui elements of the cell to this file and thats it, when we use the reusable cell thing in let cell =...reusablecelldequeue then it uses this class and the ui elements and we will do all the operations in that function that  we want to happen for all cells, this file is just for dragging in the ui elements and naming them.

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    //setting these as initial variables
    var tweetID:Int = -1
    var favorited:Bool = false
 

    //we drag all these ui elements into this file now to link them. note they are outlets bc only buttons are an actual action
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetConent: UILabel!
    
    //note we have to also create outlets (even though they are buttons, make them outlets for this file, THEN WE ALSO MAKE ACTIONS FOR THEM, UNDER HERE(HAVE TO MAKE THE OUTLET FIRST THOUGH TO CONNECT THEM)) for the 2 like and retweet buttons in this cell class so they can have functionality
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favButton: UIButton!
    
    
    
    
    //These are the actions for the two buttons, actions we do the functionality in this file
    @IBAction func favoriteTweet(_ sender: Any) {
        
        let tobeFavorited = !favorited
        if(tobeFavorited){
            
            //now we call the function we made in the api caller called favorite tweet, and if it is a success, we set the favorite as true
            
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success:{ self.setFavorite(true)}, failure: {(error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("unfavorite did not succeed: \(error)")
            })
            
        }
        
        
        
        
    }
    
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetID: tweetID, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Error is retweeting: \(error)")
        })
    }
    
    
    func setRetweeted(_ isRetweeted:Bool){
        if (isRetweeted){
            //so if its retweeted, we set the image to green and make it so the button cant be pressed again
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }else{
            //if it isnt retweeted we make it so the button can be presssed now
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    //we will call this function in the HomeTableViewController
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if (favorited){
            //if its favorited, we set the image for the favorite button to the red version
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }else{
            //set it to gray
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
