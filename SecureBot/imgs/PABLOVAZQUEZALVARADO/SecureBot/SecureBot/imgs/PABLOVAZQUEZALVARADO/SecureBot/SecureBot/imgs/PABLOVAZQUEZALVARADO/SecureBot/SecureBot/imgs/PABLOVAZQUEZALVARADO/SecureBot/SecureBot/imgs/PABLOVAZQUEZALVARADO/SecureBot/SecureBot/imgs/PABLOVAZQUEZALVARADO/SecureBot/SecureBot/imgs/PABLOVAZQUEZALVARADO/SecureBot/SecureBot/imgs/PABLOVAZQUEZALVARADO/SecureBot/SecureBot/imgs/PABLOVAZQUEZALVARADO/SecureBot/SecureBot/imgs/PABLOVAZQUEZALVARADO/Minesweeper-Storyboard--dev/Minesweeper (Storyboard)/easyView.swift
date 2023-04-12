//
//  easyView.swift
//  Minesweeper (Storyboard)
//
//  Created by Student on 5/3/21.
//

import Foundation
import UIKit
class easyView: UIViewController {
    
    var easySquares = [Int](repeating: 0, count: 64)
    var flag = false
    var yIncrement = 0.0
    var index = 0
    var squaresTapped = 0
    
    override func viewDidLoad() {
        randomMines()
        calculateNumberedSquares()
        printGrid()
        flagButton()
    }
    
    func printGrid(){
        for square in easySquares
        {
            let placedSquare = UIButton(frame: CGRect(x:((index % 8) * (Int(UIScreen.main.bounds.size.width) / 8)), y: (Int(UIScreen.main.bounds.size.height / 3)) + Int(yIncrement) * (Int(UIScreen.main.bounds.size.width) / 8), width: (Int(UIScreen.main.bounds.size.width) / 8), height: (Int(UIScreen.main.bounds.size.width) / 8)))
            yIncrement += 0.125
            index += 1
            placedSquare.backgroundColor = UIColor.darkGray
            placedSquare.layer.borderWidth=1
            placedSquare.layer.borderColor = UIColor.black.cgColor
            placedSquare.tag = square
            placedSquare.addTarget(self, action: #selector(squareTapped), for: .touchUpInside)
            self.view.addSubview(placedSquare)
        }
    }
    
    func flagButton()
    {
        let flagButton = UIButton(frame:CGRect(x: UIScreen.main.bounds.size.width/2 - 25, y: UIScreen.main.bounds.size.height/8, width: 50, height: 50))
        flagButton.backgroundColor = UIColor.lightGray
        flagButton.layer.borderWidth = 2
        flagButton.layer.borderColor = UIColor.black.cgColor
        flagButton.setTitle("💣", for: .normal)
        flagButton.addTarget(self, action: #selector(flagButtonTapped), for: .touchUpInside)
        self.view.addSubview(flagButton)
    }
    
    func randomMines()
    {
        var i = 0 // index for each square in array
        var mines = 10 // amount of mines in easy mode
        while(mines > 0) // until mines are all done generating
        {
            if(easySquares[i % 64] == 0)
                {
                let random = Int.random(in: 0...64) //random chance (<15%)
                if(random == 1)
                {
                    easySquares[i % 64] = 9 // 9 means bomb
                    mines -= 1
                }
                i += 1
            }
            else{
                i += 1
            }
        }
    }
    
    func calculateNumberedSquares() //really gross code for looking at adjacent tiles (looking for more elegant solution?)
    {
        for i in 0 ..< easySquares.count
        {
            if easySquares[i] >= 9
            {
               
                if i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 // if i is a top edge square
                {
                    easySquares[i + 1] += 1
                    easySquares[i - 1] += 1
                    easySquares[i + 7] += 1
                    easySquares[i + 8] += 1
                    easySquares[i + 9] += 1
                }
                else
                    if i == 8 || i == 16 || i == 24 || i == 32 || i == 40 || i == 48 // if i is a left edge square
                    {
                        easySquares[i - 8] += 1
                        easySquares[i - 7] += 1
                        easySquares[i + 1] += 1
                        easySquares[i + 8] += 1
                        easySquares[i + 9] += 1
                    }
                    else if i == 15 || i == 23 || i == 31 || i == 39 || i == 47 || i == 55 // if i is a right edge square
                {
                    easySquares[i - 9] += 1
                    easySquares[i - 8] += 1
                    easySquares[i - 1] += 1
                    easySquares[i + 7] += 1
                    easySquares[i + 8] += 1
                }
                else if i == 57 || i == 58 || i == 59 || i == 60 || i == 61 || i == 62 //if i is a bottom edge square
                {
                    easySquares[i - 9] += 1
                    easySquares[i - 8] += 1
                    easySquares[i - 7] += 1
                    easySquares[i + 1] += 1
                    easySquares[i - 1] += 1
                }
                else if i == 0 || i == 7 || i == 56 || i == 63 //if i is a corner square
                {
                    if i == 0
                    {
                        easySquares[i + 1] += 1
                        easySquares[i + 8] += 1
                        easySquares[i + 9] += 1
                    }
                    if i == 7
                    {
                        easySquares[i + 7] += 1
                        easySquares[i - 1] += 1
                        easySquares[i + 8] += 1
                    }
                    if i == 56
                    {
                        easySquares[i - 7] += 1
                        easySquares[i + 1] += 1
                        easySquares[i - 8] += 1
                    }
                    if i == 63
                    {
                        easySquares[i - 9] += 1
                        easySquares[i - 1] += 1
                        easySquares[i - 8] += 1
                    }
                }
                else // if none of those satisfy the if statements (center squares) execute this
                {
                    easySquares[i - 9] += 1
                    easySquares[i - 8] += 1
                    easySquares[i - 7] += 1
                    easySquares[i + 1] += 1
                    easySquares[i - 1] += 1
                    easySquares[i + 7] += 1
                    easySquares[i + 8] += 1
                    easySquares[i + 9] += 1
                }
            }
        }
    }
    
    @objc func squareTapped(sender: UIButton){
        
        if(flag == false){
            if(sender.currentTitle == nil){
        if(sender.tag >= 9){
            loseGame()
            sender.backgroundColor = UIColor.red
        }
        if(sender.tag > 0 && sender.tag < 9){
            sender.setTitle(String(sender.tag), for: .normal)
        }
        if(sender.backgroundColor != UIColor.lightGray)
        {
            squaresTapped += 1
        }
        if(squaresTapped == 54 && sender.tag < 9)
        {
            winGame()
        }
            sender.backgroundColor = UIColor.lightGray
            }
        }
        else{
            if(sender.backgroundColor == UIColor.darkGray)
            {
                if(sender.currentTitle == nil){
                sender.setTitle("🚩", for: .normal)
                }
                else{
                    sender.setTitle(nil, for: .normal)
                }
            }
        }
        
    }
    
    @objc func flagButtonTapped(sender: UIButton){
        if(flag == true)
        {
            sender.setTitle("💣", for: .normal)
            flag = false
        }
        else{
            sender.setTitle("🚩", for: .normal)
            flag = true
        }
    }
    
    func loseGame()
    {
        index = 0
        yIncrement = 0
        //code for losing the game here
        for square in easySquares
        {
            let placedSquare = UIButton(frame: CGRect(x:((index % 8) * (Int(UIScreen.main.bounds.size.width) / 8)), y: (Int(UIScreen.main.bounds.size.height / 3)) + Int(yIncrement) * (Int(UIScreen.main.bounds.size.width) / 8), width: (Int(UIScreen.main.bounds.size.width) / 8), height: (Int(UIScreen.main.bounds.size.width) / 8)))
            index += 1
            yIncrement += 0.125
            if(square >= 9)
            {
                placedSquare.backgroundColor = UIColor.red
                placedSquare.layer.borderWidth=1
                placedSquare.layer.borderColor = UIColor.black.cgColor
                placedSquare.setTitle("💣", for: .normal)
                self.view.addSubview(placedSquare)
            }
        }
        let alert = UIAlertController(title: "You lost...", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Play again", style: .default) {_ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    func winGame()
    {
        let alert = UIAlertController(title: "You won!", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Play again", style: .default) {_ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    
        
        
}
