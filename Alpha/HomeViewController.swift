//
//  HomeViewController.swift
//  Alpha
//
//  Created by Karla Padron on 10/28/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingTableView: UITableView!
    var userList = [UserModel]()
    var refUsers: DatabaseReference!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        var theUser: UserModel
        theUser = userList.first!
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "General", for: indexPath) as! GeneralTableViewCell
        
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "General", for: indexPath) as! GeneralTableViewCell
            cell.email.text = theUser.email
            cell.name.text = theUser.firstName
            cell.phone.text = theUser.phoneNumber
            cell.username.text = theUser.status
            if theUser.status == "green"{
                cell.username.text = "safe"
            }
            if theUser.status == "red"{
                cell.username.text = "unsafe"
            }
            cell.password.text = theUser.password
            return cell
        }
        if indexPath.row == 1{
             let cell = tableView.dequeueReusableCell(withIdentifier: "Privacy", for: indexPath)
            return cell
        }
        if indexPath.row == 2{
             let cell = tableView.dequeueReusableCell(withIdentifier: "Location", for: indexPath)
            return cell
        }
        if indexPath.row == 3{
             let cell = tableView.dequeueReusableCell(withIdentifier: "Notifications", for: indexPath)
            return cell
        }
        return cell1
    }
    

    @IBAction func logout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.settingTableView.reloadData()
        // Do any additional setup after loading the view.
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
                self.settingTableView.reloadData()
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //clear map of annotations
        self.settingTableView.reloadData()
    }
}
