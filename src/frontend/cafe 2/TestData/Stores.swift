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
//let testStores: [Store] = [store1]

let store1 =  Store(
    cafeId: "1",
    cafename: "85 degree cafe",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 1,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 23, longitude: 23)),
    crowdRate: 1
)

let store2 =  Store(
    cafeId: "1",
    cafename: "starbas",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 2,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 24, longitude: 24)),
    crowdRate: 2
)

let store3 =  Store(
    cafeId: "1",
    cafename: "dfvr",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 25, longitude: 25)),
    crowdRate: 3
)


let store4 =  Store(
    cafeId: "1",
    cafename: "1",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 26, longitude: 26)),
    crowdRate: 2
)

let store5 =  Store(
    cafeId: "1",
    cafename: "1",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 27, longitude: 27)),
    crowdRate: 3
)

let store6 =  Store(
    cafeId: "1",
    cafename: "1",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 28, longitude: 28)),
    crowdRate: 3
)

let store7 =  Store(
    cafeId: "1",
    cafename: "1",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 29, longitude: 29)),
    crowdRate: 3
)

let store8 =  Store(
    cafeId: "1",
    cafename: "1",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 30, longitude: 30)),
    crowdRate: 3
)


let store9 =  Store(
    cafeId: "1",
    cafename: "1",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 31, longitude: 31)),
    crowdRate: 3
)

let store10 =  Store(
    cafeId: "1",
    cafename: "1",
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
        Idtag("空位"),
        Idtag("插座"),
        Idtag("不限時"),
        Idtag("讀書"),
        Idtag("供應正餐"),
        Idtag("音樂"),
        Idtag("戶外")],
    commentIds: [
        "好吃",
        "超派",
        "動手動腳"],
    envRating: 3,
    spaceScore: 3,
    lightScore: 3,
    plugNum: 4,
    placeId: "1223",
    distance: 200,
    marker: GMSMarker(position: CLLocationCoordinate2D(latitude: 32, longitude: 32)),
    crowdRate: 3
)
