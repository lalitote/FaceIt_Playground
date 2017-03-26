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
    var expression = FacialExpression(eyes: .open, eyeBrows: .normal, eyePupil: .center, mouth: .smile) {
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
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(
                target: self, action: #selector(FaceViewController.changeBrows(_:))
                ))
            
            let leftishSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.moreLeftish))
            leftishSwipeGestureRecognizer.direction = .left
            faceView.addGestureRecognizer(leftishSwipeGestureRecognizer)
            
            let rightishSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.moreRightish))
            rightishSwipeGestureRecognizer.direction = .right
            faceView.addGestureRecognizer(rightishSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEye(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .open: expression.eyes = .closed
            case .closed: expression.eyes = .open
            case .squinting: break
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
    
    func changeBrows(_ recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended:
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
    
    fileprivate var mouthCurvatures = [FacialExpression.Mouth.frown: -1.0, .grin:0.5, .neutral:0.0, .smirk:-0.5, .smile: 1.0 ]
    
    fileprivate var eyeBrowTilts = [FacialExpression.EyeBrows.normal: 0.0, .furrowed:-0.5, .relaxed:0.5 ]
    
    fileprivate var eyePupilLocations = [FacialExpression.EyePupil.center: 0.0, .left: -1.0, .right: 1.0]
    
    fileprivate func updateUI() {
        
        if faceView != nil {
            switch expression.eyes {
            case .open: faceView.eyesOpen = true
            case .closed: faceView.eyesOpen = false
            case .squinting: faceView.eyesOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
            faceView.eyePupilLocation = eyePupilLocations[expression.eyePupil] ?? 0.0
        }
    }
}

