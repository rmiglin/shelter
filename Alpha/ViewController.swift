//
//  ViewController.swift
//  Alpha
//
//  Created by Karla Padron on 10/27/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class mapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var back: UIButton!
    @IBAction func back(_ sender: Any) {
        theView.bringSubview(toFront: tableViewFollowers)
        self.back.isHidden = true
    }
    @IBOutlet weak var tableViewFollowers: UITableView!
    var followerList = [FollowerModel]()
    var refFollowers: DatabaseReference!
    var userList = [UserModel]()
    var refUsers: DatabaseReference!
    var count = 0.001
    var name = ""
    var selectedIndex = 0

    @IBOutlet var theView: UIView!
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //clear map of annotations
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        //add back annotations
        self.tableViewFollowers.reloadData()
        let initialLocation = CLLocation(latitude: 30.2907, longitude: -97.7472)
        centerMapOnLocation(location: initialLocation)
        self.mapView.showsUserLocation = true;
        
        // Create the recognizer and set direction
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(mapViewController.tapGesture(_:)))
        
        // Associate the recognizer with the view.
        self.mapView.addGestureRecognizer(recognizer)
        
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
                    
                    //creating artist object with model and fetched values
                    let follower = FollowerModel(id: followerId as! String?, follower: followerFollower as! String?, currentUser: followerCurrentUser as! String?)
                    
                    //appending it to list
                    if(follower.currentUser == Auth.auth().currentUser?.email ) {
                        self.followerList.append(follower)
                    }
                }
                
            }
        })
        
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
                    
                    //creating artist object with model and fetched values
                    let user = UserModel(id: userId as! String?, firstName: userFirstName as! String?, lastName: userLastName as! String?, email: userEmail as! String?, password: userPassword as! String?, phoneNumber: userPhoneNumber as! String?, streetAddress: userStreetAddress as! String?, city: userCity as! String?, state: userState as! String?, zip: userZip as! String?)
                    
                    //appending it to list
                    self.userList.append(user)

                }
                self.tableViewFollowers.reloadData()
            }
            
        })
        self.back.isHidden = true

    }
    
    
    let regionRadius: CLLocationDistance = 1200
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func tapGesture(_ sender: AnyObject) {
        if (self.back.isHidden == true){
            theView.bringSubview(toFront: mapView)
            self.back.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell", for: indexPath) as! MapFollowerTableViewCell
        print("map test")
        //the follower object
        let follower: FollowerModel
        
        //getting the follower of selected position
        follower = followerList[indexPath.row]
        
        var theUser: UserModel
        theUser = userList[0]
        
        for user in userList
        {
            if(user.email == follower.follower)
            {
                theUser = user
            }
        }

        cell.name?.text = "\(String!(theUser.firstName!)!)  \(String!(theUser.lastName!)!)"
        name = "\(String!(theUser.firstName!)!)  \(String!(theUser.lastName!)!)"
        
        let loc = Location(  title: theUser.firstName!,
                             locationName: "Current Location",
                             discipline: "Sculpture",
                             coordinate: CLLocationCoordinate2D(latitude: 30.2907, longitude: -97.7472+count))
        mapView.addAnnotation(loc)
        count+=0.004
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
        cell.location?.text = "(\(String(loc.coordinate.latitude)), \(String(loc.coordinate.longitude)))"
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code to execute on click
        //the follower object
        let follower: FollowerModel
        //getting the follower of selected position
        follower = followerList[indexPath.row]
        var theUser: UserModel
        theUser = userList[0]
        
        for user in userList
        {
            if(user.email == follower.follower)
            {
                theUser = user
            }
        }
        
        
        var counter = 0
        for annotation in mapView.annotations{
            if (annotation.title! == theUser.firstName!){
                selectedIndex = counter
            }
            counter += 1
        }
        mapView.selectAnnotation(mapView.annotations[selectedIndex], animated: true)
        print(mapView.annotations[selectedIndex].coordinate)
        let userLocation = CLLocation(latitude: mapView.annotations[selectedIndex].coordinate.latitude, longitude: mapView.annotations[selectedIndex].coordinate.longitude)
        centerMapOnLocation(location: userLocation)
        theView.bringSubview(toFront: mapView)
        self.back.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //clear map of annotations
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        count = 0.001
        //add all current annotations
        self.tableViewFollowers.reloadData()
    }

}

