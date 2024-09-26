//
//  SignUpView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/15.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager : AuthManager
    @Environment(UserModel.self) private var userModel
    @State var email: String = ""
    @State var password: String = ""
    @State var phone: String = ""
    @State var name: String = ""
    @State var isProcess: Bool = false
    
    var body: some View {
        VStack(){
            VStack(alignment: .leading){
                Text("Email")
                    .font(.system(size: 15, design: .default))
                TextField("  請輸入電子郵件信箱", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5) // Matching the corner radius
                            .stroke(Color.gray, lineWidth: 1) // Outline color and width
                    )
            }
            .padding(.top, 10)
            
            
            VStack(alignment: .leading){
                Text("密碼")
                    .font(.system(size: 15, design: .default))
                SecureField("  請輸入密碼", text: $password)
                    .autocapitalization(.none)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5) // Matching the corner radius
                            .stroke(Color.gray, lineWidth: 1) // Outline color and width
                    )
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading){
                Text("手機號碼")
                    .font(.system(size: 15, design: .default))
                TextField("  請輸入手機號碼", text: $phone)
                    .autocapitalization(.none)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5) // Matching the corner radius
                            .stroke(Color.gray, lineWidth: 1) // Outline color and width
                    )
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading){
                Text("使用者名稱")
                    .font(.system(size: 15, design: .default))
                TextField("  請輸入使用者名稱", text: $name)
                    .autocapitalization(.none)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5) // Matching the corner radius
                            .stroke(Color.gray, lineWidth: 1) // Outline color and width
                    )
            }
            .padding(.top, 10)
            
            Button {
                print("[SignUpView]: Tapped Create with email & passward")
                isProcess = true
                authManager.regularCreateAccount(email: email, password: password) { error in
                    if let error = error{
                        print("[SignUpView - regularCreateAccount]", error)
                        name = ""
                        phone = ""
                        email = ""
                        password = ""
                    }
                    else{
                        userModel.update_userInfo(name: name, email: email, phone: phone)
                    }
                    isProcess = false
                }
            } label: {
                Text("註冊")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity) // Stretch to fill the container's width
                    .frame(height: 40)
                    .background(isProcess ? CafeColor.basicColor_fade : CafeColor.basicColor)
                    .cornerRadius(5)
            }
            .padding(.top, 30)
            .disabled(isProcess)
        }
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            SignUpView()
        }
    }

    return Preview()
        .environmentObject(AuthManager())
        .environment(UserModel())
}
