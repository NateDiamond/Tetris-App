//
//  Board.swift
//  FinalProject
//
//  Created by Nathaniel Diamond on 4/9/17.
//  Copyright © 2017 Nathaniel Diamond. All rights reserved.
//

//MAKE SURE TO ADD 4 ROWS EXTRA ABOVE WHAT IS VISIBLE TO THE USER

import Foundation

class Board {
    
    var spaces: [[Space?]]
    var rows: Int
    var cols: Int
    
    init(rows: Int, cols: Int, boxDim: Double) {
        self.rows = rows
        self.cols = cols
        spaces = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        for i in 0..<rows {
            for j in 0..<cols{
                spaces[i][j] = Space(absY: i, absX: j, dim: boxDim)
            }
        }
    }
    
    func checkRowForClear(row: Int) -> Bool {
        for s in spaces[row] {
            if(!(s?.hasPiece)!){
                return false
            }
        }
        return true
    }
    func clearRow(row: Int) {
        for s in spaces[row]{
            s?.clear()
        }
        for y in row+1..<rows{
            for x in 0..<cols{
                if(spaces[y][x]?.hasPiece)!{
                    spaces[y-1][x]?.fill(color: (spaces[y][x]?.color!)!)
                    spaces[y][x]?.clear()
                }
            }
        }
    }
    
    
}
