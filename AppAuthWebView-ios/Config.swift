
import Foundation

class Config {
    let Issuer: String!
    let ClientID: String!
    let RedirectURI: String!
    let ApiEndpoint: URL!
    let ClientSecret : String!
    
    init(){
        Issuer = "https://YOUR_ISSUER.com"
        ClientID = "YOUR_CLIENT_ID"
        ApiEndpoint = URL(string: "https://YOUR_ISSUER.com/connect/authorize")
        RedirectURI = "YOUR_REDIRECT_URI"
        ClientSecret = "YOUR_CLIENT_SECRET"
    }

}
