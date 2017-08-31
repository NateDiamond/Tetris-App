//
//  Space.swift
//  FinalProject
//
//  Created by Nathaniel Diamond on 4/7/17.
//  Copyright © 2017 Nathaniel Diamond. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class Space{
    
    var absX: Int, absY: Int
    var dim: Double
    var hasPiece = false
    var color: UIColor?
    
    init(absY: Int, absX: Int, dim: Double){
        self.absX = absX
        self.absY = absY
        self.dim = dim
    }
    
    func getSquare() -> CGRect {
        return CGRect(x: Double(absX) * dim, y: Double(absY)*dim, width: dim, height: dim)
    }
    
    /*func onTop(other: Space) -> Bool {
        return self.absX == other.absX && self.absY == other.absY + 1
    }
    
    func touchingWall(leftX: Int, rightX: Int) -> Bool{
        return self.absX == leftX || self.absX == rightX
    }
    
    func throughWall(leftX: Int, rightX: Int) -> Bool {
        return self.absX < leftX || self.absX > rightX
    }*/
 
    func fill(color: UIColor){
        hasPiece = true
        self.color = color
    }
    func clear(){
        hasPiece = false
    }
    
    func getX() -> Double{
        return Double(absX) * dim
    }
    func getY() -> Double {
        return Double(absY) * dim
    }
    
}
