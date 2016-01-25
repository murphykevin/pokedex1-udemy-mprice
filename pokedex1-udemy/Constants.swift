//
//  Constants.swift
//  pokedex1-udemy
//
//  Created by Kevin Murphy on 1/20/16.
//  Copyright © 2016 Caravel. All rights reserved.
//

//a series of values that are globally accessible (not in a class)
import Foundation

let URL_BASE = "http://pokeapi.co"  //will have to adjust NSTransportSecurity or request will fail - (isn't https:) 
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> () 