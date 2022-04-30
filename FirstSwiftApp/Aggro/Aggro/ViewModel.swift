/**import Foundation
import Firebase

class ViewModel: ObservableObject {
    
    
    
    func getUser() -> User {
        let db = Firestore.firestore()
        
        db.collection("user").document("users").getDocument { snapshot, error in
            if error == nil {
                if snapshot != nil && snapshot!.exists {
                    let snapshotData = snapshot!.data()
                }
            }
        }
        
    }
    return User(snapshotData)
}
*/
