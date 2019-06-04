//
//  MoyaHTTP.swift
//  HCRecipes
//
//  Created by cgtn on 2018/11/19.
//  Copyright © 2018 cgtn. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class MoyaHTTP  {
    static let MoyaProviderHTTP = MoyaProvider<MoyaApi>()
    
    
    
    static func searchRecipes(keywords:String , page: Int) -> Observable<[RecipeModel]> {
        
        return MoyaProviderHTTP.rx.request(.recipes(keywords: keywords, page: page)).asObservable()
                .mapJSON(failsOnEmptyData: true)
                .flatMap({ (result) -> Observable<[RecipeModel]> in
                    guard   let jsonResult = result as? [String : Any],
                            let dishesData = jsonResult["data"] as? [String : Any],
                            let dishes = dishesData["dishs"] as? [[String : Any]] else {
                                
                        return Observable<[RecipeModel]>.empty()
                    }
                    
                    let recipes = dishes.map {
                        RecipeModel.init(recipe: $0)
                    }
                    
                    return Observable<[RecipeModel]>.create({ (subscribe) -> Disposable in
                        subscribe.onNext(recipes)
                        return Disposables.create()
                    })
                })
        
    }
    
    static func recommendThreeMeals(type: Int , page: Int) -> Observable<[RecommendMeals]> {
        
        return MoyaProviderHTTP.rx.request(.threeMeals(type: type, page: page)).asObservable()
            .map([RecommendMeals].self, atKeyPath: "data.list", using: JSONDecoder(), failsOnEmptyData: true)
            .flatMap { (mealsModels) -> Observable<[RecommendMeals]> in
                
                return Observable<[RecommendMeals]>.create({ (observer) -> Disposable in
                    observer.onNext(mealsModels)
                    return Disposables.create()
                })
        }

    }
    
    static func recommendWeekendMeals(page: Int) -> Observable<[RecommendMeals]> {
        
        return MoyaProviderHTTP.rx.request(.recommendWeek(page: page)).asObservable()
            .map([RecommendMeals].self, atKeyPath: "data.list", using: JSONDecoder(), failsOnEmptyData: true)
            .flatMap { (mealsModels) -> Observable<[RecommendMeals]> in
                return Observable<[RecommendMeals]>.create({ (observer) -> Disposable in
                    observer.onNext(mealsModels)
                    return Disposables.create()
                })
        }
    }
}
