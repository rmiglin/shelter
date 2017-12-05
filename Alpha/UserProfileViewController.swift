//
//  UserProfileViewController.swift
//  Alpha
//
//  Created by Karla Padron on 11/30/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    var postList = [PostModel]()
    var refPosts: DatabaseReference!
    var userList = [UserModel]()
    var refUsers: DatabaseReference!

    @IBAction func statusDot(_ sender: Any) {
        let theUser = userList[0]
        let alertController = UIAlertController(title: theUser.firstName, message: "Are you safe from harm?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let safe = UIAlertAction(title: "Safe", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            let ID = theUser.id
            let status = "green"
            
            self.updateUser(id: ID!, firstName: theUser.firstName!, lastName: theUser.lastName!, email: theUser.email!, password: theUser.password!, phone: theUser.phoneNumber!, streetAddress: "theUser.streetAddress!", city: theUser.city!, state: theUser.state!, zip: theUser.zip!, status: status, shareLocation: theUser.shareLocation!)
            print("Safe Button Pressed")
            self.statusDot.setBackgroundImage(UIImage(named:"green.png"), for: UIControlState.normal)
            self.userList[0].status = "green"
            self.addPost(status: status)
            
        })
        let unsafe = UIAlertAction(title: "Unsafe", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            let ID = theUser.id
            let status = "red"
            
            self.updateUser(id: ID!, firstName: theUser.firstName!, lastName: theUser.lastName!, email: theUser.email!, password: theUser.password!, phone: theUser.phoneNumber!, streetAddress: "theUser.streetAddress!", city: theUser.city!, state: theUser.state!, zip: theUser.zip!, status: status, shareLocation: theUser.shareLocation!)
            print("Unsafe Button Pressed")
            self.statusDot.setBackgroundImage(UIImage(named:"red.png"), for: UIControlState.normal)
            self.userList[0].status = "red"
            self.addPost(status: status)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (_) in }
        alertController.addAction(cancelAction)
        alertController.addAction(safe)
        alertController.addAction(unsafe)
        present(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var statusDot: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refPosts = Database.database().reference().child("posts");
        
        //observing the data changes
        refPosts.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.postList.removeAll()
                
                //iterating through all the values
                for posts in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let postObject = posts.value as? [String: AnyObject]
                    let postId  = postObject?["id"]
                    let postUser  = postObject?["user"]
                    let postTime = postObject?["time"]
                    let postPost = postObject?["post"]
                    let postStatus = postObject?["postStatus"]
                    
                    //creating artist object with model and fetched values
                    let post = PostModel(id: postId as! String?, user: postUser as! String?, post: postPost as! String?, time: postTime as! String?, postStatus: postStatus as! String?)
                    
                    //appending it to list
                    
                    if(post.user == Auth.auth().currentUser?.email) {
                        self.postList.append(post)
                    }
                }
                self.profileTableView.reloadData()
                
            }
            
        })
        
        userList = [UserModel(id: "", firstName: "", lastName: "", email: "", password: "", phoneNumber: "", streetAddress: "", city: "", state: "", zip: "", status: "green", shareLocation: "True")]
        
        refUsers = Database.database().reference().child("users");
        
        //observing the data changes
        refUsers.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.userList.removeAll()
                
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
                    let userStreetAddress = userObject?["streetAdress"]
                    let userCity  = userObject?["city"]
                    let userState = userObject?["state"]
                    let userZip = userObject?["zip"]
                    let userStatus = userObject?["status"]
                    let userShareLocation = userObject?["shareLocation"]
                    
                    //creating artist object with model and fetched values
                    let user = UserModel(id: userId as! String?, firstName: userFirstName as! String?, lastName: userLastName as! String?, email: userEmail as! String?, password: userPassword as! String?, phoneNumber: userPhoneNumber as! String?, streetAddress: userStreetAddress as! String?, city: userCity as! String?, state: userState as! String?, zip: userZip as! String?, status: userStatus as! String?, shareLocation: userShareLocation as! String?)
                    
                    //appending it to list
                    if(user.email == Auth.auth().currentUser?.email){
                    self.userList.append(user)
                        if user.status == "red"{
                            self.statusDot.setBackgroundImage(UIImage(named:"red.png"), for: UIControlState.normal)
                            self.name.text = "\(String!(user.firstName!)!) \(String!(user.lastName!)!)"
                        }
                        else{
                            self.statusDot.setBackgroundImage(UIImage(named:"green.png"), for: UIControlState.normal)
                            self.name.text = "\(String!(user.firstName!)!) \(String!(user.lastName!)!)"
                        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        //the follower object
        let post: PostModel

        
        //getting the follower of selected position
        post = postList[postList.count - 1  - indexPath.row]
        

        
        cell.post?.text = post.post
        cell.time?.text = post.time!


        if post.postStatus == "red"{
            cell.statusDot.image = UIImage(named:"red.png")
        }
        if post.postStatus == "green"{
            cell.statusDot.image = UIImage(named:"green.png")
        }
        
        return cell

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.profileTableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func updateUser(id:String, firstName:String, lastName:String,email:String, password:String, phone:String, streetAddress:String,city:String, state:String, zip:String, status:String, shareLocation: String){
        //creating user with the new given values
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
        
        //updating the user using the key of the artist
        refUsers.child(id).setValue(user)
        
    }
    func addPost(status: String){
        //generating a new key
        //and also getting the generated key
        let key = refPosts.childByAutoId().key
        print(NSDate().description)
        //creating user with the given values
        var safeString = ""
        if (status == "red"){
            safeString = "not safe"
        }
        if (status == "green"){
            safeString = "safe"
        }
        
        let post = ["id":key,
                    "user": Auth.auth().currentUser?.email as! String,
                    "post": "\(String!(self.userList[0].firstName!)!) \(String!(self.userList[0].lastName!)!) is \(String!(safeString)!)",
                    "time" : NSDate().description,
                    "postStatus" : status
            
            ] as [String : Any]
        
        //adding the user inside the generated unique key
        refPosts.child(key).setValue(post)
        
    }
}
