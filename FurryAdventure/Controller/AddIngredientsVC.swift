//
//  AddIngredientsVC.swift
//  FurryAdventure
//
//  Created by Sang Saephan on 3/20/17.
//  Copyright © 2017 Sticky Gerbils. All rights reserved.
//

import UIKit

class AddIngredientsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addIngLine: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!

    
    
    var categories = ["Vegetables", "Fruits", "Meat", "Dairy", "Grains and Carbs", "Herbs and Spices"]
    var images = [UIImage(named: "vegetables"), UIImage(named: "fruits"), UIImage(named: "meat"), UIImage(named: "dairy"), UIImage(named: "grains_and_carbs"), UIImage(named: "herbs_and_spices")]
    
    var ingredients = [vegetables, fruits, meat, dairy, grainsAndCarbs, herbsAndSpices, fish, oil, seafood, sweeteners, seasonings, nuts, condiments, dessertsAndSnacks, beverages, soup, dairyAlternatives, legumes, sauces, alcohol].joined(separator: []).map{$0}
    var filteredIngredients = [vegetables, fruits, meat, dairy, grainsAndCarbs, herbsAndSpices, fish, oil, seafood, sweeteners, seasonings, nuts, condiments, dessertsAndSnacks, beverages, soup, dairyAlternatives, legumes, sauces, alcohol].joined(separator: []).map{$0}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddIngredientCell", for: indexPath) as! AddIngredientsCollectionCell
        
        cell.nameLabel.text = categories[indexPath.row]
        cell.posterImageView.image = images[indexPath.row]
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            tableView.isHidden = true
            collectionView.isHidden = false
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
        }
        
        filteredIngredients = searchText.isEmpty ? ingredients.sorted() : ingredients.sorted().filter({
            $0.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        collectionView.alpha = 0.5
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        
        tableView.isHidden = true
        collectionView.isHidden = false
        collectionView.alpha = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchIngredientCell", for: indexPath)
        cell.textLabel?.text = filteredIngredients[indexPath.row].capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cart.append(filteredIngredients[indexPath.row])
        
        let alertController = UIAlertController(title: "Added Ingredient:", message:
            "\(filteredIngredients[indexPath.row].capitalized)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass ingredients into selected category
        if segue.identifier == "CategoryViewSegue" {
            let cell = sender as! AddIngredientsCollectionCell
            let indexPath = collectionView.indexPath(for: cell)
            
            let title = cell.nameLabel.text
            
            let navigationController = segue.destination as! UINavigationController
            let detailViewController = navigationController.topViewController as! CategoryVC
            
            detailViewController.navigationController?.navigationBar.topItem?.title = title
            
            if indexPath?.row == 0 {
                detailViewController.categoryIngredients = vegetables.sorted()
            } else if indexPath?.row == 1 {
                detailViewController.categoryIngredients = fruits.sorted()
            } else if indexPath?.row == 2 {
                detailViewController.categoryIngredients = meat.sorted()
            } else if indexPath?.row == 3 {
                detailViewController.categoryIngredients = dairy.sorted()
            } else if indexPath?.row == 4 {
                detailViewController.categoryIngredients = grainsAndCarbs.sorted()
            } else if indexPath?.row == 5 {
                detailViewController.categoryIngredients = herbsAndSpices.sorted()
            }
        }
    }

}
