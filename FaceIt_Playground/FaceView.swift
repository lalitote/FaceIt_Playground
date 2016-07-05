//
//  FaceView.swift
//  FaceIt_Playground
//
//  Created by lalitote on 01.07.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    let scale: CGFloat = 0.75
    
    var mouthCurvature: Double = 1.0
    
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
        static let FaceSideToEyeOffset: CGFloat = 4.5
        static let FaceSideToEyeRadius: CGFloat = 10
        static let FaceSideToEyePupil: CGFloat = 50
        static let FaceSideToMouthWidth: CGFloat = 2
        static let FaceSideToMouthHeight: CGFloat = 8
        static let FaceSideToMouthOffset: CGFloat = 6
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
        path.lineWidth = 5.0
        return path
    }
    
    private func pathForSquare(midPoint: CGPoint, withSide side: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(rect: CGRect(x: midPoint.x, y: midPoint.y, width: side, height: side))
        path.lineWidth = 15.0
        UIColor.grayColor().setStroke()
        UIColor.yellowColor().setFill()
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
        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
    }

    private func pathForEyePupil(eye: Eye) -> UIBezierPath {
        var eyePupil = getEyeCenter(eye)
        let eyeRadius = faceSide / Ratios.FaceSideToEyeRadius
        let eyePupilLocation = CGFloat(max(-1, min(mouthCurvature, 1))) * eyeRadius * scale
        eyePupil.x += eyePupilLocation
        let eyePupilRadius = faceSide / Ratios.FaceSideToEyePupil
        UIColor.grayColor().setFill()
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
        path.lineWidth = 5.0
        
        return path
        
    }
    
    override func drawRect(rect: CGRect)
    {
        let robotFace = pathForSquare(faceBegin, withSide: faceSide)
        robotFace.stroke()
        robotFace.fill()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForEyePupil(.Left).stroke()
        pathForEyePupil(.Left).fill()
        pathForEyePupil(.Right).stroke()
        pathForEyePupil(.Right).fill()
        pathForMouth().stroke()
        
        
    }

}
