//
//  ViewController.swift
//  FaceIt_Playground
//
//  Created by lalitote on 01.07.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController
{
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, eyePupil: .Center, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(_:))
                ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(
                target: self, action: #selector(FaceViewController.changeBrows(_:))
                ))
            
            let leftishSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.moreLeftish))
            leftishSwipeGestureRecognizer.direction = .Left
            faceView.addGestureRecognizer(leftishSwipeGestureRecognizer)
            
            let rightishSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.moreRightish))
            rightishSwipeGestureRecognizer.direction = .Right
            faceView.addGestureRecognizer(rightishSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEye(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    func moreLeftish() {
        expression.eyePupil = expression.eyePupil.moreLeftish()
    }
    
    func moreRightish() {
        expression.eyePupil = expression.eyePupil.moreRightish()
    }
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    func changeBrows(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .Changed,.Ended:
            if recognizer.rotation > CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation = 0.0
            } else if recognizer.rotation < -CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrows()
                recognizer.rotation = 0.0
            }
        default: break
        }
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin:0.5, .Neutral:0.0, .Smirk:-0.5, .Smile: 1.0 ]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Normal: 0.0, .Furrowed:-0.5, .Relaxed:0.5 ]
    
    private var eyePupilLocations = [FacialExpression.EyePupil.Center: 0.0, .Left: -1.0, .Right: 1.0]
    
    private func updateUI() {
        
        switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        faceView.eyePupilLocation = eyePupilLocations[expression.eyePupil] ?? 0.0
    }
}

