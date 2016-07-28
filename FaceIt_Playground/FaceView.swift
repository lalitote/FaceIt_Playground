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
    var color: UIColor = UIColor.grayColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var colorFace: UIColor = UIColor.yellowColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var colorPupil: UIColor = UIColor.grayColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed,.Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var faceSide: CGFloat {
        return min(bounds.size.width, bounds.size.height) * scale
    }
    private var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var faceBegin: CGPoint {
        return CGPoint(x: faceCenter.x - faceSide / 2, y: faceCenter.y - faceSide / 2)
    }
    
    private struct Ratios {
        static let FaceSideToEyeOffset: CGFloat = 5.5
        static let FaceSideToEyeRadius: CGFloat = 10
        static let FaceSideToEyePupil: CGFloat = 50
        static let FaceSideToMouthWidth: CGFloat = 2
        static let FaceSideToMouthHeight: CGFloat = 8
        static let FaceSideToMouthOffset: CGFloat = 6
        static let FaceSideToBrowOffset: CGFloat = 7
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
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
    
    private func pathForSquare(midPoint: CGPoint, withSide side: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(rect: CGRect(x: midPoint.x, y: midPoint.y, width: side, height: side))
        path.lineWidth = 2*lineWidth
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = faceSide / Ratios.FaceSideToEyeOffset
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = faceSide / Ratios.FaceSideToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        if eyesOpen {
            return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLineToPoint(CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }

    private func pathForEyePupil(eye: Eye) -> UIBezierPath {
        var eyePupil = getEyeCenter(eye)
        let eyeRadius = faceSide / Ratios.FaceSideToEyeRadius
        let eyeLook = CGFloat(max(-1, min(eyePupilLocation, 1))) * eyeRadius * 0.75
        eyePupil.x += eyeLook
        let eyePupilRadius = faceSide / Ratios.FaceSideToEyePupil
        colorPupil.setFill()
        return pathForCircleCenteredAtPoint(eyePupil, withRadius: eyePupilRadius)
    
    }
    
    private func pathForMouth() -> UIBezierPath
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
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
        
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .Left: tilt *= -1.0
        case .Right: break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= faceSide / Ratios.FaceSideToBrowOffset
        let eyeRadius = faceSide / Ratios.FaceSideToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius/4
        let browStart = CGPoint (x:browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y:browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect)
    {
        color.setStroke()
        colorFace.setFill()
        let robotFace = pathForSquare(faceBegin, withSide: faceSide)
        robotFace.stroke()
        robotFace.fill()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        if eyesOpen {
            pathForEyePupil(.Left).stroke()
            pathForEyePupil(.Left).fill()
            pathForEyePupil(.Right).stroke()
            pathForEyePupil(.Right).fill()
        }
        pathForMouth().stroke()
        pathForBrow(.Left).stroke()
        pathForBrow(.Right).stroke()
    }
}
