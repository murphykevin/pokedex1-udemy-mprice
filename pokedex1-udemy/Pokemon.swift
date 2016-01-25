//
//  Pokemon.swift
//  pokedex1-udemy
//
//  Created by Kevin Murphy on 1/13/16.
//  Copyright © 2016 Caravel. All rights reserved.
//

import Foundation
import Alamofire 

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String! //I think this should be regular optional
    private var _type: String! //I think this should be regular optional //  Grass/Fire
    private var _defense: String! //only way to get nil if cast fails when trying to print
    private var _height: String! //I think this should be regular optional
    private var _weight: String! //I think this should be regular optional
    private var _attack: String! //only way to get nil if cast fails when trying to print
  
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var description: String { //no matter what, if the UI is asking for data I want to give them back something that's not going to crash
            if _description == nil {
                _description = ""  //provides the requestor with a value
            }
            return _description
    }
    
    var type: String {
            if _type == nil {
                _type = ""
            }
            return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = "" 
        }
        return _nextEvolutionLevel
    }
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        //whenever you create a new pokemon set the url
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/" //you had this except for the trailing slash! nice job
    }
    
    //Keep the function declaration clear from the function call
    func downloadPokemonDetails(completed: DownloadComplete) {
      
        let url = NSURL(string: _pokemonURL)!
        
        //omitting 'Alamofire' did not result in error, believe this is the 'shared manager' but is inferred based on my explicit type declaration - nope
        let requestResult: Request = Alamofire.request(.GET, url) //I added explicit type 'Request' for clarity. type Request is a class defined by AF, no details in quick help or autocomplete
        
        print("THE RETURNED result: \(requestResult)")
        
        //This is the function CALL for func responseJSON(); responseJSON simplified DECLARATION would look something like this: func responseJSON(completionHandler: (response: Response!) -> Void) { } - accepts one function as an argument, no other arguments
        //at some point in func responseJSON there will be the statement completionHandler(~whatevertheresponseresultwas of type Response~)
        //call the responseJSON function on the request object
        //requestResult.responseJSON(options: NSJSONReadingOptions, completionHandler: Response<AnyObject, NSError> -> Void)
        requestResult.responseJSON() {
            
          /*func completionHndlr*/  (responze: Response) in //I added the explicit type declaration. type Response is a struct defined by Alamofire
            //let x = Response(request: <#T##NSURLRequest?#>, response: <#T##NSHTTPURLResponse?#>, data: <#T##NSData?#>, result: <#T##Result<Value, Error>#>)  //type Result is an enum defined by AF
            //let y = Result.Success(<#T##Value#>)
            //let z = Result.Failure(<#T##Error#>)
            
            let resoolt: Result = responze.result  //result is an enum of type Result and is a property of struct type Response,
            //let resoolt = responze.result
            //print("THE REQUEST: \(responze.request)")  // original URL request
            //print("THE RESPONSE: \(responze.response)") // URL response
            //print("THE DATA: \(responze.data)")     // server data
            //print("THE RESULT: \(responze.result.value.debugDescription)")   // result of response serialization
            //print("THE DESCRIPTION: \(responze.debugDescription)")
            //print("BOOLEAN: \(resoolt.isSuccess)")
            //print("RESULT MATCHING MP's: \(resoolt.value.debugDescription)")
            
            //recall that resoolt.value is a JSON formatted dictionary assume that AF formats such that conversion can occur w/o using NSData.JSONSerialization.whatever the heck it was
            if let swiftReadableDictionary = resoolt.value as? Dictionary<String, AnyObject> {
                //print(swiftReadableDictionary)
                
                if let weight = swiftReadableDictionary["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = swiftReadableDictionary["height"] as? String {
                    self._height = height
                }
                
                if let attack = swiftReadableDictionary["attack"] as? Int {
                    self._attack = "\(attack)" //MP may have called it just '_attack'
                }
                
                if let defense = swiftReadableDictionary["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack) //may be type Int //not sure how MP got nil for implicit unwrap instead of crash - maybe an xcode preference he has set up? you'll be doing this more, might be apparent later - move on!
                print(self._defense) //may be type Int //not sure how MP got nil for implicit unwrap instead of crash
                
                //types is an array of dictionaries with key = type String, and value = type String
                if let types = swiftReadableDictionary["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    //print(types.debugDescription)
                    //a pokemon can have zero, one, or more than one type, believes max is two:
                    
                    //grab the first type:
                    if let name = types[0]["name"] {  //types[0] is a dictionary, we want the value for the key "name" for that dictionary
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 { //got this!
                        
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                   //self._type! += "/\(name)" //shorthand, **not sure why need the bang symbol expmt w/ a playground
                                  self._type = self._type + "/\(name.capitalizedString)"  //longhanded - got this
                            }
                        }
                        
                    }
                } else {
                    //if there were no types
                    self._type = ""
                }
                
                print(self._type)
                //the key "descriptions" has a value that is an array of dictionaries of type [String:String]
                if let descriptionPokemonArray = swiftReadableDictionary["descriptions"] as? [Dictionary<String, String>] where descriptionPokemonArray.count > 0 {
                    //no need to cast because define the elements of descriptionPokemonArray as Dict<String,String>
                    if let descriptionURL = descriptionPokemonArray[0]["resource_uri"] {
                        let nsurlObject = NSURL(string: "\(URL_BASE)\(descriptionURL)")!  //URL_BASE = "http://pokeapi.co"
                        //recall this is an asynchronous request
                        let descRequestObject = Alamofire.request(.GET, nsurlObject)
                       
                        descRequestObject.responseJSON() {  //the resulting object is ONE JSON dictionary
                            /*func completionHandler*/(responseObject: Response) in
                            let descResult: Result = responseObject.result  //JSON Object/Dictionary
                            if let descDictionarySwiftReadable = descResult.value as? Dictionary<String, AnyObject> {
                                //need to cast because value is unspecified type 'AnyObject'
                                if let descriptionForPoke = descDictionarySwiftReadable["description"] as? String {
                                    self._description = descriptionForPoke
                                    print(self._description)
                                }
                            }  //if error contained in Result type (Enum)
                            
                           completed() //tricky to me on where to call this, can call as soon as soon as second request for data to web finishes
                        }
                        
                        
                    }
                } else {
                    self._description = ""
                }
                
                //Evolutions:
                //we want to grab the very next evolution and show the image for it and the name
                //API only provides the next evolution, not all of them, whatever the hell nerdy pokeman thing that means
                //We know via the poke API that the key evolutions has a value that is an array that contains a dictionary of type String:AnyObject
                if let evolutionsArray = swiftReadableDictionary["evolutions"] as? [Dictionary<String,AnyObject>] where evolutionsArray.count > 0 {
                    
                    if let nextEvolution = evolutionsArray[0]["to"] as? String {  //only need to grab the first object/element
                        //the API still sends some of the evolutions for the "Mega's" and messes things up
                        if nextEvolution.rangeOfString("mega") == nil { //is rangeOfString case sensitive?
                            //now we need to grab the number from the uri and create an image based off of it, we don't want to make a 3rd web request to get the id if we don't have to. use NSString to extract? (My guess) 
                            if let evolutionIdUrlString = evolutionsArray[0]["resource_uri"] as? String {
                                
                                let evolutionIdStringAlmost = evolutionIdUrlString.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "") //boom! you got the second half of this, the replace w/ empty string. now is he going to need to do again to get rid of the forward slash? my guess is yes - YOU WERE CORRECT! - .25 bonus!. "resource_uri" : "/api/v1/pokemon/452/"
                                
                                let evolutionIdStringResult = evolutionIdStringAlmost.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                if let evoLevel = evolutionsArray[0]["level"] as? Int {  //You got this also! .25 bonus
                                    self._nextEvolutionLevel = "\(evoLevel)"
                                }
                                
                                self._nextEvolutionTxt = nextEvolution
                                self._nextEvolutionId = evolutionIdStringResult
                               
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                                print(self._nextEvolutionLevel)
                                
                                //our character is supposed to say the level as well
                                
                                //let evolutionImg = UIImage(named: self._nextEvolutionId)
                                
                            }
                            
                            
                            //self._nextEvolutionTxt = nextEvolution
                        }
                       
                    }
                    
                } else {
                    self._nextEvolutionTxt = ""
                }
                
                
                
  
            }
            
            
            
            
        }
            //CALL COMPLETION HERE?
        
        
    }
    
    
}