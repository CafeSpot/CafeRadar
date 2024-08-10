//
//  LoginView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/10.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthModel.self) private var authModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var loginMessage: String = ""
    
    var body: some View {
        VStack(){
            TextField("email", text: $email)
                .padding(6)
                .autocapitalization(.none)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(width: 300, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 5) // Matching the corner radius
                        .stroke(Color.gray, lineWidth: 1) // Outline color and width
                )
            SecureField("passward", text: $password)
                .padding(6)
                .autocapitalization(.none)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(width: 300, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 5) // Matching the corner radius
                        .stroke(Color.gray, lineWidth: 1) // Outline color and width
                )
            if loginMessage != "" {
                Text(loginMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
            
            HStack(){
                Button {
                    print("[WelcomeView] Tapped Create with email & passward")
                    authModel.regularCreateAccount(email: email, password: password)
                    loginMessage = ""
                } label: {
                    Text("Create")
                        .foregroundColor(.black)
                }
                .padding(5)
                
                Button {
                    print("[WelcomeView] Sign in with email & passward")
                    authModel.regularSignIn(email: email, password: password) { error in
                        if let e = error {
                            print("[WelcomeView] Sign in with email & passward ~~ ",e.localizedDescription)
                            loginMessage = e.localizedDescription
                        }
                        else{
                            loginMessage = ""
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } label: {
                    Text("Sign In")
                        .foregroundColor(.black)
                }
                .padding(5)
            }
            
            Text("or")
                .font(.system(size: 15))
            
            // sign in with google account
            Button {
                print("[WelcomeView] Tapped google sign in")
                authModel.googleSignIn()
                loginMessage = ""
            } label: {
                HStack(){
                    Image("google")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 37)
                    Text("Sign in with Google")
                        .foregroundColor(.black)
                }
            }
            
            // sign in with google account
            Button {
                print("[WelcomeView] Sign in with Apple")
                //authModel.authorizationController()
            } label: {
                HStack(){
                    Image("apple")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                    Text("Sign in with Apple")
                        .foregroundColor(.black)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .presentationDetents([.fraction(0.7)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(40)
    }
}

#Preview {
    LoginView()
        .environment(AuthModel())
}
