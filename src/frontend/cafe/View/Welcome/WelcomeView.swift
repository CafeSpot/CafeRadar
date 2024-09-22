//
//  WelcomeView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/8.
//

import SwiftUI
import FirebaseAuth
//import GoogleSignIn

struct WelcomeView: View {
    @EnvironmentObject var authModel : AuthManager
    @State private var showLoginPage = false
    @State private var ifLogining = true

    var body: some View {
        if ifLogining{
            LogoView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        ifLogining = false
                    }
                }
        }
        else{
            AccountView()
        }
    }
}


#Preview {
    WelcomeView()
        .environmentObject(AuthManager())
}
