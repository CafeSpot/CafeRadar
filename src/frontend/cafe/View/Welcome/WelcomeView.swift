//
//  WelcomeView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/8.
//

import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn

struct WelcomeView: View {
    //@Environment(AuthModel.self) private var authModel
    
    @State private var email: String = ""
    @State private var password: String = ""

    
    init() {
    }

    var body: some View {
        VStack{
            Text("Hello")
                .font(.system(size: 40)) // Set the font size to make it bigger
                .fontWeight(.bold) // Make the text thick (bold)
            
            
            TextField("email", text: $email)
                .padding(6)
                .autocapitalization(.none)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(width: 300, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 5) // Matching the corner radius
                        .stroke(Color.gray, lineWidth: 1) // Outline color and width
                )
            TextField("passward", text: $password)
                .padding(6)
                .autocapitalization(.none)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(width: 300, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 5) // Matching the corner radius
                        .stroke(Color.gray, lineWidth: 1) // Outline color and width
                )
            Button {
                print("[WelcomeView] Tapped Create with email & passward")
                //authModel.regularCreateAccount(email: email, password: password)
            } label: {
                Text("Create with email & passward")
                    .foregroundColor(.black)
            }
            Button {
                print("[WelcomeView] Sign in with email & passward")
                //authModel.regularSignIn(??)
            } label: {
                Text("Sign in with email & passward")
                    .foregroundColor(.black)
            }
            
            Text("or")
            
            // sign in with google account
            Button {
                print("[WelcomeView] Tapped google sign in")
                //authModel.googleSignIn()
            } label: {
                HStack(){
                    Image("google")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45)
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
            
            Button {
                print("[WelcomeView] Just visit")
                //authModel.notRequireAuth = true
            } label: {
                Text("Just visit")
                    .foregroundColor(.black)
            }
            .padding(.top, 80)
        }
    }
}


#Preview {
    WelcomeView()
        //.environment(AuthModel())
}

