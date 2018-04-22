//
//  FlipEngine.swift
//  WhatTheFlip
//
//  Created by Hugo Olcese on 4/1/18.
//  Copyright © 2018 MOBILE PRO. All rights reserved.
//

import Foundation

struct FlipEngine
{
    private(set) var cards = [Card]() //An Array of Cards
    
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set{
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }// Used to compare the face up card with the other card
    
    init(numberOfPairsOfCards: Int, themeid:Double) // init a pair of cards
    {
        themeidx = themeid
        curthemeidx = themeidx
        assert(numberOfPairsOfCards > 0, "FlipEngine.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards //go through all of the pairs of cards
        {
            let card = Card() // Creates an instance of cards and adds it
            cards += [card, card]
        }
        cards.shuffle(); //shuffle the array of cards
    }//init

    
    internal var emoji = [Card:String]() //An Array of Emojis Chosen
    
    internal var emojiRemoved = [String]() //An Array of Emoji used and removed
    

    internal var emojiThemes: [Double: String] =
    [
        0.0:"😭😢😬😘😅😋😍😛😁🙃🙁😱😜😤🤤😴",
        1.0:"❤️😈☠️👹💩💩👻👽👽🤖👙👘👔⛑☂️👑",
        2.0:"🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🦁🐮🐷🐸🐵🐥",
        3.0:"🌕🌎🌚🌝🌞🌛🌙💫⭐️🌟✨⚡️☄️🌜🌑🌗",
        4.0:"☀️🌤⛅️🌥🌦🌈🌧⛈🌩☃️⛄️❄️🌬🌪🌊💦"
    ]// Themes of different emoji to use
    
    internal var themeidx = 4.0 // Currently set emoji theme
    
    var curthemeidx = 4.0 // Active Emoji theme
    
    internal(set) var matchCounter = 0 // The number of matches made
    
    internal mutating func emoji(for card: Card) -> String //Creates an array of cards with Emoji
    {
        var emojiChosen = ""
        if emoji[card] == nil, emojiThemes[themeidx]!.count > 0
        {
            //print("the themeidx is \(themeidx)")
            let randomStringIndex =
                
                // emojiThemes.emojiChocies.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
                emojiThemes[themeidx]!.index(emojiThemes[themeidx]!.startIndex, offsetBy: emojiThemes[themeidx]!.count.arc4random)
            
            emojiChosen = String(emojiThemes[themeidx]!.remove(at: randomStringIndex)) // choose an emoji at the array of emoji and removes it
            emoji[card] = emojiChosen
            emojiRemoved.append(emojiChosen)
            
        }
        return emoji[card ] ?? "?"
    }// emoji
    
    internal mutating func resetEmoji() // Reset the emoji and get the emoji removed back to the array of emoji
    {
        //var emojichosen = ""
        for emoji in emojiRemoved
        {
            print("The Emoji Removed : \(emoji)") // shows which emoji were removed AKA the active emoji (The ones used)
            emojiThemes[curthemeidx]!.append(emoji)
        }
        emojiRemoved.removeAll()
    }//resetEmoji
    
    mutating func chooseCard(at index: Int) // Check what card the user touched and compare it with another face up card if there is one
    {
        assert(cards.indices.contains(index), "FlipEngine.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched
        {
            //print("The index of only card is \(String(describing: indexOfOneAndOnlyFaceUpCard))")
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index
            // check if cards match
            {
                if cards[matchIndex] == cards[index]
                {
                    //print("passed")
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matchCounter += 1
                    //print("matches: \(matchCounter)")

                }
                cards[index].isFaceUp = true
            }else{
                //either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }//chooseCard
    
}

// An extension of Arrry that shuffles an array
extension Array {
    mutating func shuffle(){
        for _ in 0..<count
        {
            sort { (_,_) in arc4random() < arc4random()}
        }
    }
}

// An extension of Collection that creates an var named oneandOnly that returns an count if its first or nil if not
extension Collection{
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}


