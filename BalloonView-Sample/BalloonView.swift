//
//  BalloonView.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/07/29.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class BalloonView: UIView {
    // 三角部分の幅
    let triangleBottomLength: CGFloat
    // 三角部分の高さ
    let triangleHeight: CGFloat

    init(frame: CGRect, triangleBottomLength: CGFloat = 30, triangleHeight: CGFloat = 20) {
        self.triangleBottomLength = triangleBottomLength
        self.triangleHeight = triangleHeight
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.red.cgColor)
        contextBalloonPath(context: context, rect: rect)
    }

    func contextBalloonPath(context: CGContext, rect: CGRect) {
        let leftEndPoint = CGPoint(x: rect.size.width / 2 - (triangleBottomLength / 2), y: rect.size.height - triangleHeight)
        let rightEndPoint = CGPoint(x: leftEndPoint.x + triangleBottomLength, y: rect.size.height - triangleHeight)
        let tipCornerPoint = CGPoint(x: rect.size.width / 2, y: rect.maxY)

        // 塗りつぶし
        context.addRect(CGRect(x: rect.origin.x,
                               y: rect.origin.y,
                               width: rect.size.width,
                               height: rect.size.height - triangleHeight))
        context.move(to: leftEndPoint)
        context.addLine(to: rightEndPoint)
        context.addLine(to: tipCornerPoint)
        context.fillPath()
    }
}
