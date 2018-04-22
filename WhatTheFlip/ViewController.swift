//
//  ViewController.swift
//  WhatTheFlip
//
//  Created by Hugo Olcese on 3/31/18.
//  Copyright © 2018 MOBILE PRO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    private lazy var game = FlipEngine(numberOfPairsOfCards: numberOfPairsOfCards,themeid: 2) // Init the game
    
    
    var numberOfPairsOfCards: Int{
    
            return (cardButtons.count+1) / 2
    }// Find the number of pairs
    
    private(set) var flipCount = 0
    {
        didSet
        {
            updateFlipCountLabel()
        }// Update the Flip Label everytime the flipCount changes
    }
    
    override func viewDidLoad() // Run the timer when the game loads
    {
        runTimer()
    }
    
    private func updateFlipCountLabel() // Updates the Attributes of the FlipLabel and changes the text of the label
    {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
        
    }//updateFlipCountLabel
    
    @objc private func updateTimerLabel() // Updates the Timer Label by changing the attributes and the text of the label
    {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "\(seconds)", attributes: attributes)
        timerLabel.attributedText = attributedString
        
    }//updateTimerLabel
    
    private func updateThemeidxLabel() // Updates the ThemeIdx Label by changing the text of the label
    {
        themeidxLabel.text = String(game.themeidx)
    }//updateThemeidxLabel
    
    
    var presetTime = 60 //A preset time that the reset timer uses -- Must be equal to seconds
    
    var seconds = 60 // The amount of time the user has per game
    {
        didSet
        {
            updateTimerLabel()
        }
    }
    var timer = Timer() // Set up the initial timer

    var isTimerRunning = false

    var gameover = false // Indicates when the game is over
    
    func runTimer() // start the timer
    {
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }//runTimer
    
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
        seconds -= 1
        timerLabel.text = "\(seconds)"
        }
    }//updateTimer()
    
    
    @IBOutlet weak var timerLabel: UILabel! // The label for Timer (Bottom-right)
    {
        didSet
        {
            updateTimerLabel() // Function that updates the Timer
        }
    }//timerLabel
    
    private func resetTimer() //Reset the timer back to the preset time when the game end
    {
        seconds = presetTime // reset the timer back to a preset time
    }
    
    @IBAction func bgStepper(_ sender: UIStepper)
    {
        self.bgColorLabel.text = String(sender.value)
        print("the bgColor is now : \(String(describing: bgColorLabel.text))")
    }
    
    @IBOutlet weak var bgColorLabel: UILabel! // The Int Index for Background Color
    
    @IBOutlet weak var backgroundLabel: UILabel! // The Text Label for Background:
    
    @IBOutlet weak var CardsColl: UIStackView! // The Collection of Cards as a whole
    
    @IBOutlet weak var gameoverLbl: UILabel!  // The Message for Player at the end of the game

    
    @IBOutlet weak var orLabel: UILabel! // The Text Label for Theme:
    
    @IBOutlet weak var curThemeLabel: UILabel! // The Int Index for Themes
    
    @IBOutlet weak var themeidxLabel: UILabel! // The label for the theme Steeper
    
    @IBOutlet weak var stepperLabel: UIStepper! // The label for the theme Steeper

    @IBOutlet private var cardButtons: [UIButton]! // Collection of CardButtons
    
    @IBOutlet private weak var StartNewGameLabel: UIButton! // The Button for New Game
    
    
    @IBAction private func StartNewGame(_ sender: UIButton)
    {
        newGame(); // Reset all of the variables for a new fresh game
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! // The label for Flip Counter (Bottom-left)
    {
        didSet
        {
            updateFlipCountLabel()
        }// Function that updates the Flip Count
    }
    
    
    @IBAction func ThemeStepper(_ sender: UIStepper) // Allow the user to change the Theme Idx using a Stepper
    {
        self.themeidxLabel.text = String(sender.value)
        game.themeidx = sender.value
        print("the themeidx is now : \(game.themeidx)")
        
    }
    
    
    @IBAction private func touchCard(_ sender: UIButton) // Tapping on a card
    {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender)
        {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("Chosen Card was not in cardButtons")
        }
    }//touchCard
    
    private func upddateHiddenLabel(start: Bool, gameover: Bool) // Change the Hidden Properties for Multiple Labels
    {
        if (gameover)
        {
            gameoverLbl.isHidden = false;
        }
        if (start)
        {
            StartNewGameLabel.isHidden = true;
            //orLabel.isHidden = true;
            curThemeLabel.isHidden = true;
            themeidxLabel.isHidden = true;
            updateThemeidxLabel()
            stepperLabel.isHidden = true;
        }else{
            gameoverLbl.isHidden = true;
            StartNewGameLabel.isHidden = false;
            //orLabel.isHidden = false;
            curThemeLabel.isHidden = false;
            themeidxLabel.isHidden = false;
            updateThemeidxLabel()
            stepperLabel.isHidden = false;
        }
    }//updateHiddenLabel
    
    private func updateViewFromModel()
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
            CardsColl.isHidden = true;  // Hide all of the cards
            if (gameover) // if the game is over
            {
                upddateHiddenLabel(start: false, gameover: true) // Unhide the gameover label
            }else{
                upddateHiddenLabel(start: false, gameover: false)  // if not, that means the player won
            }
            for index in cardButtons.indices //Go through all of the cards in the setup
            {
                let button = cardButtons[index] // create a button
                let card = game.cards[index] // create a instance of card
                button.setTitle("", for:  UIControlState.normal) //if the cards  are matched, make them invisible
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            }
        }
    }//gameEnd
    
    
    typealias Theme = (emojiChoices: String, backgroundColor: UIColor, cardBackColor: UIColor)
    
    private func newGame() // Reset all of the neccessary variables to reset the game.
    {
        resetTimer() // reset the timer
        CardsColl.isHidden = false; // make the cards appear again
        game.resetEmoji() // reset the emoji used
        let themeid = game.themeidx
        game = FlipEngine(numberOfPairsOfCards: (cardButtons.count+1 / 2), themeid: themeid)
        flipCount = 0;
        game.matchCounter = 0
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            button.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1) //set all of the cards facing down
            upddateHiddenLabel(start: true, gameover: false) // reset all of the labels
            
        }
    }// newGame
    
    
}
//Extension to Int that does handle randomized integers
extension Int {
    var arc4random: Int {
        if self > 0 {
        return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0;
        }
    }
}



