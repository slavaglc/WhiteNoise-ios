//
//  CircleLayer.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 22.04.2022.
//
//
//import UIKit
//
//
//final class Circle: UIView {
//    override func draw(_ rect: CGRect) {
//        drawRingFittingInsideView()
//    }
//    
//    internal func drawRingFittingInsideView() -> () {
//        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
//        let desiredLineWidth:CGFloat = 1 // your desired value
//            
//        let circlePath = UIBezierPath(
//                arcCenter: CGPoint(x:halfSize,y:halfSize),
//                radius: CGFloat( halfSize - (desiredLineWidth/2) ),
//                startAngle: CGFloat(0),
//                endAngle:CGFloat(Float.pi * 2),
//                clockwise: true)
//    
//         let shapeLayer = CAShapeLayer()
//        shapeLayer.path = circlePath.cgPath
//            
//        shapeLayer.fillColor = #colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor
//        shapeLayer.strokeColor = #colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor
//         shapeLayer.lineWidth = desiredLineWidth
//    
//         layer.addSublayer(shapeLayer)
//     }
//}
