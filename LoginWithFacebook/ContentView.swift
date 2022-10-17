import SwiftUI

struct ContentView: View {
    
    /// These variables get setup in the FacebookLoginButton view
    @AppStorage("facebookLoggedIn") var facebookLoggedIn = false
    @AppStorage("facebookEmail") var facebookEmail = ""
    @AppStorage("facebookName") var facebookName = ""
    
    var body: some View {
        
        if !self.facebookLoggedIn {
            /// For Facebook Login to work, you need to add your APP-ID and Client Token to your TARGET info.plist file
            ///  see the documentation here https://developers.facebook.com/docs/facebook-login/ios/
            ///  i.e. select your application->target->info and add these to the plist file
            
            LottieView(lottieFile: "Facebook", loopMode: .playOnce)
                .padding()
            FacebookLoginButton()
                .padding(.horizontal)
                .frame(height: 50)
            
        } else {
            VStack {
                ZStack(alignment: .center) {
                    LottieView(lottieFile: "space", loopMode: .loop)
                    Text("Hello \(facebookName)!").font(.custom("Futura-Medium", size: 26)).bold().padding().shadow(radius: 3)
                }
                
                FacebookLoginButton()
                    .padding(.horizontal)
                    .frame(height: 50)
            }

        }
    }
}
