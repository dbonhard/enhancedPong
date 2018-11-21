//
//  GameScene.swift
//  Pong2


import SpriteKit
import GameplayKit
import GameKit




class GameScene: SKScene, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("what the fuck is going on")
    }
    
   
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var topLbl = SKLabelNode()
    var btmLbl = SKLabelNode()
    
    var score = [Int]()
    
    let LEADERBOARD_ID = "com.score.mygamename"
    
    override func didMove(to view: SKView) {
 
        topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        btmLbl = self.childNode(withName: "btmLabel") as! SKLabelNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        print(self.view?.bounds.height)
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        
        main = self.childNode(withName: "main") as! SKSpriteNode
        main.position.y = (-self.frame.height / 2) + 50
        
        let border  = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
    }
    
    func startGame() {
        score = [0,0]
        topLbl.text = "\(score[1])"
        btmLbl.text = "\(score[0])"
        ball.run(SKAction.resize(byWidth:100, height:100, duration:0))
        ball.run(SKAction.resize(byWidth:-100, height:-100, duration:2), completion: {() -> Void in self.ball.physicsBody?.applyImpulse(CGVector(dx: 15, dy: -15))})
        ball.texture = SKTexture(imageNamed: currentBallType)
        let oneRevolution = SKAction.rotate(byAngle: CGFloat(-M_PI*2), duration: 5.0)
        ball.run(SKAction.repeatForever(oneRevolution))
    }
    

    func addScore(playerWhoWon : SKSpriteNode){
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        
        
        
        if playerWhoWon == main {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -15, dy: -15))
            
        }
        else if playerWhoWon == enemy {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 15, dy: -15))
        }
        
        topLbl.text = "\(score[1])"
        btmLbl.text = "\(score[0])"
        
        if score[1] > 10 || score[0] > 10{
            // Submit score to GC leaderboard
            let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
            bestScoreInt.value = Int64(score[0]-score[1])
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
//            let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
//            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//            appDelegate.window?.rootViewController = initialViewController
            let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier:"winVC") as! UIViewController
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                appDelegate.window?.rootViewController = initialViewController
        }

    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    
                }
                
            }
            else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }

            
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.0))
                }
                if location.y < 0 {
                    
                    main.run(SKAction.moveTo(x: location.x, duration: 0.0))
                    
                }

            }
            else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.0))
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
        switch currentGameType {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1))
            break
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.7))
            break
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.5))
            break
        case .player2:
            
            break
        }
        
        
        
        if ball.position.y <= main.position.y - 10 {
            addScore(playerWhoWon: enemy)
        }
        else if ball.position.y >= enemy.position.y + 10 {
            addScore(playerWhoWon: main)
        }
    }
    


}







