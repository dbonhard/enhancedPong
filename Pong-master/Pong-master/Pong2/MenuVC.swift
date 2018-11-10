
//  MenuVC.swift
//  Pong2


import Foundation
import UIKit

enum gameType {
    case easy
    case medium
    case hard
    case player2
}


class MenuVC : UIViewController {
    
    
    @IBAction func Player2(_ sender: Any) {
        moveToGame(game: .player2)
    }
    
    @IBAction func Easy(_ sender: Any) {
        moveToGame(game: .easy)
    }
    @IBAction func Medium(_ sender: Any) {
        moveToGame(game: .medium)
        
    }
    @IBAction func Hard(_ sender: Any) {
        moveToGame(game: .hard)
    }
    

    @IBAction func Hillary(_ sender: Any) {
        setBallType(ball: "hillary")
    }
    
    @IBAction func Normal(_ sender: Any) {
        setBallType(ball: "Ball")
    }
    
    func moveToGame(game : gameType) {
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier:"gameVC") as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = gameScene
    }
    
    func setBallType(ball : String) {
   
        currentBallType = ball
    }
}
