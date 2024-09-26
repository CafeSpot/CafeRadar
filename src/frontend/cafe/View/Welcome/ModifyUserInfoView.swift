//
//  ModifyUserInfoView.swift
//  cafe
//
//  Created by henry on 2024/9/24.
//

import SwiftUI

struct ModifyUserInfoView: View {
    @Environment(UserModel.self) private var userModel
    @Binding var isShowingSheet: Bool
    @Binding var isModifiedSuccessfully: Bool
    @State var name: String
    @State var email: String
    @State var phone: String
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("name")
                    TextField("name", text: $name)
                }
                HStack{
                    Text("email")
                    TextField("email", text: $email)
                }
                HStack{
                    Text("phone")
                    TextField("phone", text: $phone)
                }
            }
            Spacer()
            HStack{
                Button(action: {
                    isShowingSheet = false
                }) {
                    Text("取消")
                }
                
                Button(action: {
                    userModel.update_userInfo(name: name, email: email, phone: phone)
                    isModifiedSuccessfully = true
                    isShowingSheet = false
                }) {
                    Text("更改")
                }
            }
        }
    }
}
/*
#Preview {
    @State var isShowingSheet = false
    @State var isModifiedSuccessfully = false
    
    ModifyUserInfoView(isShowingSheet: $isShowingSheet, isModifiedSuccessfully: $isModifiedSuccessfully, name: "henry", email: "henry19971010@yahoo.com.tw", phone: "0978592955")
        .environment(UserModel())
}
 */
