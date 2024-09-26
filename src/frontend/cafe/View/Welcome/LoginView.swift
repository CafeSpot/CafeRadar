//
//  LoginView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authModel : AuthManager
    @State var email: String = ""
    @State var password: String = ""
    @State private var loginMessage: String = ""
    
    @State private var isChecked = false
    @State var isProcess: Bool = false
    
    var body: some View {
        VStack(){
            VStack(alignment: .leading){
                Text("Email")
                    .font(.system(size: 15, design: .default))
                    .fontWeight(.bold)
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
                    .fontWeight(.bold)
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
            
            HStack(){
                Toggle(isOn: $isChecked){
                    Text("記住帳號密碼")
                        .font(.system(size: 12, design: .default))
                        .foregroundColor(.gray)
                }.toggleStyle(CheckboxToggleStyle())
                
                Spacer()
                
                Button{} label: {
                    Text("忘記帳號密碼? ")
                        .font(.system(size: 12, design: .default))
                        .foregroundColor(CafeColor.basicColor_background)
                        .fontWeight(.bold)
                }

            }
            .padding(10)
            
            Button {
                isProcess = true
                print("[LoginView]: Sign in with email & passward")
                authModel.regularSignIn(email: email, password: password) { error in
                    if let e = error {
                        print("[LoginView]: Sign in with email & passward ~~ ",e.localizedDescription)
                        loginMessage = e.localizedDescription
                    }
                    else{
                        loginMessage = ""
                        print("[LoginView]: login")
                    }
                    isProcess = false
                }
            } label: {
                Text("登入")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity) // Stretch to fill the container's width
                    .frame(height: 40)
                    .background(isProcess ? CafeColor.basicColor_fade : CafeColor.basicColor)
                    .cornerRadius(5)
            }
            .padding(.top, 20)
            .disabled(isProcess)
            
            LabelledDivider(label: "或以其他方式登入")
                .padding(.top,30)
            
            
            HStack(alignment: .center, spacing: 50){
                // sign in with google account
                Button {
                    print("[LoginView]: Tapped google sign in")
                    authModel.googleSignIn()
                    loginMessage = ""
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50) // Set the desired circle size
                            .foregroundColor(.clear) // Make the circle itself transparent if you only want the border
                        
                        Image("google")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45) // Adjust this to fit inside the circle without distorting the aspect ratio
                            .clipShape(Circle()) // Clip the image into a circular shape
                    }
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                
                // sign in with apple account
                Button {
                    print("[LoginView]: Sign in with Apple")
                    //authModel.authorizationController()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50) // Set the desired circle size
                            .foregroundColor(.clear) // Make the circle itself transparent if you only want the border
                        
                        Image("apple")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45) // Adjust this to fit inside the circle without distorting the aspect ratio
                            .clipShape(Circle()) // Clip the image into a circular shape
                    }
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                
                // sign in with facebook account
                Button {
                    print("[LoginView]: Sign in with Apple")
                    //authModel.authorizationController()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50) // Set the desired circle size
                            .foregroundColor(.clear) // Make the circle itself transparent if you only want the border
                        
                        Image("facebook")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50) // Adjust this to fit inside the circle without distorting the aspect ratio
                            .clipShape(Circle()) // Clip the image into a circular shape
                    }
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            }
            .padding(.top, 15)
        
        }
    }
}


// reference: https://stackoverflow.com/questions/56619043/show-line-separator-view-in-swiftui
struct LabelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color
    let fontSize: CGFloat

    init(label: String, horizontalPadding: CGFloat = 10, color: Color = .black, fontSize: CGFloat = 12) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
        self.fontSize = fontSize
    }

    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
                .font(.system(size: fontSize, design: .default))
                .fontWeight(.heavy)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(configuration.isOn ? .black : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
        }
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            LoginView()
        }
    }

    return Preview()
        .environmentObject(AuthManager())
}

