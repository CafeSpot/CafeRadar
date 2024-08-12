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
    @Environment(AuthModel.self) private var authModel
    @State private var showLoginPage = false

    var body: some View {
        ZStack{
            VStack{
                Spacer() 
                
                /*
                Image(systemName: "cup.and.saucer.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90)
                    .foregroundColor(CafeColor.basicColor)
                Text("Coffee Spotter")
                    .font(.system(size: 27))
                    .fontWeight(.bold)
                    .foregroundColor(CafeColor.basicColor)
                */
                ZStack(){
                    Image("logo_final")
                        .resizable()
                        .frame(width: logoSize, height: logoSize)
                    LogoView()
                }
                
                Spacer()
                
                VStack(){
                    Button(action: {
                        showLoginPage = true
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showLoginPage) {
                        LoginView()
                    }
                    
                    Text("or")
                        .font(.system(size: 15))
                    
                    Button {
                        print("[WelcomeView] Just visit")
                        authModel.notRequireAuth = true
                    } label: {
                        Text("Just visit")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CafeColor.basicColor_background)
        .ignoresSafeArea()
    }
}


#Preview {
    WelcomeView()
        .environment(AuthModel())
}

