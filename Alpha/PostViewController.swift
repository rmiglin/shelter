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
    
    //var userList = [UserModel]()
    //var refUsers: DatabaseReference!
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
        
        self.addPost()
        _ = navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        refPosts = Database.database().reference().child("posts");
        
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPost(){
        //generating a new key
        //and also getting the generated key
        let key = refPosts.childByAutoId().key
        print(NSDate().description)
        //creating user with the given values
        let post = ["id":key,
                    "user": Auth.auth().currentUser?.email as! String,
                    "post": self.post.text,
                    "time" : NSDate().description
            
            ] as [String : Any]
        
        //adding the user inside the generated unique key
        refPosts.child(key).setValue(post)
        
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
