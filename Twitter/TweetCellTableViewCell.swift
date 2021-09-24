//This is the file we linked to just that one cell. We will drag all the ui elements of the cell to this file and thats it, when we use the reusable cell thing in let cell =...reusablecelldequeue then it uses this class and the ui elements and we will do all the operations in that function that  we want to happen for all cells, this file is just for dragging in the ui elements and naming them.

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    //we drag all these ui elements into this file now to link them. note they are outlets bc only buttons are an actual action
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetConent: UILabel!
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
