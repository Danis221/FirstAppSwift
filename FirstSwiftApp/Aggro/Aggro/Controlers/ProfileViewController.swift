import UIKit
import Firebase
import FirebaseStorage


class ProfileViewController: UIViewController {
    
    private var isEdit = false
    var imagePickerComtroller: UIImagePickerController!
    private  let storage = Storage.storage().reference()
    @IBOutlet weak var photoImageView: UIImageView!
    var imagePicker:UIImagePickerController!
   
    @IBOutlet weak var idLable: UILabel!
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var emailLable: UILabel!
    
    private var currentUser: User!
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            signOut()
        }
        
        fetchUser()
    }
    
   
    
    //MARK: out
    @IBAction func buttonSignOut(_ sender: Any) {
   
    let alertController = UIAlertController(title: nil, message: "Are you sure you wnant to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "sign out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            goToAuth()
        } catch let error {
            print("error:\(error)")
        }
    }
    
    private func goToAuth() {
       let authViewController  = storyboard?.instantiateViewController(withIdentifier: "authVC" )
        
        view.window?.rootViewController = authViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    
    //MARK: profile
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else {return}
                
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let url = data["url"]  as? String ?? ""
                let currentUser = User(id: id, name: name, email: email, url: url)
                
                self.idLable.text = currentUser.id
                self.nameLable.text = currentUser.name
                self.emailLable.text = currentUser.email
                self.set(user: currentUser)
               // self.photoImageView.userActivity?.webpageURL = currentUser.url.resizableImage(withCapInsets: <#T##UIEdgeInsets#>)
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
   

    private func set(user:User) {
        if let url = URL(string: user.url ?? "") {
            ImageService.getImage(withURL: url) { image in
                    self.photoImageView.image = image
            }
        }
    }
    
  // MARK: update
    
    
    
    @IBAction func uplaodTupped(_ sender: Any) {
        isEdit = !isEdit
    }
    
    private func saveInfo() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let email = Auth.auth().currentUser?.email
        let currentUser = Auth.auth().currentUser
        
        
    }
}



