//
//  SettingView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/10.
//

import SwiftUI

struct UserInfoView: View {
    @EnvironmentObject var authManager : AuthManager
    @Environment(UserModel.self) private var userModel
    
    @State private var showLoginPage = false
    
    @State private var isShowingSheet = false
    @State private var isModifiedSuccessfully = false

    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                
                Text(authManager.signedIn ? "Login" : "Log out")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(20)
                
                HStack{
                    Text("Name: ")
                    Text(userModel.user.name ?? "")
                }
                
                HStack{
                    Text("ID: ")
                    Text(userModel.user.userId ?? "")
                }
                
                HStack{
                    Text("Phone: ")
                    Text(userModel.user.phone ?? "")
                }
                
                HStack{
                    Text("Email: ")
                    Text(userModel.user.email ?? "")
                }
            }
            Spacer()
            
            HStack(){
                if authManager.signedIn{
                    Button {
                        print("[SettingView]: Tapped google sign out")
                        authManager.regularSignOut() { error in
                            if let e = error {
                                print("[SettingView]: google sign out ~~ ",e.localizedDescription)
                            }
                        }
                        authManager.googleSignOut()
                    } label: {
                        HStack(){
                            Text("登出")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(5)
                } else {
                    Button(action: {
                        showLoginPage = true
                    }) {
                        Text("登入")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showLoginPage) {
                        AccountView()
                    }
                    .padding(5)
                }
                
                Button("更改") {
                    isShowingSheet.toggle() // Show the sheet
                }
                .sheet(isPresented: $isShowingSheet, onDismiss: {
                    if isModifiedSuccessfully {
                        // Perform actions after successful modification if needed
                        print("User info modified successfully!")
                    }
                }) {
                    // Present the ModifyUserInfoView as a sheet
                    ModifyUserInfoView(isShowingSheet: $isShowingSheet, isModifiedSuccessfully: $isModifiedSuccessfully, name: userModel.user.name ?? "", email: "henry19971010@yahoo.com.tw", phone: "0978592955")
                }
            }
        }
    }
}

#Preview {
    UserInfoView()
        .environmentObject(AuthManager())
        .environment(UserModel())
}
