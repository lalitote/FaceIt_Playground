//
//  EmotionsViewController.swift
//  FaceIt_Playground
//
//  Created by lalitote on 09.08.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    fileprivate let emotionalFace: Dictionary<String,FacialExpression> = [
        "angry" : FacialExpression(eyes: .closed, eyeBrows: .furrowed, eyePupil: .left, mouth: .frown),
        "worried" : FacialExpression(eyes: .open, eyeBrows: .relaxed, eyePupil: .right, mouth: .smirk),
        "happy" : FacialExpression(eyes: .open, eyeBrows: .normal, eyePupil: .center, mouth: .smile),
        "mischievious" : FacialExpression(eyes: .open, eyeBrows: .furrowed, eyePupil: .left, mouth: .grin)
    ]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalFace[identifier] {
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton {
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
 

}
