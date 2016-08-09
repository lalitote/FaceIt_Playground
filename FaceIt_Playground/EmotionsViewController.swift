//
//  EmotionsViewController.swift
//  FaceIt_Playground
//
//  Created by lalitote on 09.08.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    private let emotionalFace: Dictionary<String,FacialExpression> = [
        "angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, eyePupil: .Left, mouth: .Frown),
        "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, eyePupil: .Right, mouth: .Smirk),
        "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, eyePupil: .Center, mouth: .Smile),
        "mischievious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, eyePupil: .Left, mouth: .Grin)
    ]

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc = segue.destinationViewController
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
