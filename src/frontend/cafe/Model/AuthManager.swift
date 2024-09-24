//
//  GoogleAuthentication.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/9.
//
// reference: https://github.com/mdhsieh/sign-in-options-example

import Foundation
import FirebaseCore
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import GoogleSignIn


class AuthManager: NSObject, ASAuthorizationControllerDelegate, ObservableObject {
    @Published var signedIn:Bool = false
    @Published var idToken: String?
    @Published var notRequireAuth:Bool = false
    
    // Unhashed nonce.
    @Published var currentNonce: String?
    
    private var updateFuncList: [(String) -> Void] = []
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    override init() {
        super.init()
        
        self.authStateListenerHandle = Auth.auth().addStateDidChangeListener() { auth, user in
            if let user = user {
                self.signedIn = true
                print("[AuthModel]: ","Auth state changed, Login now")
                
                user.getIDToken { (idToken, error) in
                    if let error = error {
                        print("Error fetching ID token: \(error.localizedDescription)")
                    } else if let idToken = idToken {
                        // Use this ID token for authenticated API requests
                        print("[AuthManager] authStateListenerHandle got ID token")
                        self.idToken = idToken
                        self.update(idToken)
                    }
                }
                
            } else {
                self.signedIn = false
                print("[AuthModel]: ","Auth state changed, Loog out")
            }
        }
    }
    
    func get_authState(){
        if let user = Auth.auth().currentUser {
            self.signedIn = true
            print("[AuthModel - get_userstate]: ","Auth state changed, Login now")
            
            user.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("[AuthModel - get_userstate]: getIDToken error")
                } else if let idToken = idToken {
                    print("[AuthModel - get_userstate]: getIDToken successfully")
                    self.idToken = idToken
                    self.update(idToken)
                } else {
                    print("[AuthModel - get_userstate]: getIDToken successfully but now idToken")
                }
            }
        }
    }
    
    func set(_ function: @escaping (String) -> Void) {
        updateFuncList.append(function)
    }
    
    func update(_ idToken: String) {
        for function in updateFuncList {
            function(idToken) // Call the function with the provided parameter
        }
    }

    
    // [firebase] - Password Account
    func regularCreateAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print("[AuthModel]: ",e.localizedDescription)
                
            } else {
                print("[AuthModel]: ","Successfully created password account")
            }
        }
    }
    
    
    // [firebase] - Traditional sign in with password and email
    func regularSignIn(email:String, password:String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let e = error {
                completion(e)
                print("[AuthModel]: ","regularSignIn error")
            } else {
                print("[AuthModel]: ","Login success")
                completion(nil)
            }
        }
    }
    
    // Regular password acount sign out
    func regularSignOut(completion: @escaping (Error?) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(nil)
        } catch let signOutError as NSError {
          print("[AuthModel]: ","Error signing out: %@", signOutError)
          completion(signOutError)
        }
    }
    
    
    // [apple] ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // [firebase] - Apple sign in
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
                "[AuthModel]: Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    // Single-sign-on with Apple
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
       
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("[AuthModel]: Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("[AuthModel]: ","Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("[AuthModel]: ","Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print("[AuthModel]: ",error?.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                print("[AuthModel]: ","Apple sign in!")
                
                // Allow proceed to next screen
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    

    // [google] ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // As you’re not using view controllers to retrieve the presentingViewController, access it through
        // the shared instance of the UIApplication
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
            if let error = error {
                print("Error doing Google Sign-In, \(error)")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                return
            }


            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: user.accessToken.tokenString)
            
            
            // Authenticate with Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                }
               
                print("Signed in with Google")
            }
        }
    }
 
    
    // Sign out if used Single-sign-on with Google
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
        print("Google sign out")
    }
    
}
