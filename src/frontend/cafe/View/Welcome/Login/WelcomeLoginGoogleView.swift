//
//  WelcomeLoginGoogleView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/9.
//

import SwiftUI

import SwiftUI
import FirebaseAuth

struct WelcomeLoginGoogleView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    init() {
        Auth.auth().useEmulator(withHost:"127.0.0.1", port:9000)
    }

    var body: some View {
        VStack{
            HStack{
                Text("email: ")
                TextField("email", text: $email)
            }
            HStack{
                Text("password: ")
                TextField("password", text: $password)
            }
            HStack{
                Button(action: { createUser_method1() }) {
                    Text("create accound")
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Button(action: { login_method1() }) {
                    Text("Sign in")
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    func createUser_method1(){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        
            guard let user = result?.user, error == nil else {
                if let errorMessage = error?.localizedDescription {
                    print(errorMessage)
                } else {
                    print("Unknown error occurred.")
                }
                return
            }
            print(user.email ?? "No email", user.uid)
        }
    }

    func login_method1(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                if let errorMessage = error?.localizedDescription {
                    print(errorMessage)
                } else {
                    print("Unknown error occurred.")
                }
                return
            }
            print("Success")
        }
    }
}

#Preview {
    WelcomeLoginGoogleView()
}
