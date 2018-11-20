//
//  RecipeTabBarViewController.swift
//  HCRecipes
//
//  Created by cgtn on 2018/11/20.
//  Copyright © 2018 cgtn. All rights reserved.
//

import UIKit

class RecipesTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        let homeVC = RecipesHomeViewController()
        addChildVC(childVC: homeVC, imageName: "home", title: "首页")
        
        let categoryVC = RecipesCategoryViewController()
        addChildVC(childVC: categoryVC, imageName: "fenlei", title: "分类")
        
        
        let meVC = RecipesMeViewController()
        addChildVC(childVC: meVC, imageName: "me", title: "我")
    }
    
    func addChildVC(childVC: UIViewController, imageName: String , title: String) {
        
        let childVCNav = RecipesNavigationController(rootViewController: childVC)
        childVC.title = title
        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 222.0 / 255.0, green: 99.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)], for: UIControl.State.selected)
        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)], for: UIControl.State.normal)
        childVC.tabBarItem.selectedImage = UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        childVC.tabBarItem.image = UIImage(named: "\(imageName)_normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        addChild(childVCNav)
    }
}
