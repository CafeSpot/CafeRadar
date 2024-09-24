# CafeRadar backend server

## Running
### Enviroment
    1. install required pip package
        * ```pip install -r requirements.txt```
    2. set .env
        * add .env under ```/``` with the following content
            ```
                MONGODB_URL="mongodb+srv://spottercafe:xxx@userdata.tyciydx.mongodb.net/?retryWrites=true&w=majority"
            ```
    3. firebase firebaseAdminPrivateKey.json
        * following the steps in https://medium.com/@jonatanramhoj/firebase-admin-sdk-installation-guide-f64349d86a9d
        1. go to your firebase project
        2. project setting(right of "project overview") -> service account-> generate new private key, and there is .json file downloaded
        3. rename this .json to "firebaseAdminPrivateKey.json" and move the file to ```src/backend/secret/```(src/backend/secret/firebaseAdminPrivateKey.json)
### Running
    * ```uvicorn src.backend.main:app --reload```

## Develop
1. data format transmitted between backend and frontend
    ```
        cafeId*		id		string	// google address
        name*		名稱		string

        openTime	開店時間		string	//後端決定該日的營運時間
        closeTime 	關店時間		string	//後端決定該日的營運時間
        imageLinks*	照片		[string]
        tags*		tags		[string]
        lat*		緯度		double
        lon*		精度		double
        distance	距離		double
        commentIds*	評論		[string]
        envRate		環境評分		double
        spaceScore	空間大小評分	double
        lightScore	照明評分		double
        crowdRate	擁幾度		double
        plugNum		插座數量		int
        seatNum		座位數量 	int
        address		地址		string
        addressLink	地址連結(google)	string
        googleMapLink			string
        phone		聯絡電話		string
        link		website連結	string
        ig		ig帳號		string
        igLink		ig連結		string
        fb		fb帳號		string
        fbLink		fb連結		string

        ----[db only]-------------------
        location_geojson
        placeId
    ```
2. decoded_token format of firebase token 
    1. firebase account&password
        ```
            {'iss': 'https://securetoken.google.com/caferadar-17e3b', 
            'aud': 'caferadar-17e3b', 
            'auth_time': 1727018172, 
            'user_id': 'oAwq3hO2vghbR5pnjt6jjcMwAwL2', 
            'sub': 'oAwq3hO2vghbR5pnjt6jjcMwAwL2', 
            'iat': 1727036479, 
            'exp': 1727040079, 
            'email': 'henry19971010@gmail.com', 
            'email_verified': False, 
            'firebase': {'identities': {'email': ['henry19971010@gmail.com']}, 'sign_in_provider': 'password'}, 
            'uid': 'oAwq3hO2vghbR5pnjt6jjcMwAwL2'}
        ```