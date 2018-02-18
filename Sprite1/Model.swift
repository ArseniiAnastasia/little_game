//
//  Model.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 18.02.2018.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import Foundation

enum DifficultyChoosing: Int {
    case easy, medium, hard
}

enum BgCoosing: Int {
    case bg1, bg2
}

class Model {
    static let sharedInstance = Model()
    
    // Variables
    var sound = true
    var score = 0
    var highscore = 0
    var totalscore = 0

    var level2UnlockValue = 200
    
}
