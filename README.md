# AppAuthWebView-IOS-Sample
A Sample project of using AppAuth-ios with WKWebView instead of Safari.

## Usage

Change data in the Config file : 


```swift
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
```
