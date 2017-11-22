//
//  AddFollowerViewController.swift
//  Alpha
//
//  Created by Karla Padron on 11/3/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddFollowerViewController: UIViewController {
    
    var userList = [UserModel]()
    var refUsers: DatabaseReference!
    var refFollowers: DatabaseReference!

    @IBOutlet var username: UITextField!
    
    @IBAction func Submit(_ sender: Any) {
        if username.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            var counter = 1
            for user in userList{
                if(username.text == user.email){
                    self.addFollower()
                    _ = navigationController?.popViewController(animated: true)
                    print("added")
                    counter = -1
                }
                if(counter == userList.count)
                {
                    let alertController = UIAlertController(title: "Error", message: "This email does not have a Shelter account", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    print("alert")
                    present(alertController, animated: true, completion: nil)
                }
                counter+=1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refFollowers = Database.database().reference().child("followers");
        
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
                    
                    //creating artist object with model and fetched values
                    let user = UserModel(id: userId as! String?, firstName: userFirstName as! String?, lastName: userLastName as! String?, email: userEmail as! String?, password: userPassword as! String?, phoneNumber: userPhoneNumber as! String?, streetAddress: userStreetAddress as! String?, city: userCity as! String?, state: userState as! String?, zip: userZip as! String?,
                        status: userStatus as! String?)
                    
                    //appending it to list
                    self.userList.append(user)
                }
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addFollower(){
        //generating a new key
        //and also getting the generated key
        let key = refFollowers.childByAutoId().key
        
        //creating user with the given values
        let user = ["id":key,
                    "follower": username.text! as String,
                    "currentUser": Auth.auth().currentUser?.email as! String

        ]
        
        //adding the user inside the generated unique key
        refFollowers.child(key).setValue(user)
        
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
