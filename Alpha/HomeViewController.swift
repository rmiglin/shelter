//
//  HomeViewController.swift
//  Alpha
//
//  Created by Karla Padron on 10/28/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import FirebaseAuth



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "General", for: indexPath) as! GeneralTableViewCell
        
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "General", for: indexPath) as! GeneralTableViewCell
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
