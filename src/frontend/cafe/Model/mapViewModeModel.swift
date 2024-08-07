//
//  mapViewModeModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/2.
//

//mapViewModeModel
import Foundation


enum Mode{
    case large
    case small
    case close
}

enum IfSearchTypeOpt{
    case choose
    case unchoose
}

@Observable
class MapViewModeModel{
    //list mode
    var mode: Mode
    var searchtypeCount: Int
    var searchTextCount: Bool
    
    init() {
        self.mode = .close
        self.searchtypeCount = 0
        self.searchTextCount = false
    }
    
    func dragGestureModel(varyAmount: CGFloat){
        if self.mode == .large{
            if varyAmount<420{
                self.mode = .small
            }else{
                self.mode = .close
            }
        }else if self.mode == .small{
            if varyAmount<0{
                self.mode = .large
            }else if varyAmount>0{
                self.mode = .close
            }
        }else{
            if varyAmount>(-300){
                self.mode = .small
            }else{
                self.mode = .large
            }
        }
    }
    
    func ifSearchText(searchText: String){
        if searchText == ""{
            searchTextCount = false
            if searchtypeCount == 0{
                self.mode = .small
            }
        }else{
            self.mode = .large
            searchTextCount = true
        }
    }
    
    func large(){mode = .large}
    func small(){mode = .small}
    func close(){mode = .close}
}
