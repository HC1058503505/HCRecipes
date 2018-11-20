//
//  ViewController.swift
//  HCRecipes
//
//  Created by cgtn on 2018/11/19.
//  Copyright © 2018 cgtn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    var recipeModels = [RecipeModel]()
    var page = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.rowHeight = 120
        
    }
}

extension ViewController: UITableViewDataSource {
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
