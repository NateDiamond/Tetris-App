//
//  TetrisGameScene.swift
//  FinalProject
//
//  Created by Nathaniel Diamond on 4/5/17.
//  Copyright © 2017 Nathaniel Diamond. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class TetrisGameScene: SKScene {
    
    //var bluePiece = SKSpriteNode(imageNamed: "blue")
    //var darkBluePiece = SKSpriteNode(imageNamed: "dblue")
    //var greenPiece = SKSpriteNode(imageNamed: "green")
    //var yellowPiece = SKSpriteNode(imageNamed: "yellow")
    //var orangePiece = SKSpriteNode(imageNamed: "orange")
    //var purplePiece = SKSpriteNode(imageNamed: "purple")
    //var redPiece = SKSpriteNode(imageNamed: "red")
    
    //CREATE NODES AS NEEDED
    
    let fallSpeed = 0.3
    var pieces: [SKSpriteNode]?
    var lastUpdateTime: Double?
    
    var currTouch: CGPoint?
    var timePressed: Double?
    var pressing: Bool = false
    let TAP_TIME = 0.2
    let MOVE_MARGIN = 50.0
    
    var countDown: Bool = true
    var countClock: Double?
    var running: Bool = true
    
    let ROWS = 22
    let COLS = 10
    var board: Board!
    var fallingPiece: Tetromino?
    
    var audio: SKAudioNode?
    var player = AVAudioPlayer()
    
    override func sceneDidLoad() {
        
        lastUpdateTime = CACurrentMediaTime()
        
        let dim = 1350/(ROWS-4)
        board = Board(rows: ROWS, cols: COLS, boxDim: Double(dim))
        
        generateTetromino()
        
        countDown = true
        countClock = CACurrentMediaTime()
        
        do{
            let audioPath = Bundle.main.path(forResource: "t", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch{
            
        }
        
        player.play()
        
        
    }
    
    override func didMove(to view: SKView) {
        //audio = SKAudioNode(fileNamed: "Tetris_64kb.mp3")
        //addChild(audio!)
        //audio?.run(SKAction.play())
    }

    func draw() {
        removeAllChildren()
        //Special draw for countdown
        if(countDown){
            let text = SKLabelNode(text: String(3 - Int(CACurrentMediaTime()-countClock!)))
            text.fontColor = Tetromino.colorArray()[Int(CACurrentMediaTime()-countClock!)]
            text.fontName = "Didot-Bold"
            text.fontSize = 200
            text.color = UIColor.black
            text.position = CGPoint(x: frame.midX, y: frame.midY)
            self.addChild(text)
        }
        if(!running){
            let text = SKLabelNode(text: "GAME OVER")
            text.fontColor = UIColor.white
            text.fontName = "Didot-Bold"
            text.fontSize = 100
            text.position = CGPoint(x: frame.midX, y: frame.midY)
            self.addChild(text)
        }
        
        //Try to draw here (Leave off top four rows)
        for r in board.spaces{
            for p in r{
                let rect = SKShapeNode(rect: CGRect(x: (p?.getX())!, y: (p?.getY())!, width: (p?.dim)!, height: (p?.dim)!))
                rect.strokeColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
                rect.fillColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
                rect.glowWidth = 2
                self.addChild(rect)
            }
        }
        for r in board.spaces{
            for p in r{
                if (p?.hasPiece)!{
                    let rect = SKShapeNode(rect: CGRect(x: (p?.getX())!, y: (p?.getY())!, width: (p?.dim)!, height: (p?.dim)!))
                    rect.strokeColor = SKColor.black
                    rect.fillColor = (p?.color!)!
                    rect.glowWidth = 2
                    self.addChild(rect)
                }
            }
        }
        for p in (fallingPiece?.pieces)! {
            let rect = SKShapeNode(rect: CGRect(x: (p.getX()), y: (p.getY()), width: (p.dim), height: (p.dim)))
            rect.strokeColor = SKColor.black
            rect.fillColor = (fallingPiece?.color)!
            rect.glowWidth = 2
            self.addChild(rect)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(running){
        if(countDown){
            //make sure to call draw
            if(CACurrentMediaTime()-countClock! >= 3){
                countDown = false
            }
            else{
                draw()
            }
            
        }
        else{
            if(pressing){
                if(CACurrentMediaTime() - timePressed! > 0.05){ //FIX THIS LATER
                    if(Double((currTouch?.x)!) - (fallingPiece?.rightMost())! >= 0){
                        fallingPiece?.moveRight()
                    }
                    else if(Double((currTouch?.x)!) - (fallingPiece?.leftMost())! <= 0){
                        fallingPiece?.moveLeft()
                    }
                }
            }
            if(currentTime - lastUpdateTime! > fallSpeed){
                //move the tetromino down
                if(!(fallingPiece?.drop())!){
                    for p in (fallingPiece?.pieces)!{
                        p.fill(color: (fallingPiece?.color)!)
                        if(p.absY >= ROWS - 4){
                            running = false
                        }
                    }
                    generateTetromino()
                    var i = 0
                    while (i < ROWS){
                        if(board.checkRowForClear(row: i)){
                            board.clearRow(row: i)
                        }
                        else{
                            i += 1
                        }
                    }
                    //CHECK FOR GAME OVER!
                }
            
                //if false, fill the piece in
            
                //check the row and clear as necessary
            
                //generate a new Tetromino
            
                lastUpdateTime = currentTime
                draw()
            }
        }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pressing = true
        currTouch = touches.first?.location(in: self)
        timePressed = CACurrentMediaTime()
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        currTouch = touches.first?.location(in: self)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pressing = false
        if (CACurrentMediaTime() - timePressed! <= TAP_TIME){
            fallingPiece?.rotate()
            draw()
        }
    }
    
    func generateTetromino(){
        let bound = COLS - 2
        fallingPiece = Tetromino(color: Tetromino.randomColor(), anchorIndex: (ROWS - 3, 1 + Int(arc4random_uniform((UInt32(bound))))), board: board!)
    }
}
