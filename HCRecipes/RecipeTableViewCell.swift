//
//  RecipeTableViewCell.swift
//  HCRecipes
//
//  Created by cgtn on 2018/11/19.
//  Copyright © 2018 cgtn. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class RecipeTableViewCell: UITableViewCell {
    
    fileprivate let recipeImg = UIImageView()
    fileprivate let recipeName = UILabel()
    fileprivate let recipeBurdens = UILabel()
    fileprivate let recipeScan = UILabel()
    fileprivate let recipeFavorites = UILabel()
    static func recipeTableViewCell(tableView:UITableView, reuseIdentifier:String) -> RecipeTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = RecipeTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! RecipeTableViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupFunc()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupFunc() {
        contentView.addSubview(recipeImg)
        contentView.addSubview(recipeName)
        
        recipeBurdens.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(recipeBurdens)
        
        recipeScan.font = UIFont.systemFont(ofSize: 12)
        recipeScan.textColor = UIColor.lightGray
        contentView.addSubview(recipeScan)
        
        recipeFavorites.textColor = UIColor.lightGray
        recipeFavorites.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(recipeFavorites)
        
        recipeImg.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.width.equalTo(127)
            
        }
        
        recipeName.snp.makeConstraints { (make) in
            make.left.equalTo(recipeImg.snp.right).offset(10)
            make.top.equalTo(recipeImg.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        recipeBurdens.snp.makeConstraints { (make) in
            make.centerY.equalTo(recipeImg.snp.centerY)
            make.left.equalTo(recipeImg.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        recipeScan.snp.makeConstraints { (make) in
            make.left.equalTo(recipeBurdens.snp.left)
            make.bottom.equalTo(recipeImg.snp.bottom)
        }
        
        recipeFavorites.snp.makeConstraints { (make) in
            make.left.equalTo(recipeScan.snp.right).offset(10)
            make.bottom.equalTo(recipeScan.snp.bottom)
            make.right.lessThanOrEqualTo(contentView.snp.right).offset(-10)
        }
        
    }
    func confitureCell(recipeModel: RecipeModel) {
        recipeImg.kf.setImage(with: URL(string: recipeModel.img))
        recipeName.text = recipeModel.name
        recipeBurdens.text = recipeModel.burdens
        recipeScan.text = "浏览量：\(recipeModel.allClick)"
        recipeFavorites.text = "收藏量：\(recipeModel.favorites)"
    }

}
