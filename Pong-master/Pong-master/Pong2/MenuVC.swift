
//  MenuVC.swift
//  Pong2


import Foundation
import UIKit
import GameKit

enum gameType {
    case easy
    case medium
    case hard
    case player2
}


class MenuVC : UIViewController, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
    }
    
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.Archetapp.ThumpTrump"
    
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    // MARK: - OPEN GAME CENTER LEADERBOARD
    @IBAction func checkGCLeaderboard(_ sender: AnyObject) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
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
