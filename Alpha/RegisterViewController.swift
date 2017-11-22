//
//  RegisterViewController.swift
//  Alpha
//
//  Created by Karla Padron on 10/28/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    var refUsers: DatabaseReference!
    
    @IBOutlet var zip: UITextField!
    
    @IBOutlet var state: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var streetAddress: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var enterEmail: UITextField!
    @IBOutlet var enterPassword: UITextField!
    
    @IBAction func register(_ sender: Any) {
        
        if enterEmail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: enterEmail.text!, password: enterPassword.text!) { (user, error) in
                
                if error == nil {
                    self.addUser()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tab")
                    self.present(vc!, animated: true, completion: nil)

                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refUsers = Database.database().reference().child("users");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addUser(){
        //generating a new key
        //and also getting the generated key
        let key = refUsers.childByAutoId().key
        
        //creating user with the given values
        let user = ["id":key,
                      "firstName": firstName.text! as String,
                      "lastName": lastName.text! as String,
                      "enterEmail": enterEmail.text! as String,
                      "enterPassword": enterPassword.text! as String,
                      "phoneNumber": phoneNumber.text! as String,
                      "streetAddress": streetAddress.text! as String,
                      "city": city.text! as String,
                      "state": state.text! as String,
                      "zip": zip.text! as String,
                      "status": "green",
<<<<<<< HEAD
                      "shareLocation": "True"
=======
                      "shareLocation" : "True"
            
>>>>>>> 9267f6a98b89c01b63411aa95c2c4d2db7600a01
        ]
        
        //adding the user inside the generated unique key
        refUsers.child(key).setValue(user)

    }

    // This method is called when the user touches the Return key on the
    // keyboard. The 'textField' passed in is a pointer to the textField
    // the cursor was in at the time they touched the Return key on the
    // keyboard.
    //
    // From the Apple documentation: Asks the delegate if the text field
    // should process the pressing of the return button.
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 'First Responder' is the same as 'input focus'.
        // We are removing input focus from the text field.
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
