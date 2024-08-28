//
//  Stores.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import Foundation
import SwiftUI
import GoogleMaps
import CoreLocation

let testStores: [Store] = [store1, store2 ,store3 ,store4 ,store5 ,store6 ,store7 ,store8 ,store9 ,store10]
let testRecommends: [Recommend] = [Recommend(title: "貓店長值班",storeIDs: [1,2,3,4]),
                                  Recommend(title: "好氣份好心情",storeIDs: [4,5,6,7]),
                                  Recommend(title: "網友高分推薦",storeIDs: [8,9,10])]
let testTypeNames: [String] = [
    "插座",
    "不限時",
    "讀書",
    "供應正餐",
    "音樂",
    "戶外",
    "插座",
    "不限時",
    "讀書",
    "供應正餐",
    "音樂",
    "戶外"]

let store1 =  Store(
    cafeId: 1,
    name: "85 degree cafe",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 23,
    lat: 23,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 1,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 1
)

let store2 =  Store(
    cafeId: 2,
    name: "starbas",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 23.5,
    lat: 23.5,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 2,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 2
)

let store3 =  Store(
    cafeId: 3,
    name: "3",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 24,
    lat: 24,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 3
)


let store4 =  Store(
    cafeId: 4,
    name: "4",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 24.5,
    lat: 24.5,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 2
)

let store5 =  Store(
    cafeId: 5,
    name: "5",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 25,
    lat: 25,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 3
)

let store6 =  Store(
    cafeId: 6,
    name: "6",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 25.5,
    lat: 25.5,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 3
)

let store7 =  Store(
    cafeId: 7,
    name: "7",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 26,
    lat: 26,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 3
)

let store8 =  Store(
    cafeId: 8,
    name: "8",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 26.5,
    lat: 26.5,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 3
)


let store9 =  Store(
    cafeId: 9,
    name: "9",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 27,
    lat: 27,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 3
)

let store10 =  Store(
    cafeId: 10,
    name: "10",
    openTime: "8:00",
    closeTime: "18:00",
    seatNum: 50,
    images: [
        IdImage(Image("cafe1")),
        IdImage(Image("cafe2")),
        IdImage(Image("cafe3")),
        IdImage(Image("cafe4")),
        IdImage(Image("cafe5")),
        IdImage(Image("cafe6"))],
    tags: [
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外"
        true, //"插座"
        true, //"不限時"
        true, //"讀書"
        true, //"供應正餐"
        true, //"音樂"
        true, //"戶外" ]
        ],
    lon: 27.5,
    lat: 27.5,
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    place_id: "1223",
    distance: 200,
    crowdRate: 3
)

