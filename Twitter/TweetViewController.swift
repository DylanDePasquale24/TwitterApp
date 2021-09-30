//This is the file attached to our tweetView controller that will handle creating tweets, (attached to a seperate navigation controller)
//note we cntrl dragged the tweet button to our new navigation controller and create a segue to present modally

import UIKit

class TweetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //upon loading, we want the keyboard to pop up right away so they know to type. Otherwise they have to know to click on the blank screen
        tweetTextView.becomeFirstResponder()
    }
    
    //brings the text into file, note its an outlet not an action(cause its not a button)
    @IBOutlet weak var tweetTextView: UITextView!
    
    //creates an action for the cancel button, so whenever you click cancel, it will perform whatever functionality you put in this function
    @IBAction func cancel(_ sender: Any) {
        //now to go back to the previous screen, we just use the dismiss function, we want it animated, and after we go back to the previous screen, we want nothing special to happen, just dismiss it
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tweet(_ sender: Any) {
        //now when we press the tweet button on the top, it will perform this functionality (first make sure the textbox isn't empty) --> if its empty we dont do anything
        if(!tweetTextView.text.isEmpty){
            
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                //if successful posting tweet to api, we just dismiss it
                self.dismiss(animated: true, completion: nil)
                
            }, failure: { error in
                //if failure, we print this to debug screen and also dismiss
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
            
        }else{ //if textbox is empty (could use an alert controller to say you should put text)
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
