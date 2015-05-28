//
//  Line.swift
//  BadDrawing
//
//  Created by Li-Wei Tseng on 5/25/15.
//  Copyright (c) 2015 liwei. All rights reserved.
//

import UIKit

class Line {
    var start: CGPoint
    var end: CGPoint
    var color: UIColor
    
    var startX: CGFloat {
        get{
            return start.x
        }
    }
    
    var startY: CGFloat {
        get{
            return start.y
        }
    }
    
    var endX: CGFloat {
        get{
            return end.x
        }
    }
    
    var endY: CGFloat {
        get{
            return end.y
        }
    }
    
    init(start _start: CGPoint, end _end: CGPoint, color _color: UIColor!) {
        start = _start
        end = _end
        color = _color
    }
}