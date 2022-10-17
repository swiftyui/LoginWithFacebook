import Foundation
import UIKit
import SwiftUI
import FBSDKCoreKit
import FBSDKLoginKit

struct FacebookLoginButton: UIViewRepresentable {
    

    @AppStorage("facebookLoggedIn") var facebookLoggedIn = false
    @AppStorage("facebookEmail") var facebookEmail = ""
    @AppStorage("facebookName") var facebookName = ""

    func makeCoordinator() -> Coordinator {
        return FacebookLoginButton.Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> some FBLoginButton {
        let view = FBLoginButton()
        view.permissions = ["public_profile", "email", "user_friends"]
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    class Coordinator: NSObject, LoginButtonDelegate {

        var parent: FacebookLoginButton

        init(parent: FacebookLoginButton) {
            self.parent = parent
        }

        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            /// Something went wrong
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            /// User didn't cancel
            if !result!.isCancelled {
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture"])
                request.start { (_,result,_) in
                    guard let profiledata = result as? [String: Any] else { return }
                    self.parent.facebookName  = profiledata["name"] as! String
                    self.parent.facebookEmail = profiledata["email"] as! String
                    self.parent.facebookLoggedIn = true
                    
                    ///  Here is the users ID as well as accesstokens
                    let fbUserID = profiledata["id"] ?? ""
                    let fbAccessToken = AccessToken.current?.tokenString ?? ""
                    let fbResult = "id=\(fbUserID)&accessToken=\(fbAccessToken)"
                    print(fbResult)
                    
                }
            }
        }

        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            self.parent.facebookEmail         = ""
            self.parent.facebookLoggedIn      = false
            self.parent.facebookName          = ""
        }


    }
}

