//
//  RecipesDetailViewController.swift
//  HCRecipes
//
//  Created by cgtn on 2019/6/6.
//  Copyright © 2019 cgtn. All rights reserved.
//

import UIKit
import RxSwift
class RecipesDetailViewController: UIViewController {
    
    
    fileprivate let disposeBag = DisposeBag()
    var recipe = RecipeModel() {
        // willSet
        willSet {
            navigationItem.title = newValue.name
            recipeImg.kf.setImage(with: URL(string: newValue.img))
            recipeBurdens.text = newValue.burdens
            recipeScan.text = "浏览量：\(newValue.allClick)"
            recipeFavorites.text = "收藏量：\(newValue.favorites)"
            debugPrint(newValue.name)
        }
        // didSet
        didSet {
            
        }
    }
    
    fileprivate let recipeImg = UIImageView()
    fileprivate let recipeName = UILabel()
    fileprivate let recipeBurdens = UILabel()
    fileprivate let recipeScan = UILabel()
    fileprivate let recipeFavorites = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        view.addSubview(recipeImg)
        
        recipeBurdens.textColor = UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 142.0 / 255.0, alpha: 0.65)
        recipeBurdens.numberOfLines = 0
        view.addSubview(recipeBurdens)
        view.addSubview(recipeScan)
        view.addSubview(recipeFavorites)
        navigationController?.navigationBar.isTranslucent = false
        recipeImg.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(recipeImg.snp.width).multipliedBy(9.0 / 16.0)
        }
        
        recipeBurdens.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(15)
            make.top.equalTo(recipeImg.snp.bottom).offset(5)
            make.right.equalTo(view.snp.right).offset(-15)
        }
        
        recipeScan.snp.makeConstraints { (make) in
            make.left.equalTo(recipeBurdens.snp.left)
            make.top.equalTo(recipeBurdens.snp.bottom).offset(5)
        }
        
        recipeFavorites.snp.makeConstraints { (make) in
            make.left.equalTo(recipeScan.snp.right).offset(25)
            make.centerY.equalTo(recipeScan.snp.centerY)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
