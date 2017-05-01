//
//  PokeCell.swift
//  PokeFinder
//
//  Created by Mohammad Hemani on 4/30/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        pokemonNameLabel.text = self.pokemon.name.capitalized
        pokemonImageView.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
}
