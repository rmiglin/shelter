//
//  FollowerProfileViewController.swift
//  Alpha
//
//  Created by Karla Padron on 12/1/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FollowerProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var postList = [PostModel]()
    var refPosts: DatabaseReference!
    var refUsers: DatabaseReference!
    


    @IBOutlet weak var statusDot: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var followerProfileTableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        //the follower object
        let post: PostModel
        
        
        //getting the follower of selected position
        post = postList[postList.count - 1  - indexPath.row]
        
        
        
        cell.post?.text = post.post
        cell.time?.text = post.time
        
        if post.postStatus == "red"{
            cell.followerStatusDot.image = UIImage(named:"red.png")
        }
        if post.postStatus == "green"{
            cell.followerStatusDot.image = UIImage(named:"green.png")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    

    var follower: FollowerModel?
    var followerUserModel: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refUsers = Database.database().reference().child("users");
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
                    
                    if(post.user == self.follower!.follower) {
                        self.postList.append(post)
                    }
                }
                self.followerProfileTableView.reloadData()
                
            }
        })

        // Do any additional setup after loading the view.
        name.text = "\(String!((followerUserModel?.firstName!)!)!) \(String!((followerUserModel?.lastName!)!)!)"
        if followerUserModel?.status == "red"{
            statusDot.setBackgroundImage(UIImage(named:"red.png"), for: UIControlState.normal)
        }
        
        self.followerProfileTableView.rowHeight = UITableViewAutomaticDimension
        self.followerProfileTableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {

        self.followerProfileTableView.reloadData()

    }
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

}
