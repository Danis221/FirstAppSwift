
import Foundation

struct User  {
    var id: String
    var name: String
    var email: String
    var password: String?
    var url:String?
    init(id: String, name: String, email: String, url: String) {
        self.id = id
        self.name = name
        self.email = email
        self.url = url
        
    }
    
   
}
