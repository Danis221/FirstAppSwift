import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class SiginViewController:  AbstractAuthViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var photoImageView: UIImageView!
   
    var imagePicker:UIImagePickerController!
    
    private  let storage = Storage.storage().reference()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(imageTap)
        photoImageView.clipsToBounds = true
            
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    func valiedateFields() -> String? {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "fill all fields"
        }
            
            return nil
    }
    
   
    
    @IBAction func sigUpTapped(_ sender: Any) {
        let error = valiedateFields()
        if error != nil {
            self.showAlert()
        } else {
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let image = photoImageView.image else { return }
            
           // guard let uid = Auth.auth().currentUser?.uid else { return }
    
           Auth.auth().createUser(withEmail: email, password: password) { resultUser, error in
                if error != nil {
                    self.showAlert()
                } else {
                        self.upload(image) { (result) in
                            switch result {
                            case .success(let url):
                                print(url.absoluteString)
                                let db = Firestore.firestore()
                                db.collection("users").document(resultUser!.user.uid).setData(["name" : name, "email" : email, "password" : password, "url" : url.absoluteString,"id" : resultUser!.user.uid])
                                self.goToProfile()
                                
                            case .failure(let error):
                                self.showAlert()
                                print(error)
                            }
                        }
                    }
                }
            }
        }
  
    
    
    
    //MARK: upload image
    
    
    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
  
   
       
    
   
  
    func upload (_ image:UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("users/\(uid)")
        
        //Storage.storage().reference().child()
        
        guard let imageData = photoImageView.image?.jpegData(compressionQuality: 0.4) else {return}
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
           storageRef.downloadURL { url, error in
               guard let url = url else {
                   completion(.failure(error!))
                   return
               }
               completion(.success(url))
            
           }

        }
        
    }
    
   
}

extension SiginViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

     
