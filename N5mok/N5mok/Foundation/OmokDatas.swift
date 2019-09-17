//
//  OmokDatas.swift
//  N5mok
//
//  Created by hyeoktae kwon on 23/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var player1: Int8 = 0
var player2: Int8 = 0
var winner = false
var gameOver = false

var map = Map(x: 10, y: 20, scale: UIScreen.main.bounds.width - 20)

protocol Piece {
    var stone: Int {get}
}

class Po: Piece {
    var stone: Int = 0
}

let firstMap =
    [
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
]

var binaryMap =
    [
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
]

var firebaseData =
    [
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
]


var resultBtn: UIButton = {
    let btn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20))
    btn.isEnabled = false
    btn.isHidden = true
    btn.contentMode = .scaleToFill
    btn.backgroundColor = .yellow
    return btn
}()


func saveStones(x: Int, y: Int, player: Bool, text: String) {
    let game = dbRef.child("game").child("map")
    var playerColor = 0
    if firstAmI {
        playerColor = 1
    } else {
        playerColor = 2
    }
    print("aoewngaejosgnsojgnaweong", firstAmI)
    firebaseData[x][y] = playerColor
    print("saveStonesTurn: ", player)
    game.updateChildValues([text:firebaseData])
}


func checkStones(){
    var count = 0
    
    for x in 0...10 {
        count = 0
        for y in 0...10 {
            if binaryMap[x][y] == 1 {
                count += 1
            } else {
                count = 0
            }
            if count == 5 {
                winner = false
                gameOver = true
                return
            }
        }
    }
    
    for y in 0...10 {
        count = 0
        for x in 0...10 {
            if binaryMap[x][y] == 1 {
                count += 1
            } else {
                count = 0
            }
            if count == 5 {
                winner = false
                gameOver = true
                return
            }
        }
    }
    
    for x in 0...6 {
        count = 0
        for y in 0...6 {
            var tempX = x
            var tempY = y
            for _ in 0..<5{
                if binaryMap[tempX][tempY] == 1 {
                    count += 1
                } else {
                    count = 0
                }
                tempX += 1
                tempY += 1
            }
            if count == 5 {
                winner = false
                gameOver = true
                return
            }
        }
    }
    
    for x in 0...6 {
        count = 0
        for y in 4...10 {
            var tempX = x
            var tempY = y
            for _ in 0..<5{
                if binaryMap[tempX][tempY] == 1 {
                    count += 1
                } else {
                    count = 0
                }
                tempX += 1
                tempY -= 1
            }
            if count == 5 {
                winner = false
                gameOver = true
                return
            }
        }
    }
    
    for x in 0...10 {
        count = 0
        for y in 0...10 {
            if binaryMap[x][y] == 2 {
                count += 1
            } else {
                count = 0
            }
            if count == 5 {
                winner = true
                gameOver = true
                return
            }
        }
    }
    
    for y in 0...10 {
        count = 0
        for x in 0...10 {
            if binaryMap[x][y] == 2 {
                count += 1
            } else {
                count = 0
            }
            if count == 5 {
                winner = true
                gameOver = true
                return
            }
        }
    }
    
    for x in 0...6 {
        count = 0
        for y in 0...6 {
            var tempX = x
            var tempY = y
            for _ in 0..<5{
                if binaryMap[tempX][tempY] == 2 {
                    count += 1
                } else {
                    count = 0
                }
                tempX += 1
                tempY += 1
            }
            if count == 5 {
                winner = true
                gameOver = true
                return
            }
        }
    }
    
    for x in 0...6 {
        count = 0
        for y in 4...10 {
            var tempX = x
            var tempY = y
            for _ in 0..<5{
                if binaryMap[tempX][tempY] == 2 {
                    count += 1
                } else {
                    count = 0
                }
                tempX += 1
                tempY -= 1
            }
            if count == 5 {
                winner = true
                gameOver = true
                return
            }
        }
    }
}
