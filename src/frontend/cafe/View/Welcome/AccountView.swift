//
//  LoginView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/10.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authModel : AuthManager
    @Environment(\.presentationMode) var presentationMode
    
    @State var email: String = ""
    @State var password: String = ""
    @State var phone: String = ""
    @State var username: String = ""
    
    @State private var isLogin: Bool = true
    
    
    var body: some View {
        VStack(){
            Image("logo_account")
                .resizable()
                .frame(width: 260, height: 260)
            
            VStack(){
                Toggle(isOn: $isLogin){
                }.toggleStyle(CheckboxToggleStyle_Login_SignIn())
                    //.padding()
                
                if isLogin{
                    LoginView(email: $email, password: $password)
                }
                else{
                    SignUpView(email: $email, password: $password, phone: $phone, username: $username)
                }
                
                Button {
                    print("[AccountView]: Just visit")
                    authModel.notRequireAuth = true
                } label: {
                    Text("Just visit")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 15, design: .default))
                }
                .padding(.top, 30)
            }
            .frame(width: 330)
            
            Spacer()
            
        }
    }
}
    
struct CheckboxToggleStyle_Login_SignIn: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            Button(action: {
                configuration.isOn = true
            }) {
                Text("登入")
                    .frame(maxWidth: .infinity) // Stretch to fill the container's width
                    .frame(height: 25)
                    .background(configuration.isOn ? Color.white : Color.clear)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(configuration.isOn ? Color.black : Color.clear, lineWidth: 0.1)
                    )
            }
            .buttonStyle(PlainButtonStyle()) // Remove the default button styling
            
            Button(action: {
                configuration.isOn = false
            }) {
                Text("註冊")
                    .frame(maxWidth: .infinity) // Stretch to fill the container's width
                    .frame(height: 25)
                    .background(configuration.isOn ? Color.clear : Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(configuration.isOn ? Color.clear : Color.black, lineWidth: 0.1)
                    )
            }
            .buttonStyle(PlainButtonStyle()) // Remove the default button styling
        }
        .background(Color(.systemGray6))
        .cornerRadius(7)
    }
}
#Preview {
    AccountView()
        .environmentObject(AuthManager())
}
