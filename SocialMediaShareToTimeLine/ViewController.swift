//
//  ViewController.swift
//  SocialMediaShareToTimeLine
//
//  Created by Pushpam Group on 19/04/17.
//  Copyright © 2017 Pushpam Group. All rights reserved.
//

import UIKit
import Social
import SafariServices
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

import GoogleSignIn
import Google


class ViewController: UIViewController, SFSafariViewControllerDelegate, FBSDKSharingDelegate {
    
    
    let lacartImageView:UIImageView = UIImageView()
    
    //native
    @IBOutlet var facebookShareButton: UIButton!
    @IBOutlet var googlePlusShareButton: UIButton!
    
    //From SDK
    @IBOutlet var facebookShare: FBSDKShareButton!
    
    var content : FBSDKShareLinkContent = FBSDKShareLinkContent()
    var fbDetails : NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lacartImageView.image = UIImage(named: "chef_icon")
        
        
        //From SDK
        content.contentURL = NSURL(string: "http://www.lacart.com/") as URL!
        content.contentTitle = "Good News!"
        content.contentDescription = "Now experience better, healthier & fresher meals, made at a home near you. Enter your exact location to explore. Made with love by food architects around you..\n"
        content.imageURL = NSURL(string: "chef_icon") as URL!
        
        facebookShare.shareContent = content
        facebookShare.isEnabled =  true
        verifyInitialAccessToFacebook()
    }
    func verifyInitialAccessToFacebook(){
        
        if FBSDKAccessToken.current() != nil {
            FBSDKLoginManager().logOut()
            return
        }
        
        let loginManager:FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFacebookUserData()
                        loginManager.logOut()
                    }
                }
            }
        }
    }
    func getFacebookUserData(){
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.fbDetails = result as? NSDictionary
                    // print(self.fbDetails!)
                    
                 //   self.usernameLabel.text = self.fbDetails?.object(forKey: "name") as! String?
                   // self.passwordLabel.text = self.fbDetails?.object(forKey: "email") as! String?
                  
                    let profilePictureDict =  self.fbDetails?.object(forKey: "picture") as? NSDictionary
                    let profilePictureDataDict =  profilePictureDict?.object(forKey: "data") as? NSDictionary
                    print("pictDataArray  :\(profilePictureDataDict )")
                  //  self.profilePictureImageURL.text = "Image URL : "+(profilePictureDataDict?.object(forKey: "url") as! String?)!
                    
                }else{
                    print(error?.localizedDescription ?? "Not found")
                }
            })
        }
    }
    
    
    @IBAction func shareToFacebookButtonClicked(_ sender: Any) {
        
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        vc?.add(lacartImageView.image!)
        vc?.add(URL(string: "http://www.lacart.com/"))
        vc?.setInitialText("Good News! Now experience better, healthier & fresher meals, made at a home near you. Enter your exact location to explore. Made with love by food architects around you..\n")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func shareToGoogleButtonClicked(_ sender: Any) {
        let urlstring = "https://developers.google.com/+/mobile/ios/share/basic-share"
        let shareURL = NSURL(string: urlstring)
        let urlComponents = NSURLComponents(string: "https://plus.google.com/share")
        urlComponents!.queryItems = [NSURLQueryItem(name: "url", value: shareURL!.absoluteString) as URLQueryItem]
        let url = urlComponents!.url!
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: url)
            svc.delegate = self
            svc.title = "Lacart"
            self.present(svc, animated: true, completion: nil)
        } else {
            debugPrint("Not available")
        }
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController){
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool)
    {
        
        
    }
    
    @IBAction func facebookShareClicked(_ sender: Any) {
        
        
        
        print("sahr e clicked")
        
        let shareDialog = FBSDKMessageDialog()
        shareDialog.shareContent = content
        // shareDialog.completion = { result in
        // Handle share results
        //   }
        
        shareDialog.show()
    }
    @IBAction func googleShareClicked(_ sender: Any) {
        
        //This form is deprecated

//        var activityItems: [Any]? = ["Hello Google+!", UIImage(named: "example.jpg")!]
//
//        activityItems = ["Hello Google+!", URL(string: "https://github.com/lysannschlegel/GooglePlusShareActivity")]
//        
//        // You can also set up a GPPShareBuilder on your own. All other items will be ignored
//        
//        
//        var shareBuilder:  GPPNativeShareBuilder? = (GPPShare.sharedInstance().nativeShareDialog as? GPPNativeShareBuilder)
//        shareBuilder?.prefillText = "Hello Google+!"
//        
//        shareBuilder?.URLToShare = URL(string: "https://github.com/lysannschlegel/GooglePlusShareActivity")
//        activityItems = ["Does not appear", shareBuilder]
//       
//        var gppShareActivity = GPPShareActivity()
//        gppShareActivity.canShowEmptyForm = true
    }
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!){
        
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!){
        
    }
    func sharerDidCancel(_ sharer: FBSDKSharing!){
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

