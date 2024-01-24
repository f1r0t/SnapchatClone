//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Fırat AKBULUT on 25.10.2023.
//

import UIKit
import FirebaseAuth


class SettingsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toSingIn", sender: self)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
}
