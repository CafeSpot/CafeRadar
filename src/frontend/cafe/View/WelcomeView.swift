//
//  WelcomeView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/8.
//

import SwiftUI
import FirebaseAuth


struct WelcomeView: View {
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
                    
             guard let user = result?.user,
                   error == nil else {
                 print(error?.localizedDescription)
                 return
             }
             print(user.email, user.uid)
        }
    }

    func login_method1(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
             guard error == nil else {
                print(error?.localizedDescription)
                return
             }
           print("success")
        }
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
