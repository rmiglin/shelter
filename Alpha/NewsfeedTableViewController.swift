//
//  NewsfeedTableViewController.swift
//  Alpha
//
//  Created by Karla Padron on 11/30/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewsfeedTableViewController: UITableViewController {
    var followerList = [FollowerModel]()
    var refFollowers: DatabaseReference!
    var userList = [UserModel]()
    var refUsers: DatabaseReference!
    var postList = [PostModel]()
    var refPosts: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Newsfeed"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        refFollowers = Database.database().reference().child("followers");
        
        //observing the data changes
        refFollowers.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.followerList.removeAll()
                
                //iterating through all the values
                for followers in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let followerObject = followers.value as? [String: AnyObject]
                    let followerFollower  = followerObject?["follower"]
                    let followerId  = followerObject?["id"]
                    let followerCurrentUser = followerObject?["currentUser"]
                    let followerShow = followerObject?["show"]
                    
                    //creating artist object with model and fetched values
                    let follower = FollowerModel(id: followerId as! String?, follower: followerFollower as! String?, currentUser: followerCurrentUser as! String?, show: followerShow as! String?)
                    
                    //appending it to list
                    
                    if(follower.currentUser == Auth.auth().currentUser?.email) {
                        self.followerList.append(follower)
                    }
                }
                
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
                    let userShareLocation = userObject?["shareLocation"] as! String?
                    
                    //creating artist object with model and fetched values
                    
                    let user = UserModel(id: userId as! String?, firstName: userFirstName as! String?, lastName: userLastName as! String?, email: userEmail as! String?, password: userPassword as! String?, phoneNumber: userPhoneNumber as! String?, streetAddress: userStreetAddress as! String?, city: userCity as! String?, state: userState as! String?, zip: userZip as! String?,status: userStatus as! String?, shareLocation: userShareLocation)
                    
                    //appending it to list
                    self.userList.append(user)
                    
                }
                self.tableView.reloadData()
            }
            
        })
        
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
                    var followerEmails = [String]()
                    for follower in self.followerList{
                        followerEmails.append(follower.follower!)
                    }
                    
                    if(followerEmails.contains(post.user!)) {
                        self.postList.append(post)
                    }
                    
                    if(post.user == Auth.auth().currentUser?.email) {
                        self.postList.append(post)
                    }
                }
                self.tableView.reloadData()
                
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedCell", for: indexPath) as! NewsfeedTableViewCell
        
        //the follower object
        let post: PostModel
        
        
        //getting the follower of selected position
        post = postList[postList.count - 1  - indexPath.row]
        
        
        
        cell.post?.text = post.post
        cell.time?.text = post.time
        
        if post.postStatus == "red"{
            cell.statusDot.image = UIImage(named:"red.png")
        }
        if post.postStatus == "green"{
            cell.statusDot.image = UIImage(named:"green.png")
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
