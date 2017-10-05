//
//  WebViewVC.swift
//  AppAuthWebView-ios
//
//  Created by Hadi Dbouk on 10/5/17.
//  Copyright © 2017 Hadi Dbouk. All rights reserved.
//

import UIKit
import WebKit
import AppAuth

class WebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var AppConfig: Config!
    var AuthRequest: OIDAuthorizationRequest!
    var AuthConfiguration: OIDServiceConfiguration!
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        AppConfig = Config()

        addWKWebView()
    }

    private func addWKWebView() -> Void {

        let issuer = URL(string: AppConfig.Issuer)
        let redirectURI = URL(string: AppConfig.RedirectURI!)

        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer!) {
            config, error in

            self.AuthConfiguration = config

            if config == nil {
                print("Error retrieving discovery document: \(String(describing: error?.localizedDescription))")
                return
            } else {
                print("Retrieved configuration: \(config!)")
            }

            let scopes = [OIDScopeOpenID, "bliss-api", "offline_access"]

            self.AuthRequest = OIDAuthorizationRequest(configuration: config!,
                                                       clientId: self.AppConfig.ClientID,
                                                       clientSecret: self.AppConfig.ClientSecret,
                                                       scope: OIDScopeUtilities.scopes(with: scopes),
                                                       redirectURL: redirectURI,
                                                       responseType: OIDResponseTypeCode,
                                                       state: self.generateState(),
                                                       codeVerifier: nil,
                                                       codeChallenge: nil,
                                                       codeChallengeMethod: nil,
                                                       additionalParameters: nil)

            let url = self.AuthRequest.authorizationRequestURL() as URL
            let urlRequest = URLRequest(url: url)
            self.webView.load(urlRequest)
        }
    }

    func generateState() -> String? {
        return OIDTokenUtilities.randomURLSafeString(withSize: 32)
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    //Delegates
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

        let url = webView.url?.absoluteURL

        if (url?.absoluteString.hasPrefix(AppConfig.RedirectURI))! {

            //Perform Token Request

            let query = OIDURLQueryComponent(url: url!)
            var response: OIDAuthorizationResponse? = nil

            response = OIDAuthorizationResponse(request: AuthRequest, parameters: query!.dictionaryValue)

            if (AuthRequest.responseType == OIDResponseTypeCode) {
                // if the request is for the code flow (NB. not hybrid), assumes the
                // code is intended for this client, and performs the authorization
                // code exchange
                let tokenExchangeRequest: OIDTokenRequest? = response?.tokenExchangeRequest()
                OIDAuthorizationService.perform(tokenExchangeRequest!, callback: { (_ tokenResponse: OIDTokenResponse?, _ tokenError: Error?) -> Void in
                    var authState: OIDAuthState?
                    if tokenResponse != nil {
                        authState = OIDAuthState(authorizationResponse: response!, tokenResponse: tokenResponse)
                        print("\n\n AccessToken : \(String(describing: authState?.lastTokenResponse?.accessToken))")
                    }
                })
            }
                else {
                    // implicit or hybrid flow (hybrid flow assumes code is not for this
                    // client)
                    let authState = OIDAuthState(authorizationResponse: response!)
                    print("\n\n AccessToken : \(String(describing: authState.lastTokenResponse?.accessToken))")
            }

        }
    }
}
