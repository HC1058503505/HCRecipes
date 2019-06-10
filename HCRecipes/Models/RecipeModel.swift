//
//  RecipeModel.swift
//  HCRecipes
//
//  Created by cgtn on 2018/11/19.
//  Copyright © 2018 cgtn. All rights reserved.
//

import Foundation


struct StatData: Codable {
    var type = ""
    var code = ""
}

struct RecipeVideoURL: Codable {
    var D270p = ""
    var D360p = ""
    var D480p = ""
    var D720p = ""
    var D1080p = ""
}

struct RecipeStyleData: Codable {
    var url = ""
    var type = ""
}

struct RecipeVideo: Codable {
    var duration = ""
    var url = ""
    var videoUrl = RecipeVideoURL()
}

struct RecommendRecipeVideo: Codable {
    var isAuto = ""
    var isVideo = ""
    var videoTime = ""
    var videoUrl = RecipeVideoURL()
}


struct RecipeModel: Codable {
    var code = 0
    var name = ""
    var img = ""
    var sizeImg = ""
    var burdens = ""
    var allClick = ""
    var favorites = ""
//    var exclusive = 0
//    var judgeId = 0
//    var hasVideo = ""
//    var isMakeImg = 0
//    var level = 0
//    var isFine = 0
//    var statData = StatData()
//    var statJson = ""
//    var isVip = 0
    init() {
        
    }
    init(recipe: [String : Any]) {
        code = recipe["code"] as? Int ?? 0
        name = recipe["name"] as? String ?? ""
        img = recipe["img"] as? String ?? ""
        sizeImg = recipe["sizeImg"] as? String ?? ""
        burdens = recipe["burdens"] as? String ?? ""
        let allScan = recipe["allClick"]
        if allScan is String {
            allClick = allScan as? String ?? ""
        } else {
            allClick = "\(allScan as? Int ?? 0)"
        }
        
        
        let fav = recipe["favorites"]
        if fav is String {
            favorites = fav as? String ?? ""
        } else {
            favorites = "\(fav as? Int ?? 0)"
        }
    }
}

struct RecommendMeals : Codable {
    var code = ""
    var mark = ""
    var name = ""
    var commentNum = ""
    var isLike = ""
    var isFavorites = ""
    var favorites = 0
    var allClick = ""
    var likeNum = ""
    var content = ""
    var img = ""
    var url = ""
    var imgs = [String]()
    var isSole = ""
    var type = 0
    var isVip = ""
    var style = ""
    var styleData = [RecipeStyleData]()
    var numInfo = [String]()
    
}



