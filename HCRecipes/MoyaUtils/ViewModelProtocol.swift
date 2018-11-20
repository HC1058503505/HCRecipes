//
//  ViewModelProtocol.swift
//  HCRecipes
//
//  Created by cgtn on 2018/11/19.
//  Copyright © 2018 cgtn. All rights reserved.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}


protocol ViewModelWithSubjects {
    associatedtype Input
    associatedtype Output
    
    var input: Input {get}
    var output: Output {get}
}
