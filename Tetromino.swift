//
//  Tetromino.swift
//  FinalProject
//
//  Created by Nathaniel Diamond on 4/7/17.
//  Copyright © 2017 Nathaniel Diamond. All rights reserved.
//

import Foundation
import SpriteKit

class Tetromino{
    
    static let red = UIColor(red: 242/255.0, green: 8/255.0, blue: 0, alpha: 1)
    static let orange = UIColor(red: 254/255.0, green: 165/255.0, blue: 0, alpha: 1)
    static let yellow = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
    static let green = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    static let blue = UIColor(red: 5/255.0, green: 253/255.0, blue: 252/255.0, alpha: 1)
    static let darkBlue = UIColor(red: 0, green: 2/255.0, blue: 248/255.0, alpha: 1)
    static let purple = UIColor(red: 1, green: 0, blue: 1, alpha: 1)
    
    
    var pieces: [Space]
    var anchorPoint: Space
    var anchorIndex: (Int, Int)
    var board: Board
    var color: SKColor
    
    init(color: UIColor, anchorIndex: (Int, Int), board: Board){
        self.color = color
        self.anchorPoint = board.spaces[anchorIndex.0][anchorIndex.1]!
        self.anchorIndex = anchorIndex
        self.board = board
        self.pieces = [Space]()
        
        pieces.append(self.anchorPoint)
        if color.isEqual(Tetromino.red){
            pieces.append(board.spaces[anchorIndex.0][anchorIndex.1 - 1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1 + 1]!)
        }
        else if color.isEqual(Tetromino.orange){
            pieces.append(board.spaces[anchorIndex.0 + 1][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1 + 1]!)
        }
        else if color.isEqual(Tetromino.yellow){
            pieces.append(board.spaces[anchorIndex.0][anchorIndex.1 - 1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1 - 1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1]!)
        }
        else if color.isEqual(Tetromino.green){
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1 - 1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0][anchorIndex.1 + 1]!)
        }
        else if color.isEqual(Tetromino.blue){
            pieces.append(board.spaces[anchorIndex.0 + 1][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0 + 2][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1]!)
        }
        else if color.isEqual(Tetromino.darkBlue){
            pieces.append(board.spaces[anchorIndex.0 + 1][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1 - 1]!)
        }
        else{
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1 + 1]!)
            pieces.append(board.spaces[anchorIndex.0 - 1][anchorIndex.1 - 1]!)
        }
        
    }
    
    static func colorArray() -> [UIColor] {
        return [red, orange, yellow, green, blue, darkBlue, purple]
    }
    
    //These functions return true if the move is successful
    func rotate() -> Bool {
        if color.isEqual(Tetromino.yellow){
            return true
        }
        var newArray = [Space]()
        for p in pieces{
            let newY = anchorIndex.0 - p.absX + anchorIndex.1
            let newX = anchorIndex.1 + p.absY - anchorIndex.0
            
            if (newX < 0 || newX >= board.cols || newY < 0 || newY >= board.rows){
                return false
            }
            
            let newSpace = board.spaces[newY][newX]
            if (newSpace?.hasPiece)!{
                return false
            }
            newArray.append(newSpace!)
        }
        pieces = newArray
        return true
    }
    
    func drop() -> Bool {
        var newArray = [Space]()
        for p in pieces{
            if (p.absY == 0) {
                return false
            }
            let newSpace = board.spaces[p.absY - 1][p.absX]
            if(newSpace?.hasPiece)!{
                return false
            }
            newArray.append(newSpace!)
        }
        pieces = newArray
        anchorIndex.0 -= 1
        return true

    }
    
    func moveRight() -> Bool {
        var newArray = [Space]()
        for p in pieces{
            if (p.absX == board.rows - 1) {
                return false
            }
            let newSpace = board.spaces[p.absY][p.absX + 1]
            if(newSpace?.hasPiece)!{
                return false
            }
            newArray.append(newSpace!)
        }
        pieces = newArray
        anchorIndex.1 += 1
        return true
    }
    
    func moveLeft() -> Bool {
        var newArray = [Space]()
        for p in pieces{
            if (p.absX == 0) {
                return false
            }
            let newSpace = board.spaces[p.absY][p.absX - 1]
            if(newSpace?.hasPiece)!{
                return false
            }
            newArray.append(newSpace!)
        }
        pieces = newArray
        anchorIndex.1 -= 1
        return true
    }
    
    static func randomColor() -> UIColor {
        return Tetromino.colorArray()[Int(arc4random_uniform(7))]
    }
    
    func rightMost() -> Double {
        var max = 0.0
        
        for p in pieces{
            let testMax: Double = p.getX()+p.dim
            if(testMax > max){
                max = testMax
            }
        }
        return max
    }
    func leftMost() -> Double {
        var min = pieces[0].getX()
        
        for p in pieces{
            let testMin: Double = p.getX()
            if(testMin < min){
                min = testMin
            }
        }
        return min
    }

    
    
}
