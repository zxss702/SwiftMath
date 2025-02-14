//
//  ByZhiyang.swift
//  SwiftMath
//
//  Created by 开发者 on 2025/2/14.
//

import Foundation
import CoreGraphics

public func getLaTeXSize(
    latex: String,
    font: MTFont,
    color: MTColor,
    currentStyle:MTLineStyle
) -> CGSize {
    var error : NSError? = nil
    let mathList = MTMathListBuilder.build(fromString: latex, error: &error)
    if error == nil {
        let displayList = MTTypesetter.createLineForMathList(mathList, font: font, style: currentStyle)
        return CGSize(width: displayList!.width, height: displayList!.ascent + displayList!.descent)
    } else {
        return CGSize(width: 150, height: 50)
    }
}

public extension CGContext {
    dynamic func draw(
        latex: String,
        font: MTFont,
        color: MTColor,
        currentStyle:MTLineStyle,
        textAlignment: MTTextAlignment,
        boundsIn: CGRect
    ) {
        var error : NSError? = nil
        let mathList = MTMathListBuilder.build(fromString: latex, error: &error)
        if error == nil {
            let displayList = MTTypesetter.createLineForMathList(mathList, font: font, style: currentStyle)
            
            displayList!.textColor = color
            
            var textX = CGFloat(0)
            switch textAlignment {
            case .left: textX = boundsIn.minX
            case .center: textX = boundsIn.midX - displayList!.width / 2
            case .right:  textX = boundsIn.maxX - displayList!.width
            }
            
            // center things vertically
            var height = displayList!.ascent + displayList!.descent
            if height < font.fontSize / 2 {
                height = font.fontSize / 2  // set height to half the font size
            }
            let textY = (boundsIn.height - height) / 2 + displayList!.descent
            displayList!.position = CGPoint(x: textX, y: textY)
            
            let context = MTGraphicsGetCurrentContext()!
            context.saveGState()
            displayList!.draw(context)
            context.restoreGState()
        }
    }
}
