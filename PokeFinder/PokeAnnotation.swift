//
//  PokeAnnotation.swift
//  PokeFinder
//
//  Created by Mohammad Hemani on 4/29/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation
import MapKit

class PokeAnnotation: NSObject, MKAnnotation {
    
    private var _coordinate = CLLocationCoordinate2D()
    private var _pokemonNumber: Int
    private var _pokemonName: String
    private var _title: String?
    
    var coordinate: CLLocationCoordinate2D {
        return _coordinate
    }
    
    var pokemonNumber: Int {
        return _pokemonNumber
    }
    
    var title: String? {
        return _title
    }
    
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        
        self._coordinate = coordinate
        self._pokemonNumber = pokemon.pokedexId
        self._pokemonName = pokemon.name
        self._title = self._pokemonName
        
    }
    
}
