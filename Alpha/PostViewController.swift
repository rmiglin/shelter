//
//  PostViewController.swift
//  Alpha
//
//  Created by Karla Padron on 12/1/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PostViewController: UIViewController {
    
    var userList = [UserModel]()
    var refUsers: DatabaseReference!
    var refPosts: DatabaseReference!

    @IBOutlet weak var post: UITextView!
    @IBAction func postButton(_ sender: Any) {
        if post.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please type a post!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else{
        
            
        let theUser = userList[0]
            
        let alertController = UIAlertController(title: theUser.firstName, message: "Are you safe from harm?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
        let safe = UIAlertAction(title: "Safe", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
                let ID = theUser.id
                let status = "green"
            self.addPost(status: status)
                _ = self.navigationController?.popViewController(animated: true)
                
        self.updateUser(id: ID!, firstName: theUser.firstName!, lastName: theUser.lastName!, email: theUser.email!, password: theUser.password!, phone: theUser.phoneNumber!, streetAddress: theUser.streetAddress!, city: theUser.city!, state: theUser.state!, zip: theUser.zip!, status: status, shareLocation: theUser.shareLocation!)
                print("Safe Button Pressed")})
        let unsafe = UIAlertAction(title: "Unsafe", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
                let ID = theUser.id
                let status = "red"
            self.addPost(status: status)
                _ = self.navigationController?.popViewController(animated: true)
                
        self.updateUser(id: ID!, firstName: theUser.firstName!, lastName: theUser.lastName!, email: theUser.email!, password: theUser.password!, phone: theUser.phoneNumber!, streetAddress: theUser.streetAddress!, city: theUser.city!, state: theUser.state!, zip: theUser.zip!, status: status, shareLocation: theUser.shareLocation!)
                print("Unsafe Button Pressed")})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (_) in }
        alertController.addAction(cancelAction)
        alertController.addAction(safe)
        alertController.addAction(unsafe)
        present(alertController, animated: true, completion: nil)
            
        //_ = navigationController?.popViewController(animated: true)
        
        }
    }
    override func viewDidLoad() {
        refPosts = Database.database().reference().child("posts");
        
        super.viewDidLoad()
        userList = [UserModel(id: "", firstName: "", lastName: "", email: "", password: "", phoneNumber: "", streetAddress: "", city: "", state: "", zip: "", status: "green", shareLocation: "True")]
        
        refUsers = Database.database().reference().child("users");
        refUsers.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                //self.userList.removeAll()
                
                //iterating through all the values
                for user in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let userObject = user.value as? [String: AnyObject]
                    let userId  = userObject?["id"]
                    let userFirstName  = userObject?["firstName"]
                    let userLastName = userObject?["lastName"]
                    let userEmail = userObject?["enterEmail"]
                    let userPassword  = userObject?["enterPassword"]
                    let userPhoneNumber = userObject?["phoneNumber"]
                    let userStreetAddress = userObject?["streetAddress"]
                    let userCity  = userObject?["city"]
                    let userState = userObject?["state"]
                    let userZip = userObject?["zip"]
                    let userStatus = userObject?["status"]
                    let userShareLocation = userObject?["shareLocation"]
                    
                    //creating artist object with model and fetched values
                    let user = UserModel(id: userId as! String?, firstName: userFirstName as! String?, lastName: userLastName as! String?, email: userEmail as! String?, password: userPassword as! String?, phoneNumber: userPhoneNumber as! String?, streetAddress: userStreetAddress as! String?, city: userCity as! String?, state: userState as! String?, zip: userZip as! String?,status: userStatus as! String?, shareLocation: userShareLocation as! String?)
                    
                    //appending it to list
                    
                    if(user.email! == Auth.auth().currentUser!.email! ) {
                        self.userList = [user]
                    }
                }
                
            }
            
        })


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPost(status: String){
        //generating a new key
        //and also getting the generated key
        let key = refPosts.childByAutoId().key
        print(NSDate().description)
        //creating user with the given values
        let post = ["id":key,
                    "user": Auth.auth().currentUser?.email as! String,
                    "post": self.post.text,
                    "time" : NSDate().description,
                    "postStatus" : status
            
            ] as [String : Any]
        
        //adding the user inside the generated unique key
        refPosts.child(key).setValue(post)
        
    }
    
    func updateUser(id:String, firstName:String, lastName:String,email:String, password:String, phone:String, streetAddress:String,city:String, state:String, zip:String, status:String, shareLocation: String){
        //creating artist with the new given values
        let user = ["id":id,
                    "firstName": firstName,
                    "lastName": lastName,
                    "enterEmail": email,
                    "enterPassword": password,
                    "phoneNumber": phone,
                    "streetAddress": streetAddress,
                    "city": city,
                    "state": state,
                    "zip": zip,
                    "status": status,
                    "shareLocation": shareLocation
            
        ]
        
        //updating the artist using the key of the artist
        refUsers.child(id).setValue(user)
        
        //displaying message
        //labelMessage.text = "Artist Updated"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
