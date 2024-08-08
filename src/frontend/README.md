# CafeRadar - frontend
1. before run this ios app in xcode, please run "pod install" to install package  
NOTE: pod is command of "cocoapods"  
(macos14 - install cocoapods:  
    sudo gem install drb -v 2.0.5   
    sudo gem install activesupport -v 6.1.7.6   
    sudo gem install cocoapods -v 1.13.0   
)  
2. add the api\_key for google map service (follow the record on 2024/8/6)
3. open the file "cafe.xcworkspace" (open the project in xcode)  
4. choose the "simulator" to run the app  

[component]
1. 

[update record]  
v0.0  
1. add the gps info (latitude and longitude) to the userModel.  
2. make the marker on the google map view which can navigate to storeDetailInfo after tap it  

v0.1  
1. modify the color, size and arrangment to the UI requirement  
2. modify the searchbar - add delete searchtext button  
3. modify the simpleInfoList - add the different top rectangle type in 3 different mode   

v0.2  
1. move the gps system from userModel to storeModel(send the nearby request to get the store info and save in storeModel)  
2. googleMapView add current position and camera at this postion  
  
v0.3  
1. add the api request procedure to the StoreModel(not integrate)  
googmap api reference:  
1-1. place type(web-old): https://developers.google.com/maps/documentation/places/web-service/supported_types  
1-2. place type(web-new): https://developers.google.com/maps/documentation/places/web-service/place-types  
2. nearby search api: https://developers.google.com/maps/documentation/places/web-service/search-nearby
3. basic response field(ios): https://developers.google.com/maps/documentation/places/ios-sdk/place-data-fields  
4. defined the response field: https://developers.google.com/maps/documentation/places/web-service/choose-fields  
5-1. tutorial: https://medium.com/彼得潘的-swift-ios-app-開發教室/ios-20-使用googlemaps第三方api製作簡易版地圖app-aae9ec46e6bf

v0.4
1. add the structure convert from google map api response to the 'struct-googleInfo"(which is the sub-item in the struct-store). and it will add all the cafe to the buffer in storeModel  
Note: to use the google map api, plesae add your api key to "CafeApp-GMSServices.provideAPIKey()" and "requestURL ="httprequest...&key=" "

v0.5
1. add autoArrangeLayout for type item in storeDetailInfo
2. finish the searchbar function wihch can filt the reprecent cafes and add the distance filter
3. move the selecType/Text/Distance(in MapView) and filterStore(in SimpleStoreInfoList) to the storeModel
reference:
1. custom layout:
    (1)apple develop document: https://developer.apple.com/documentation/swiftui/custom-layout
    (2)frame vs bounds: https://jjeremy-xue.medium.com/swift-說說-frame-bounds-ba9bc3fcad1c
    (3)tutorial: https://www.youtube.com/watch?v=du_Bl7Br9DM&t=10s
    (4) do note!!!
2. Bindable - enable @obsevable/@enviroment object to bind in textField
    https://developer.apple.com/documentation/swiftui/bindable
    
    
2024/8/6
1. move GOOGLE_API_KEY to the configuration file "SecureAPIKeys/secrets" and add "SecureAPIKeys/secrets" to .gitignore . it prevents the api key update to github 
2. step:
    1. create the "group" under the project dict by "new group" with name "SecureAPIKeys"
    2. creat the configuration file under "SecureAPIKeys/" by "new file"->"configuration setting..."->"file name secrets"
    3. add the "GOOGLE_API_KEY = "AIzaSyA56wAlcA_gChuocEng24X_qi6OKIaaaaU" to the SecureAPIKeys/secrets
    4. add the "src/SecureAPIKeys/\*" to the .gitignore
    4. modfiy the api key in the api function in project code with "func("GOOGLE_API_KEY")"
    5. go to "project"->"porject/project_name"->"info(tab)"->"configuration"->under "reference" and "debug", modify the project\_name to secrets(configuration file)
    7. go to "project"->"project/target"->  add the new row with "GOOGLE_API_KEY | string | $(GOOGLE_API_KEY)"
    * reference: 
        * https://medium.com/@gizemturker/ensuring-security-for-secrets-in-ios-app-ff4a25c533a1
        * https://www.danijelavrzan.com/posts/2022/11/xcode-configuration/
        * https://blog.arturofm.com/untitled-2/
            * use ```(Bundle.main.infoDictionary?["GOOGLE_API_KEY"] as? String)!``` to fetch the env var
        
2024/8/7
1. add the file "src/frontend/cafe/appear/Color".
    * we can change the topic color of APP in this file directly
2. modify several appearance design to match the UI/UX design

2024/8/7
1. firebase
    1. firebase local emulator
        1. firebase Local Emulator install
            * reference: https://firebase.google.com/docs/emulator-suite/install_and_configure
            1. requirement:
                1. Node.js version 16.0 or higher.
                2. Java JDK version 11 or higher.
                * install
                    1. ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```
                    2. ```brew update```
                    3. ```brew install node```
                        * ```softwareupdate --install-rosetta```(modify the cpu arch from x86 to m1)
                        * verify nodejs: ```node -v```
                    4. ```brew install --cask temurin```
                        * verify java: ```java -version```
            2. install Firebase CLI. (under /src/frontend/)
                1. ```npm install -g firebase-tools```
                    * there is problem when you install Firebase CLI with ```curl -sL https://firebase.tools | bash``` for ui emulator (https://github.com/firebase/firebase-tools/issues/6931) 
                2. You will need CLI version 8.14.0 or higher to use the Emulator Suite. You can check which version you have installed using the following command: ```firebase --version```
                3. If you haven't already done so, initialize the current working directory as a Firebase project, following the onscreen prompts to specify which products to use
                    1. ```firebase login``` (login with your gmail on firebase)
                    2. ```firebase init```(under the directory of project)
                4. ```firebase init``` select the emulator->authentication Emulator
        2. use
            * reference: https://firebase.google.com/docs/emulator-suite/connect_auth#swift
            * reference: https://mayankchoudharydotcom.medium.com/firebase-offline-simplify-development-with-firebase-local-emulator-suite-ios-android-web-07c9b2fc860c
            1. run the Firebase emulator by using this command: ```firebase emulators:start```
            2. visit: http://127.0.0.1:port/auth to access our Firebase emulator UI
    2. SwiftUI app with firebase
        * reference: https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-firebase-實現-ios-app-的登入功能-cf1795ccec00
            * firebase api in SwiftUI
        * reference: https://mayankchoudharydotcom.medium.com/firebase-offline-simplify-development-with-firebase-local-emulator-suite-ios-android-web-07c9b2fc860c
            * SwiftUI + emulator
2. add the WelcomeView
    * test the firebase auth