//This is a class we made to link to the home screen (this file has all the functionality for our homescreen). Note this file is of type UITableViewController because we are doing a table view now
//Then we link this file to the viewcontroller (type tableview) by entering the class on storyboard



import UIKit

class HomeTableViewController: UITableViewController {
    
    
    var tweetArray = [NSDictionary]() //this makes an array of dictionaries, the () at the end makes it an empty dictionary
    var numberOfTweets: Int!  //this just declares your variable, without assigning it a value yet bc we dont know the value
    
    let MyRefreshControl = UIRefreshControl()  //have to put this at top to initialize that you are doing a screen refresh
    //this creates the ability to refresh, and sets teh functionality to this variable (its an object)
    
    
    //This function we created will have the functionality to load and pull the tweets
    @objc func loadTweets(){
        
        numberOfTweets = 20
        
        //this is our resource url
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]  //note we want our count parameter to be 10,, if we wanted to add more parameters, we would do comma then "id":"dkdjkf" etc
        
        
        //This calls a function already created in the TwitterAPICaller class/file --> this will get all the dictionaries
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            //Now this is what happens when there is a success, we type in tweets so we can refer to our result as tweets
            
            self.tweetArray.removeAll() //this clears are array first,, this way it only has the new tweets in this array instead of keeping all the old ones too
            //now if success, for every tweet in the tweets, we will do...
            for tweet in tweets{
                self.tweetArray.append(tweet)
                //so for every tweet, we get from the api, we will add it to our tweetArray variable that we made at the top and that we will be using as our information base within our code (where we are storing the information from the API)
            }
            
            self.tableView.reloadData() //this makes it so that we reload the data always with this content we just created, or sometimes it wont show up anything  --> so this updated the table and keeps the spinning wheel at the top going, so you need to stop this or will just always have that loading spinning wheel at top
            self.MyRefreshControl.endRefreshing() //this makes it so that after the refresh, it loads it then stops and doesn infinitely refresh for the end of time
            
        }, failure: {(Error) in
            print("Could not retreive tweets!")
            
        })
        
        
    }
        
    
    
    //This function is for the infinite scroll, each time you will add a specified amount of new tweets as you scroll
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweets = numberOfTweets + 20 //so everytime you call this function, you add on 20 more tweets
    
        let myParams = ["count": numberOfTweets]
        
        //copy and paste from loadTweets function
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: {(Error) in
            print("Could not retreive tweets!")
            
        })
    
    //Now we need to call this function any time they get close to the end of the initial 20 tweets, as you scroll towareds the end of the page
    
    }
    //This function is used for an action anytime the user gets close to the bottom of the screen, within this function we call the load more tweets function
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if indexPath.row + 1 == tweetArray.count{ //if get to end of page, 
            loadMoreTweets()
        }
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //so as of now, the loaded tweet isn't loaded into the screen so we have to load it onto screen and save it once it loads (in this function)
        loadTweets()  //now we call the function that loads all the tweets and calls the api and sets it into the array, so now that happens, we good
        
        //but as of now, it only runs this function when the screen loads, we want this function to run when the user pulls down and so it refresehes
        MyRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)//this adds a target to the refreshControl--> where you want this to happen (self because want it tohappen on this screen, action is to call the loadTweets function again)
        
        tableView.refreshControl = MyRefreshControl //this tells the refresh control which refresh control you are going to use, so the variable you made

     
    }
    
    
    
    

    //Here we dragged the logout button to give it functionality when we actually click on it (make sure its action type because it's a (bar) button)
    @IBAction func onLogout(_ sender: Any) {
        //Now since it is an action, we actually type code in the function --> everything we put in here will run when we click on the button
        
        TwitterAPICaller.client?.logout() //this calls a function in the APICaller class that was created for us (it already takes care of all the processes to deauthorize with the api)
        
        //But by just clicking it, it logs us out of api, but we want it to take us back to the home screen
        
        self.dismiss(animated: true, completion: nil)
        //this dismisses the current screen and goes back to the previous segue (yes its animated and dont want anything to happen once its gone -> nil)
        
        //Now we have to set the userDefault to false for the userLoggedIn key now so it remembers that and checks that
        UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
    }
    
    
    //to get this function, we type cellforrow and it gives us this function, which returns a table view cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //note you set the identifier for the cell within the story board so you can use it in your code, and you will just use that for the identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        //note we cast it as the file we created for just the cell, so it uses that file and the ui elements we dragged into it
        
        
        //now we will set all the values of the label and images. Now if we do cell. whatever we can access the image view, and both labels by their names we set with the outlets
        
        //note how we do .text to set that specific attribute of the label -->so we go through the dictionary we made a variable for at the very top and access the correct portion of it and set it here
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        //so in the dictionary, the name is under a key "user" and within that key there is another group of things and you gotta do the key "name" within that
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetConent.text = tweetArray[indexPath.row]["text"] as? String  //So this goes in the tweetArray and for the correct row, it'll return the content/value of the dictionary for the "text" key
        
        //Now we need to pull the image and set that
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!) //gets the url from the api dictionary
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
    
        
        
        return cell
    }
    

//These functions were already given to us so we input the number of sections and the number of rows
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count  //this will create the amount of cells for the tweets given
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
