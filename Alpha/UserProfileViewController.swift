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
    @IBOutlet weak var profileTableView: UITableView!
    
    var postList = [PostModel]()
    var refPosts: DatabaseReference!

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
                    
                    //creating artist object with model and fetched values
                    let post = PostModel(id: postId as! String?, user: postUser as! String?, post: postPost as! String?, time: postTime as! String?)
                    
                    //appending it to list
                    
                    if(post.user == Auth.auth().currentUser?.email) {
                        self.postList.append(post)
                    }
                }
                self.profileTableView.reloadData()
                
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
        cell.time?.text = post.time

        /*
        if theUser.status == "red"{
            cell.statusDot.image = UIImage(named:"red.png")
            userDiscipline = "red"
        }
        */

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

}
