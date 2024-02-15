# CafeRadar - frontend
1. before run this ios app in xcode, please run "pod install" to install package  
NOTE: pod is command of "cocoapods"  
(macos14 - install cocoapods:  
    sudo gem install drb -v 2.0.5   
    sudo gem install activesupport -v 6.1.7.6   
    sudo gem install cocoapods -v 1.13.0   
)  
2. open the file "cafe.xcworkspace" (open the project in xcode)  
3. choose the "simulator" to run the app  

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
