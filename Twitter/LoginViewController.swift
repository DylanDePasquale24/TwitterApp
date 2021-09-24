//This file is what we link to our login view controller (our starting page) and we will write code on how to segue to the homepage navigationcontroller
//Note that we did a manual segue, not an action segue from login screen to navigation controller,,we also connect this file to our login view controller (the one with initial arrow) by adding this as a class... note that when creating file its a class UIViewController
//we also gave the arrow itself (the arrow segue a name in the identity portion)




import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    //Now this is what is run after the initial start screen has appeared, it will check if the user
    override func viewDidAppear(_ animated: Bool) {
        
        //so if its already set to true, then we perform the segue
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    
    
    //Drag login button to code (note we make it an action because we are performing an action when button is clicked,, an outlet is more for when you're changing something like a label or text)
    //So anything that we do in here will run anytime someone clicks a button
    @IBAction func onLoginButton(_ sender: Any) {
        
        //This uses the premade class, we put in the url for the API call and it wants to know what to do if login works and if login fails
        let myUrl = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: myUrl, success: {
            //This is for the success --> want to go from login screen to homescreen through the segue
            
            //(since successful,) Now we want to do a user default, where it will save that we have already logged in so when you reopen the app, you are still logged in -->we set bool to true
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            //this makes it so the value is true for the key userLoggedIn (it sets the value) -->this sets a variable called userLoggein in and makes it true so next time you login, we check this upon login to determines if we can send user to homescreen
            //this default will now stay in memory even when app is closed
            
            
            self.performSegue(withIdentifier: "loginToHome", sender: self) //so if it is a success, you perform the segue, (which segue? loginToHome...from where are you segueing? from itself)-->since use self  you have to put.self before function
            
            
        }, failure: { (Error) in
            
            //now we perform this if the login fails
            
        })
        
        
        
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
