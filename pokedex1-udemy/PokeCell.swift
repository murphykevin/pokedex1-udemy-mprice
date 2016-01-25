//
//  PokeCell.swift
//  pokedex1-udemy
//
//  Created by Kevin Murphy on 1/14/16.
//  Copyright © 2016 Caravel. All rights reserved.
//

import UIKit

//what do we need? well we know that every pokemon has an image and a label so we definitely need those
class PokeCell: UICollectionViewCell {

    @IBOutlet weak var pokeThumbnailImg: UIImageView!
    @IBOutlet weak var pokeNameLbl: UILabel!
    //
    //what else do we need? need to store a pokemon object so that whenever a new cell is created we have an actual class to hold the data 
    
    var pokemon: Pokemon! //store the pokemon object received from the functions called below
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 15.0 //MP uses 5.0 I like 15.0 a lot
        // self.clipsToBounds = true   //wasn't needed prob based on image fill/fit selection
    }
    
    //need a way to assign these things in the future:
    
    func configureCell(pokemon: Pokemon) {
        //grab stuff from the passed in Pokemon object:
        self.pokemon = pokemon
        
        pokeNameLbl.text = self.pokemon.name.capitalizedString //so that names appear with caps via computed property of Swift String type
        
        pokeThumbnailImg.image = UIImage(named: "\(self.pokemon.pokedexId)") //all the image "names" are just numbers -- You got this without having mp show you albeit after you had the wrong "name" assigned to the image
        
        
        
    }
}
