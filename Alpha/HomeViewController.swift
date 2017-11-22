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

    @IBAction func editGeneral(_ sender: Any) {
        //getting the selected artist
        let user  = userList[0]
        
        //building an alert
        let alertController = UIAlertController(title: user.firstName, message: "Give new values to update ", preferredStyle: .alert)

        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in

            //getting user id
            let id = user.id
            
            //getting new values
            let firstName = alertController.textFields?[0].text
            let lastName = alertController.textFields?[1].text
            //let status = alertController.textFields?[2].text
            let password = alertController.textFields?[2].text
            let phone = alertController.textFields?[3].text
            let email = alertController.textFields?[4].text
            let streetAddress = alertController.textFields?[5].text
            let city = alertController.textFields?[6].text
            let state = alertController.textFields?[7].text
            let zip = alertController.textFields?[8].text
           
            self.updateUser(id: id!, firstName: firstName!, lastName: lastName!, email: email!, password: password!, phone: phone!, streetAddress: streetAddress!, city: city!, state: state!, zip: zip!)
        })
        
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = user.firstName
        }
        alertController.addTextField { (textField) in
            textField.text = user.lastName
        }
        alertController.addTextField { (textField) in
            textField.text = user.password
        }
        alertController.addTextField { (textField) in
            textField.text = user.phoneNumber
        }
        alertController.addTextField { (textField) in
            textField.text = user.email
        }
        alertController.addTextField { (textField) in
            textField.text = "user.streetAddess"
        }
        alertController.addTextField { (textField) in
            textField.text = user.city
        }
        alertController.addTextField { (textField) in
            textField.text = user.state
        }
        alertController.addTextField { (textField) in
            textField.text = user.zip
        }
        
        //adding action
        //alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.addAction(ok)
        //presenting dialog
        present(alertController, animated: true, completion: nil)
    }

    func updateUser(id:String, firstName:String, lastName:String,email:String, password:String, phone:String, streetAddress:String,city:String, state:String, zip:String){
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
                    "status": userList[0].status
        ]
        
        //updating the artist using the key of the artist
        refUsers.child(id).setValue(user)
        
        //displaying message
        //labelMessage.text = "Artist Updated"
    }


    @IBOutlet weak var settingTableView: UITableView!
    var userList = [UserModel]()
    var refUsers: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        // Do any additional setup after loading the view.
        refUsers = Database.database().reference().child("users");
        
        //self.userList = UserModel()
        
        //observing the data changes
        userList = [UserModel(id: "", firstName: "", lastName: "", email: "", password: "", phoneNumber: "", streetAddress: "", city: "", state: "", zip: "", status: "")]
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
                    let userStreetAddress = userObject?["streetAdress"]
                    let userCity  = userObject?["city"]
                    let userState = userObject?["state"]
                    let userZip = userObject?["zip"]
                    let userStatus = userObject?["status"]
                    
                    //creating artist object with model and fetched values
                    let user = UserModel(id: userId as! String?, firstName: userFirstName as! String?, lastName: userLastName as! String?, email: userEmail as! String?, password: userPassword as! String?, phoneNumber: userPhoneNumber as! String?, streetAddress: userStreetAddress as! String?, city: userCity as! String?, state: userState as! String?, zip: userZip as! String?,
                                         status: userStatus as! String?)
                    
                    //appending it to list
                    
                    if(user.email! == Auth.auth().currentUser!.email! ) {
                        self.userList = [user]
                        self.settingTableView.reloadData()
                    }
                }
                
            }
            
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "General", for: indexPath) as! GeneralTableViewCell
        
        var theUser: UserModel
        print(userList)
        theUser = userList[0]
        
        
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "General", for: indexPath) as! GeneralTableViewCell
            
            cell.email.text = theUser.email
            cell.name.text = theUser.firstName
            cell.phone.text = theUser.phoneNumber
            cell.username.text = theUser.status
            cell.streetAddress.text = "theUser.streetAddress"
            cell.city.text = theUser.city
            cell.state.text = theUser.state
            cell.zip.text = theUser.zip
            
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

