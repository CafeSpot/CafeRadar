//
//  SettingView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/10.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authModel : AuthManager
    @State private var showLoginPage = false
    
    var body: some View {
        VStack(){
            
            Text(authModel.signedIn ? "Login" : "Log out")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(20)
            
            Spacer()
            
            HStack(){
                Button(action: {
                    showLoginPage = true
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showLoginPage) {
                    AccountView()
                }
                .padding(5)
                
                Button {
                    print("[SettingView]: Tapped google sign out")
                    authModel.regularSignOut() { error in
                        if let e = error {
                            print("[SettingView]: google sign out ~~ ",e.localizedDescription)
                        }
                    }
                    authModel.googleSignOut()
                } label: {
                    HStack(){
                        Text("Sign out")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                .padding(5)
            }
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(AuthManager())
}
