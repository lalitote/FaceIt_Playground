//
//  FaceView.swift
//  FaceIt_Playground
//
//  Created by lalitote on 01.07.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.75 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = true { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyePupilLocation: Double = 1.0 { didSet {setNeedsDisplay() } }
    @IBInspectable
    var eyeBrowTilt: Double = -1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.gray { didSet { setNeedsDisplay() } }
    @IBInspectable
    var colorFace: UIColor = UIColor.yellow { didSet { setNeedsDisplay() } }
    @IBInspectable
    var colorPupil: UIColor = UIColor.gray { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    func changeScale(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    fileprivate var faceSide: CGFloat {
        return min(bounds.size.width, bounds.size.height) * scale
    }
    fileprivate var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate var faceBegin: CGPoint {
        return CGPoint(x: faceCenter.x - faceSide / 2, y: faceCenter.y - faceSide / 2)
    }
    
    fileprivate struct Ratios {
        static let FaceSideToEyeOffset: CGFloat = 5.5
        static let FaceSideToEyeRadius: CGFloat = 10
        static let FaceSideToEyePupil: CGFloat = 50
        static let FaceSideToMouthWidth: CGFloat = 2
        static let FaceSideToMouthHeight: CGFloat = 8
        static let FaceSideToMouthOffset: CGFloat = 6
        static let FaceSideToBrowOffset: CGFloat = 7
    }
    
    fileprivate enum Eye {
        case left
        case right
    }
    
    fileprivate func pathForCircleCenteredAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
            let path = UIBezierPath(
                arcCenter: midPoint,
                radius: radius,
                startAngle: 0.0,
                endAngle: CGFloat(2*M_PI),
                clockwise: false
            )
            path.lineWidth = lineWidth
            return path
    }
    
    fileprivate func pathForSquare(_ midPoint: CGPoint, withSide side: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(rect: CGRect(x: midPoint.x, y: midPoint.y, width: side, height: side))
        path.lineWidth = 2*lineWidth
        return path
    }
    
    fileprivate func getEyeCenter(_ eye: Eye) -> CGPoint {
        let eyeOffset = faceSide / Ratios.FaceSideToEyeOffset
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .left: eyeCenter.x -= eyeOffset
        case .right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    fileprivate func pathForEye(_ eye: Eye) -> UIBezierPath {
        let eyeRadius = faceSide / Ratios.FaceSideToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        if eyesOpen {
            return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }

    fileprivate func pathForEyePupil(_ eye: Eye) -> UIBezierPath {
        var eyePupil = getEyeCenter(eye)
        let eyeRadius = faceSide / Ratios.FaceSideToEyeRadius
        let eyeLook = CGFloat(max(-1, min(eyePupilLocation, 1))) * eyeRadius * 0.75
        eyePupil.x += eyeLook
        let eyePupilRadius = faceSide / Ratios.FaceSideToEyePupil
        colorPupil.setFill()
        return pathForCircleCenteredAtPoint(eyePupil, withRadius: eyePupilRadius)
    
    }
    
    fileprivate func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = faceSide / Ratios.FaceSideToMouthWidth
        let mouthHeight = faceSide / Ratios.FaceSideToMouthHeight
        let mouthOffset = faceSide / Ratios.FaceSideToMouthOffset
        
        let mouthRect = CGRect(x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthWidth / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthWidth / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
        
    }
    
    fileprivate func pathForBrow(_ eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .left: tilt *= -1.0
        case .right: break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= faceSide / Ratios.FaceSideToBrowOffset
        let eyeRadius = faceSide / Ratios.FaceSideToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius/4
        let browStart = CGPoint (x:browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y:browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect)
    {
        color.setStroke()
        colorFace.setFill()
        let robotFace = pathForSquare(faceBegin, withSide: faceSide)
        robotFace.stroke()
        robotFace.fill()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        if eyesOpen {
            pathForEyePupil(.left).stroke()
            pathForEyePupil(.left).fill()
            pathForEyePupil(.right).stroke()
            pathForEyePupil(.right).fill()
        }
        pathForMouth().stroke()
        pathForBrow(.left).stroke()
        pathForBrow(.right).stroke()
    }
}
