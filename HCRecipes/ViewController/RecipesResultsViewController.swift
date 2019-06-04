//
//  RecipesResultsViewController.swift
//  HCRecipes
//
//  Created by 侯聪 on 2019/6/4.
//  Copyright © 2019 cgtn. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
class RecipesResultsViewController: UIViewController {

    let subject = PublishSubject<String>()
    fileprivate var recipeModels = [RecipeModel]()
    fileprivate var page = 0
    fileprivate let disposeBag = DisposeBag()
    fileprivate  var searchKey = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = UIColor.orange
        tableView.dataSource = self
        tableView.rowHeight = 120.0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        var tableViewOriginOffsetY = tableView.contentOffset.y
        var tableViewContensize = tableView.contentSize
        
        
        subject.asObserver()
            .subscribe(onNext: {[weak self] searchResult in
                self?.recipeModels.removeAll()
                self?.searchKey = searchResult
                self?.page = 0
                MoyaHTTP.searchRecipes(keywords: searchResult, page: self!.page)
                    .subscribe(onNext: { (recipes) in
                        self?.recipeModels.append(contentsOf: recipes)
                        tableView.reloadData()
                        tableViewOriginOffsetY = tableView.contentOffset.y
                        tableViewContensize = tableView.contentSize
                        self!.page = self!.page + 1
                    })
                    .disposed(by: self!.disposeBag)
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
                    debugPrint("上拉加载")
                    MoyaHTTP.searchRecipes(keywords: self.searchKey, page: self.page)
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

}

extension RecipesResultsViewController: UITableViewDataSource {
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
