//
//  FacialExpression.swift
//  FaceIt_Playground
//
//  Created by lalitote on 26.07.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import Foundation

struct FacialExpression {
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }
    
    enum EyeBrows: Int {
        case relaxed
        case normal
        case furrowed
        
        func moreRelaxedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .relaxed
        }
        
        func moreFurrowedBrows() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .furrowed
        }
    }
    
    enum EyePupil: Int {
        case left
        case center
        case right
        
        func moreLeftish() -> EyePupil {
            return EyePupil(rawValue: rawValue - 1) ?? .center
        }
        
        func moreRightish() -> EyePupil {
            return EyePupil(rawValue: rawValue + 1) ?? .center
        }
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var eyePupil: EyePupil
    var mouth: Mouth
    
}
