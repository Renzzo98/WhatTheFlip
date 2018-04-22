//
//  Test.swift
//  WhatTheFlip
//
//  Created by Hugo Olcese on 4/20/18.
//  Copyright © 2018 MOBILE PRO. All rights reserved.
//

import Foundation
//
//  ViewController.swift
//  WhatTheFlip
//
//  Created by Hugo Olcese on 3/31/18.
//  Copyright © 2018 MOBILE PRO. All rights reserved.
//

import UIKit

  /*

 THIS IS MY VIEW CONTROLLER CODE BUT IN ORDER AND MUCH MORE READABLE. FEEL FREE TO READ THIS INSTEAD; SAME CODE AS VIEWCONTROLLER.SWIFT
 
 // WARNING: DO NOT UNCOMMENT THIS FILE! //
 
 
    // Init Setup //
    
    private lazy var game = FlipEngine(numberOfPairsOfCards: numberOfPairsOfCards,themeid: 1) // Init the game
    
    var numberOfPairsOfCards: Int{
        
        return (cardButtons.count+1) / 2
    } // Find the number of pairs
    
    override func viewDidLoad() // Run the timer when the game loads
    {
        runTimer()
    }
    
    // End of Init Setup //
    
    typealias Theme = (emojiChoices: String, backgroundColor: UIColor, cardBackColor: UIColor)
    
    // Variables //
    
    var gameover = false
    var presetTime = 35
    var seconds = 35
    {
        didSet
        {
            updateTimerLabel()
        }
    }
    private(set) var flipCount = 0
    {
        didSet
        {
            updateFlipCountLabel()
        }// Update the Flip Label everytime the flipCount changes
    }
    // End of Variables //
    
    
    // Labels //
    @IBOutlet weak var bgColorLabel: UILabel! // The Int Index for Background Color
    
    @IBOutlet weak var backgroundLabel: UILabel! // The Text Label for Background:
    
    @IBOutlet weak var CardsColl: UIStackView! // The Collection of Cards as a whole
    
    @IBOutlet weak var endGameMsg: UILabel! // The Message for Player at the end of the game
    
    @IBOutlet weak var curThemeLabel: UILabel! // The Text Label for Theme:
    
    @IBOutlet weak var themeidxLabel: UILabel! // The Int Index for Themes
    
    @IBOutlet weak var themeStepperLbl: UIStepper! // The label for the theme Steeper
    
    @IBOutlet private var cardButtons: [UIButton]! // Collection of CardButtons
    
    @IBOutlet private weak var StartNewGameLabel: UIButton! // The Button for New Game
    
    @IBOutlet private weak var flipCountLabel: UILabel! // The label for Flip Counter (Bottom-left)
        {
        didSet
        {
            updateFlipCountLabel() // Function that updates the Flip Count
        }
    }//FlipCountLabel
    
    @IBOutlet weak var timerLabel: UILabel! // The label for Timer (Bottom-right)
        {
        didSet
        {
            updateTimerLabel() // Function that updates the Timer
        }
    }//timerLabel
    
    // End of Labels //
    
    
    // Update Labels //
    
    private func updateFlipCountLabel() // Updates the Attributes of the FlipLabel and changes the text of the label
    {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
        
    }//updateFlipCountLabel
    
    @objc private func updateTimerLabel()// Updates the Timer Label by changing the attributes and the text of the label
    {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "\(seconds)", attributes: attributes)
        timerLabel.attributedText = attributedString
        
    }//updateTImerLabel
    
    private func updateThemeidxLabel() // Updates the ThemeIdx Label by changing the text of the label
    {
        themeidxLabel.text = String(game.themeidx)
    }//updateThemeidxLabel
    
    
    private func updateHiddenLabel(start: Bool, gameover: Bool) // Change the Hidden Properties for Multiple Labels
    {
        if (gameover)
        {
            endGameMsg.isHidden = false;
        }
        if (start)
        {
            StartNewGameLabel.isHidden = true;
            //orLabel.isHidden = true;
            curThemeLabel.isHidden = true;
            themeidxLabel.isHidden = true;
            updateThemeidxLabel()
            themeStepperLbl.isHidden = true;
        }else{
            endGameMsg.isHidden = true;
            StartNewGameLabel.isHidden = false;
            //orLabel.isHidden = false;
            curThemeLabel.isHidden = false;
            themeidxLabel.isHidden = false;
            updateThemeidxLabel()
            themeStepperLbl.isHidden = false;
        }
    }//updateHiddenLabel
    
    //End of Update Labels //
    
    
    // Steppers //
    @IBAction func ThemeStepper(_ sender: UIStepper) // Allow the user to change the Theme Idx using a Stepper
    {
        sender.value = game.themeidx
        self.themeidxLabel.text = String(sender.value)
        print("the themeidx is now : \(game.themeidx)")
        
    }//ThemeStepper
    
    @IBAction func bgStepper(_ sender: UIStepper) // Allow the user to change the Bg Color Idx using a Stepper
    {
        self.bgColorLabel.text = String(sender.value)
        print("the bgColor is now : \(String(describing: bgColorLabel.text))")
    }//bgStepper
    
    // End of Steppers //
    
    
    // Actions //
    
    // Press Button to Start a new Game
    @IBAction private func StartNewGame(_ sender: UIButton)
    {
        newGame(); // Reset the variables
    }//StartNewGame
    
    
    // The Action when you tap on a card
    @IBAction private func touchCard(_ sender: UIButton) // Tapping on a card
    {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender)
        {
            game.chooseCard(at: cardNumber) //Checks the card when choosen
            updateViewFromModel() // changes the models on screen (flip the cards, and add emoji)
        }else{
            print("Chosen Card was not in cardButtons")
            // When you tap on a card that doesn't exist as a button
        }
    }//touchCard
    
    // End of Actions //
    
    
    // Timer //
    
    var timer = Timer() // Set up the initial timer
    var isTimerRunning = false
    
    func runTimer() // start the timer
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }//runTimer
    
    private func resetTimer() //Reset the timer back to the preset time when the game end
    {
        seconds = presetTime
    }//resetTimer
    
    @objc func updateTimer() //Updates the timer and makes it end when it reaches 0
    {
        if (seconds == 0)
        {
            //print("Timer stop")
            gameover = true
            game.matchCounter = ((cardButtons.count+1 / 2)/2)
            gameEnd()
        }else{
            //print("Timer running")
            seconds -= 1 //decrease the timer by 1 second
            timerLabel.text = "\(seconds)"
        }
    }//updateTimer
    
    // End of Timer //
    
    
    // Updating ViewController Element //
    
    private func updateViewFromModel() // Change the card buttons (Set up the backgrounds of card and insert emoji) and end game if the
    {
        //print("begin")
        //print("matches: \(game.matchCounter)")
        
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp
            {
                //print("Face up")
                button.setTitle(game.emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            }else{
                //print("Fsce down")
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            }
            gameEnd()
        }
        //print("total pairs: \((cardButtons.count+1 / 2)/2)")
        
        // print("end")
    }//updateViewFromModel
    
    private func gameEnd() // If the number of matches equals the number of pairs, end the game by resetting the cards
    {
        if (game.matchCounter == ((cardButtons.count+1 / 2)/2)) // This condition will indicate that the game is end due to the number of matches made
        {
            CardsColl.isHidden = true; // Hide all of the cards
            if (gameover) // if the game is over
            {
                updateHiddenLabel(start: false, gameover: true) // Unhide the gameover label
            }else{
                updateHiddenLabel(start: false, gameover: false) // if not, that means the player won
            }
            for index in cardButtons.indices
            {
                let button = cardButtons[index]
                let card = game.cards[index]
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            }
        }
    }
    
    private func newGame() // Reset all of the neccessary variables to reset the game.
    {
        resetTimer()
        gameover = false
        CardsColl.isHidden = false;
        game.resetEmoji()
        let themeid = game.themeidx
        game = FlipEngine(numberOfPairsOfCards: (cardButtons.count+1 / 2), themeid: themeid)
        flipCount = 0;
        game.matchCounter = 0
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            button.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            updateHiddenLabel(start: true, gameover: false)
            
        }
    }// newGame
    
    // End of Updating ViewController Element //
}


 */

