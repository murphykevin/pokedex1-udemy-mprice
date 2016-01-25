//
//  ViewController.swift
//  pokedex1-udemy
//
//  Created by Kevin Murphy on 1/13/16.
//  Copyright © 2016 Caravel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemonArray = [Pokemon]()   //data source for the collection
    //or var pokemonArray: [Pokemon]! -- this just declares it though
    var filteredPokemonArray = [Pokemon]()
    var musicPlayer: AVAudioPlayer! //not ready to create it yet
    var inSearchMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self //we currently do not have a data source i.e. no array of items
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done //you knew this was an enum choice - Niiice. When you click on Done, keyboard will hide
        
        initializeAudio()
        parsePokemonCSV()   //MP coding convention to create empty shell of function and then call it where needed
    }
    
    func initializeAudio() {
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        
        //the player doesn't always work so we need a do/try
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //infinite looping
            musicPlayer.play() 
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
    func parsePokemonCSV() {
        //grab the file and then run the parser:
        //we want to grab the data from the csv file and parse it in here:
        //1st: need a path
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")! //we know that the file exists - because we put it there, not d-loading from i-net, therefore safe to force unwrap
        //now run the parser (mp created library file - dive into this code at some point), which can throw an error 
        do {
            let csv = try CSV(contentsOfURL: path) //don't understand when need a try fully - seems that xcode will tell you, examining init method shows it's written with a throw/try
            //now that we have an object of type CSV can apply methods/properties of its class, we want to grab the rows out of the pokemon.csv file
            let rows = csv.rows //rows is type Dictionary key: String, val: String; the heavy lifting happens at init, a method is called AUTOMATICALLY (hah), that parses the row, interesting to study this as it gives some insight into what it means by "automatically"
            //print(rows)  // result is an array of dictionaries
            //now we want to iterate through the rows and create a bunch of pokemon objects and put them in the pokemonArray (dataSource)
            for row in rows {
                let pokeId = Int(row["id"]!)!  //initializer to create row dictionary would have failed so know that if we got to this point that we also have a value for "id". MP didn't explain this, but that must be what he means. 
                let name = row["identifier"]! //force unwrap, MP hasn't, yet... 
                let pokeObj = Pokemon(name: name, pokedexId: pokeId)
                pokemonArray.append(pokeObj) //nice job, you got this ahead of MP, note autocomplete did not suggess pokeObj, nor did it for MP. bonus .25 
                //print(pokemonArray)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    
    

    // UICollectionViewDataSource req'd methods ===========
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       //start off w/ some test data:
        if inSearchMode == true {
            return filteredPokemonArray.count
        } //no else req'd b/c once we call return won't execute next statement

        return pokemonArray.count  //you got this ahead of MP - .25 bonus!
    }
    
    //called 718 times
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //note that mprice uses generic "collectionView" in the cell declaration below, much clearer to me with this explicit reference, if have issue change it back
        if let cell = self.collection.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            //if you were successfully able to grab an empty cell of the type PokeCell, then return that, before the cell appears on the screen as you're scrolling the function cellForItemAtIndexPath is called
            
            //one way to eliminate the empty image is to ad 1 to indexPath.row, this is probably necessary to get the names to line up w/ the image when change from value of "test"
            //TEST DATA (START)
            //let newPokemon = Pokemon(name: "test", pokedexId: indexPath.row) //the row is the actual id of each item, don't be confused by the word "row", think of it as each item, in this case every single item is it's own row
            //TEST DAT (END)
            
            let pokeForView: Pokemon!
            
            if inSearchMode == true {
                 pokeForView = filteredPokemonArray[indexPath.row] //you got this also ahead of MP, nice
                //cell.configureCell(newPokemon), not sure why doesn't give an empty first object/item seems like id and indexPath.row would be out of alignment - MP must adjust in his parser file
            } else {  //had an error when used "else if" not 100% sure why
                pokeForView = pokemonArray[indexPath.row]
            }
            
            cell.configureCell(pokeForView)
            return cell
            
        } else {
            return UICollectionViewCell() //Is this right? thought it would be PokeCell() a bit confused see if he changes that
        }
        
    }
    // END UICollectionViewDataSource req'd methods ===========
    
    //was not being called - based on how MP had the storyboard set up - YOU figured it out issue ahead of him - NIIICE JOB. .25 bonus!! 
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //whenever an item is tapped, grab that item and pass it over to the DetailVC so it knows which pokemon was tapped on
        //prepareForSegue("SegueToPokemonDetailVC", sender: AnyObject?) -- NOPE
        //two different lists, an item can be selected in the filtered array, or the unfiltered array
        let pokeSelected: Pokemon!
        
        if inSearchMode {  //(if inSearchMode == true)
            pokeSelected = filteredPokemonArray[indexPath.row] //got this!
        } else {
            pokeSelected = pokemonArray[indexPath.row]
        }
        
        print(pokeSelected.name)
        
       performSegueWithIdentifier("SegueToPokemonDetailVC", sender: pokeSelected) //got this! //this loads the segue but we need a way to get the pokemon passed in to our detailVC
    }
  
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 //how to use sections??
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //set the size of the grid
        return CGSizeMake(105, 105)   // good grid size
    }
    
    @IBAction func onMusicBtnPressed(sender: UIButton!) {  //can specify sender as type UIButton! and then apply the Button classes properties/methods
        
        if musicPlayer.playing == true { //or simply if musicPlayer.playing { } == true is implied
            musicPlayer.pause()  //or musicPlayer.stop()
            sender.alpha = 0.2 //would this still work on a jpeg? 
        } else if musicPlayer.playing == false {  //or simply else musicPlayer.play()
            musicPlayer.play()
            sender.alpha = 1.0 //fully opaque 
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {  //we changed this button to "Done"
        //hide keyboard when search -- CHANGED TO "DONE" button is tapped:
        self.view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //what do we want to have happen? You type in a letter and the full list of pokemon is filtered we're going to need a second array to store the filtered list for the collection view cell data source. Will need a var of type Bool to determine if we're in search mode
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false //populate the collection view data from the unfiltered array
            self.view.endEditing(true) //first responder in this case is the keyboard, we want it to hide when no text in searchbar
            self.collection.reloadData() //** I added this before MP (lets see if MP does - he does) to get full list to show again after searching! .25 bonus
        } else {
            inSearchMode = true
            //grab the word/characters that is currently in the search bar text field:
            let lowerCaseString = searchBar.text!.lowercaseString  //we know that if we get to this point we have txt therefore safe to force unwrap, use the computed property lowerecaseString to ensure search is NOT case sensitive
            //make sure you understand rhs of filteredPokemonArray - not sure I get "rangeOfString" play around with in playground
            //filteredPokemonArray = pokemonArray.filter({$0.name.rangeOfString(lowerCaseString) != nil }) // i think "!=" in this case is an operator shorthand inside a closure, weird syntax, can't remember the long form of this consider revisiting - I did, here it is! Consider bonus of some type!
            filteredPokemonArray = pokemonArray.filter({ (poke: Pokemon) -> Bool in
                return poke.name.rangeOfString(lowerCaseString) != nil //return is not req'd; if there is a match of the pokemon name to the string entered by user then put it into a new array called filteredPokemonArray, ie when evaluates to *true* 
            })
            //if it's empty there was no match for the string, but if it's not empty puts into new array ie: "filteredPokemonArray"
            //refresh our collection view:
            self.collection.reloadData()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToPokemonDetailVC" {
            //letting the detailVC know which item was tapped on
            if let detailedVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailedVC.pokemonDetail = poke //think this is right - BOOM - .25 bonus; turns out it's not being executed causing us to crash
                }
            }
        }
    }
    
}


























