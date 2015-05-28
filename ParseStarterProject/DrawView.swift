//
//  DrawView.swift
//  BadDrawing
//
//  Created by Li-Wei Tseng on 5/25/15.
//  Copyright (c) 2015 liwei. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var lines =  [Line]()
    var lastPoint: CGPoint!
    var drawColor = UIColor.blackColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        lastPoint = (touches.first as! UITouch).locationInView(self)
       // println("touches began")
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var newPoint = (touches.first as! UITouch).locationInView(self)
        lines.append(Line(start: lastPoint, end: newPoint, color: drawColor))
        lastPoint = newPoint
      //  println("touches moved")
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, 5)

        for line in lines {
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, line.startX, line.startY)
            CGContextAddLineToPoint(context, line.endX, line.endY)
            CGContextSetStrokeColorWithColor(context, line.color.CGColor)
            CGContextStrokePath(context)
        }
        
    }
}
