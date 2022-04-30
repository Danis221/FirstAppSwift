//
//  AbstractAuthViewController.swift
//  Aggro
//
//  Created by Danis on 21.04.2022.
//

import UIKit

class AbstractAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     func goToProfile() {
        
        let profileViewController  = storyboard?.instantiateViewController(withIdentifier: "profileVC" )
        
        view.window?.rootViewController = profileViewController
        view.window?.makeKeyAndVisible()
    }
    
     func showAlert() {
        let alert = UIAlertController(title: "Error", message: "fill in all the fields of the form", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
