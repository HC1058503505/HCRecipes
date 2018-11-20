//
//  RecipesHomeViewController.swift
//  HCRecipes
//
//  Created by cgtn on 2018/11/20.
//  Copyright © 2018 cgtn. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class RecipesHomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var recipeModels = [RecipeModel]()
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        let tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.rowHeight = 120
        view.addSubview(tableView)

        
        let searchResultVC = RecipesMeViewController()
        let searchVC = UISearchController(searchResultsController: searchResultVC)
        definesPresentationContext = true
        searchVC.searchBar.placeholder = "请输入搜索内容"
        searchVC.searchBar.barTintColor = UIColor.white
        searchVC.searchResultsUpdater = self
        searchVC.delegate = self
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = true

        
        var tableViewOriginOffsetY = tableView.contentOffset.y
        var tableViewContensize = tableView.contentSize
        
        MoyaHTTP.searchRecipes(keywords: "家常菜", page: page)
            .subscribe(onNext: {[weak self] (recipes) in
                self?.recipeModels.append(contentsOf: recipes)
                tableView.reloadData()
                tableViewOriginOffsetY = tableView.contentOffset.y 
                tableViewContensize = tableView.contentSize 
                self!.page = self!.page + 1
            })
            .disposed(by: disposeBag)
        
        var isPullUpToRefresh = false
        var isPullDownToRefresh = false
        let tableViewH = tableView.frame.height
        
        tableView.rx.willEndDragging.asObservable()
            .subscribe(onNext: { (_, _) in
                let offsetY = tableView.contentOffset.y
                isPullUpToRefresh = offsetY + tableViewH >= (tableViewContensize.height - 127)
                isPullDownToRefresh = offsetY <= tableViewOriginOffsetY
                
            })
            .disposed(by: disposeBag)
        
        
        tableView.rx.didEndDecelerating.asObservable()
            .subscribe(onNext: { _ in
                if isPullUpToRefresh {
                    print("上拉加载")
                    MoyaHTTP.searchRecipes(keywords: "家常菜", page: self.page)
                        .subscribe(onNext: {[weak self] (recipes) in
                            self?.recipeModels.append(contentsOf: recipes)
                            tableView.reloadData()
                            tableViewOriginOffsetY = tableView.contentOffset.y
                            tableViewContensize = tableView.contentSize
                            self!.page = self!.page + 1
                        })
                        .disposed(by: self.disposeBag)
                }
                
                if isPullDownToRefresh {
                    print("下拉刷新")
                    self.page = 0
                    MoyaHTTP.searchRecipes(keywords: "家常菜", page: self.page)
                        .subscribe(onNext: {[weak self] (recipes) in
                            self?.recipeModels = recipes
                            tableView.reloadData()
                            tableViewOriginOffsetY = tableView.contentOffset.y
                            tableViewContensize = tableView.contentSize
                            self!.page = self!.page + 1
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
    }

}

extension RecipesHomeViewController: UISearchResultsUpdating , UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension RecipesHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecipeTableViewCell.recipeTableViewCell(tableView: tableView, reuseIdentifier: "Cell")
        
        
        let recipe = recipeModels[indexPath.row]
        cell.confitureCell(recipeModel: recipe)
        return cell
    }

}
