//
//  SignUpView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/15.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authModel : AuthModel
    @Binding var email: String
    @Binding var password: String
    @Binding var phone: String
    @Binding var username: String
    
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
                SecureField("  請輸入手機號碼", text: $phone)
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
                SecureField("  請輸入使用者名稱", text: $username)
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
                authModel.regularCreateAccount(email: email, password: password)
            } label: {
                Text("註冊")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity) // Stretch to fill the container's width
                    .frame(height: 40)
                    .background(CafeColor.basicColor)
                    .cornerRadius(5)
            }
            .padding(.top, 30)
        }
    }
}

#Preview {
    struct Preview: View {
        @State var email: String = ""
        @State var password: String = ""
        @State var phone: String = ""
        @State var username: String = ""
        var body: some View {
            SignUpView(email: $email, password: $password, phone: $phone, username: $username)
        }
    }

    return Preview()
        .environmentObject(AuthModel())
}
