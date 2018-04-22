//
//  Card.swift
//  WhatTheFlip
//
//  Created by Hugo Olcese on 4/1/18.
//  Copyright © 2018 MOBILE PRO. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    var hashValue: Int { return identifier } // Hashed the unique idetifier for each card
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }// == operator that checks if the cards are equal to each based on their identifier
    
    var isFaceUp = false // Checks if the card is faced up or not
    var isMatched = false // Checks if the card is matched with another card already
    private var identifier: Int // An identifier to each card (like a tag)
    
    private static var identifierFactory = 0 // Produces an unique identifier for each new card
    
    private static func getUniqueIdentifier() -> Int //create an new instance of indentifier
    {
        identifierFactory += 1
        return identifierFactory;
    }
    
    init() // Init an new card
    {
        self.identifier = Card.getUniqueIdentifier()
    }
}
