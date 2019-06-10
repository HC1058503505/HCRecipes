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
import SnapKit
class RecipesHomeViewController: UIViewController {
    
    fileprivate let errorBtn = UIButton(type: UIButton.ButtonType.custom)
    fileprivate let disposeBag = DisposeBag()
    fileprivate var recipeModels = [RecipeModel]()
    fileprivate var page = 0
    fileprivate let searchResultVC = RecipesResultsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "我的菜谱"
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        errorBtn.isHidden = true
        errorBtn.setTitleColor(UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 142.0 / 255.0, alpha: 0.65), for: UIControl.State.normal)
        errorBtn.setTitle("点击重试", for: UIControl.State.normal)
        view.addSubview(errorBtn)
        errorBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        errorBtn.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: { _ in

            })
            .disposed(by: disposeBag)
        
        
        
        
        
        let searchVC = UISearchController(searchResultsController: searchResultVC)
        definesPresentationContext = true
        searchVC.searchBar.placeholder = "请输入搜索内容"
        searchVC.searchBar.barTintColor = UIColor.white
        searchVC.searchBar.returnKeyType = .done
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = true
        searchVC.searchBar.rx.text.orEmpty
            .changed
            .distinctUntilChanged()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bind(to: searchResultVC.subject)
            .disposed(by: disposeBag)
        
        var tableViewOriginOffsetY = tableView.contentOffset.y
        var tableViewContensize = tableView.contentSize
        MoyaHTTP.searchRecipes(keywords: "家常菜", page: page)
            .subscribe(onNext: {[weak self] (recipes) in
                self?.recipeModels.append(contentsOf: recipes)
                tableView.reloadData()
                tableViewOriginOffsetY = tableView.contentOffset.y
                tableViewContensize = tableView.contentSize
                self!.page = self!.page + 1
            }, onError: { error in
                debugPrint(error.localizedDescription)
                tableView.isHidden = true
                self.errorBtn.isHidden = false
            }, onCompleted: {
                
            })
            .disposed(by: disposeBag)
        
//        MoyaHTTP.searchRecipes(keywords: "家常菜", page: page)
//            .subscribe(onNext: {[weak self] (recipes) in
//                self?.recipeModels.append(contentsOf: recipes)
//                tableView.reloadData()
//                tableViewOriginOffsetY = tableView.contentOffset.y
//                tableViewContensize = tableView.contentSize
//                self!.page = self!.page + 1
//            })
//            .disposed(by: disposeBag)
        
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
                    debugPrint("上拉加载")
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
                    debugPrint("下拉刷新")
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

extension RecipesHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecipeTableViewCell.recipeTableViewCell(tableView: tableView, reuseIdentifier: "Cell")
        
        
        let recipe = recipeModels[indexPath.row]
        cell.confitureCell(recipeModel: recipe)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipesVC = RecipesDetailViewController()
        recipesVC.recipe = recipeModels[indexPath.row]
        navigationController?.pushViewController(recipesVC, animated: true)
    }
}
