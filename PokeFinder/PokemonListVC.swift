//
//  PokemonListVC.swift
//  PokeFinder
//
//  Created by Mohammad Hemani on 4/30/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit

class PokemonListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    var pokemonSelected: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        navigationController?.delegate = self
        
        //parsePokemonCSV()
        filteredPokemons = pokemons
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pokemonSelected = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            cell.configureCell(pokemon: filteredPokemons[indexPath.row])
            return cell
            
        } else {
            return PokeCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPokemons.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let lower = searchBar.text?.lowercased(), lower != "" {
            
            inSearchMode = true
            
            filteredPokemons = pokemons.filter({ (pokemon) -> Bool in
                return pokemon.name.range(of: lower) != nil
            })
            
        } else {
            
            inSearchMode = false
            filteredPokemons = pokemons
            
        }
        
        collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pokemonSelected = filteredPokemons[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ViewController {
            vc.pokemonSelected = pokemonSelected
        }
    }
}
