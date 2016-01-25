//
//  PokemonDetailVC.swift
//  pokedex1-udemy
//
//  Created by Kevin Murphy on 1/18/16.
//  Copyright © 2016 Caravel. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameDetailLbl: UILabel!
    @IBOutlet weak var mainImgDetailVC: UIImageView!
    @IBOutlet weak var descLblDetailVC: UILabel!
    @IBOutlet weak var typeLblDetailVC: UILabel!
    @IBOutlet weak var defenseLblDetailVC: UILabel!
    @IBOutlet weak var heightLblDetailVC: UILabel!
    @IBOutlet weak var pokedexIdLblDetailVC: UILabel!
    @IBOutlet weak var weightLblDetailVC: UILabel!
    @IBOutlet weak var baseAttackLblDetailVC: UILabel!
    @IBOutlet weak var currentEvolutionImgDetailVC: UIImageView!
    @IBOutlet weak var nextEvolutionImgDetailVC: UIImageView!
    @IBOutlet weak var evolutionLblDetailVC: UILabel!
    
    
    var pokemonDetail: Pokemon! 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameDetailLbl.text = pokemonDetail.name //I think I got this too! //you did but pokemonDetail.name was empty and you crashed - so did MP. 
        var img = UIImage(named: "\(pokemonDetail.pokedexId)")
        mainImgDetailVC.image = img
        currentEvolutionImgDetailVC.image = img
        
        //we don't have the rest of the data though:
        
        pokemonDetail.downloadPokemonDetails {
            /*func completed */() -> () in
            //when downloadPokemonDetails is done, whatever code we write below will be executed then we update the views 
            print("DID WE GET HERE?")
            self.updateUI()
            
            
        }
    }
    
    func updateUI() {
        //no longer need the if/lets due to using data hiding/computed properties in Pokemon.swift data model
        descLblDetailVC.text = pokemonDetail.description
        typeLblDetailVC.text = pokemonDetail.type
        defenseLblDetailVC.text = pokemonDetail.defense
        heightLblDetailVC.text = pokemonDetail.height
        pokedexIdLblDetailVC.text = "\(pokemonDetail.pokedexId)"
        weightLblDetailVC.text = pokemonDetail.weight
        baseAttackLblDetailVC.text = pokemonDetail.attack 
        
        if pokemonDetail.nextEvolutionId == "" {   //this was tricky, need to handle if nil
            evolutionLblDetailVC.text = "NO EVOLUTION"
            nextEvolutionImgDetailVC.hidden = true
        } else {
            nextEvolutionImgDetailVC.hidden = false
            nextEvolutionImgDetailVC.image = UIImage(named: pokemonDetail.nextEvolutionId)
            var str = "Next Evolution: \(pokemonDetail.nextEvolutionTxt)"
            //need to determine if need to put level at end or not, some have some don't:
            if pokemonDetail.nextEvolutionLevel != "" {
                //evolutionLblDetailVC.text = "\(str) \(pokemonDetail.nextEvolutionLevel)"
                str += " - LVL \(pokemonDetail.nextEvolutionLevel)"
            } else {
                evolutionLblDetailVC.text = ""
            }
            
        }
        
    }
    
    

    @IBAction func onBackBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
      
}
