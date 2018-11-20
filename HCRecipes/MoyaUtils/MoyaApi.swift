//
//  MoyaApi.swift
//  HCRecipes
//
//  Created by cgtn on 2018/11/19.
//  Copyright © 2018 cgtn. All rights reserved.
//

import Foundation
import Moya
enum MoyaApi {
    case recipes(keywords: String, page: Int)
    case threeMeals(type: Int, page: Int)
    case recommendWeek(page: Int)
}

extension MoyaApi: TargetType{
    var baseURL: URL {
        return URL(string: "https://apiios.xiangha.com")!
    }
    
    var path: String {
        switch self {
            case .recipes:
                return "/main6/search/byCaipu"
            case .threeMeals:
                return "/main7/recommend/recommend"
            case .recommendWeek:
                return "main7/recommend/recommend"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self {
            case let .recipes(keywords, page):
                return .requestParameters(parameters: ["keywords" : keywords, "page" : page, "type" : "caipu"], encoding: URLEncoding.default)
            case let .threeMeals(type, page):
                return .requestParameters(parameters: ["mark":"", "resset_time":"", "type":"day", "two_type" : type, "page":page, "tpl":"1"], encoding: URLEncoding.default)
            case let .recommendWeek(page):
                return .requestParameters(parameters: ["mark":"", "resset_time":"", "type":"dish", "two_type" : "", "page":page, "tpl":"2"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
}


extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
