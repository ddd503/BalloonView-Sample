//
//  BalloonViewDirectionType.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/08/03.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

// 指定位置から吹き出しを表示する方向
enum BalloonViewDirectionType {
    case up
    case under
    case right
    case left
    case upperRight
    case lowerRight
    case upperLeft
    case lowerLeft

    // 吹き出しの外枠と中身のViewとのinset用
    var expandLength: (width: CGFloat, height: CGFloat) {
        // 方向別に吹き出しの外枠のサイズを拡張したいときは、分岐を書く
        return (30, 30)
    }

    /// BalloonView(長方形&三角形を含む)のサイズを返す
    ///
    /// - Parameters:
    ///   - contentViewSize: 吹き出し内に入れたいViewのサイズ
    ///   - triangleHeight: 三角形部分(吹き出し)の高さ
    /// - Returns: BalloonViewのサイズ
    func viewSize(contentViewSize: CGSize, triangleHeight: CGFloat) -> CGSize {
        switch self {
        case .up, .under, .upperRight, .lowerRight, .upperLeft, .lowerLeft:
            return CGSize(width: contentViewSize.width + expandLength.width,
                          height: contentViewSize.height + expandLength.height + triangleHeight)
        case .right, .left:
            return CGSize(width: contentViewSize.width + expandLength.width + triangleHeight,
                          height: contentViewSize.height + expandLength.height)
        }
    }

    /// BalloonView(長方形&三角形を含む)のOriginを返す
    ///
    /// - Parameters:
    ///   - focusPoint: 吹き出しが出る地点
    ///   - viewSize: BalloonViewのサイズ
    /// - Returns: BalloonViewのOrigin
    func viewOrigin(focusPoint: CGPoint, viewSize: CGSize) -> CGPoint {
        switch self {
        case .up:
            return CGPoint(x: focusPoint.x - viewSize.width / 2, y: focusPoint.y - viewSize.height)
        case .under:
            return CGPoint(x: focusPoint.x - viewSize.width / 2, y: focusPoint.y)
        case .right:
            return CGPoint(x: focusPoint.x, y: focusPoint.y - (viewSize.height / 2))
        case .left:
            return CGPoint(x: focusPoint.x - viewSize.width, y: focusPoint.y - (viewSize.height / 2))
        case .upperRight:
            return CGPoint(x: focusPoint.x, y: focusPoint.y - viewSize.height)
        case .lowerRight:
            return focusPoint
        case .upperLeft:
            return CGPoint(x: focusPoint.x - viewSize.width, y: focusPoint.y - viewSize.height)
        case .lowerLeft:
            return CGPoint(x: focusPoint.x - viewSize.width, y: focusPoint.y)
        }
    }

    /// 吹き出し内容描画用Viewのサイズを返す
    ///
    /// - Parameters:
    ///   - superViewFrame: BalloonViewのframe
    ///   - triangleHeight: 三角形部分(吹き出し)の高さ
    /// - Returns: 吹き出し内容描画用Viewのサイズ
    func innerViewSize(superViewFrame: CGRect, triangleHeight: CGFloat) -> CGSize {
        switch self {
        case .up, .under:
            return CGSize(width: superViewFrame.size.width, height: superViewFrame.size.height - triangleHeight)
        case .right, .left:
            return CGSize(width: superViewFrame.size.width - triangleHeight, height: superViewFrame.size.height)
        case .upperRight, .lowerRight, .upperLeft, .lowerLeft:
            return CGSize(width: superViewFrame.width, height: superViewFrame.height - triangleHeight)
        }
    }

    /// 吹き出し内容描画用ViewのOriginを返す
    ///
    /// - Parameter triangleHeight: 三角形部分(吹き出し)の高さ
    /// - Returns: 吹き出し内容描画用ViewのOrigin
    func innerViewOrigin(triangleHeight: CGFloat) -> CGPoint {
        switch self {
        case .up, .left, .upperRight, .upperLeft:
            return .zero
        case .under:
            return CGPoint(x: .zero, y: triangleHeight)
        case .right:
            return CGPoint(x: triangleHeight, y: .zero)
        case .lowerRight, .lowerLeft:
            return CGPoint(x: .zero, y: triangleHeight)
        }
    }

    /// 三角形部分(吹き出し)描画用の頂点(3つ)の座標を返す
    ///
    /// - Parameters:
    ///   - superViewRect: BalloonViewのframe
    ///   - triangleBottomLength: 三角形の底辺の長さ
    ///   - triangleHeight: 三角形の高さ
    /// - Returns: 三角形部分(吹き出し)描画用の頂点(3つ)の座標
    func triangleCornerPoints(superViewRect: CGRect,
                              triangleBottomLength: CGFloat,
                              triangleHeight: CGFloat) -> (top: CGPoint, left: CGPoint, right: CGPoint) {
        let top: CGPoint
        let left: CGPoint
        let right: CGPoint

        switch self {
        case .up:
            top = CGPoint(x: superViewRect.size.width / 2, y: superViewRect.size.height)
            left = CGPoint(x: top.x - (triangleBottomLength / 2), y: top.y - triangleHeight)
            right = CGPoint(x: top.x + (triangleBottomLength / 2), y: left.y)
        case .under:
            top = CGPoint(x: superViewRect.size.width / 2, y: .zero)
            left = CGPoint(x: top.x - (triangleBottomLength / 2), y: top.y + triangleHeight)
            right = CGPoint(x: top.x + (triangleBottomLength / 2), y: left.y)
        case .right:
            top = CGPoint(x: .zero, y: superViewRect.size.height / 2)
            left = CGPoint(x: top.x + triangleHeight, y: top.y - (triangleBottomLength / 2))
            right = CGPoint(x: left.x, y: top.y + (triangleBottomLength / 2))
        case .left:
            top = CGPoint(x: superViewRect.size.width, y: superViewRect.size.height / 2)
            left = CGPoint(x: top.x - triangleHeight, y: top.y - (triangleBottomLength / 2))
            right = CGPoint(x: left.x, y: top.y + (triangleBottomLength / 2))
        case .upperRight:
            top = CGPoint(x: superViewRect.origin.x, y: superViewRect.size.height)
            left = CGPoint(x: top.x + (superViewRect.size.width * 0.2 - (triangleBottomLength / 2)), y: top.y - triangleHeight)
            right = CGPoint(x: top.x + (superViewRect.size.width * 0.2 + (triangleBottomLength / 2)), y: left.y)
        case .lowerRight:
            top = superViewRect.origin
            left = CGPoint(x: top.x + (superViewRect.size.width * 0.2 - (triangleBottomLength / 2)), y: top.y + triangleHeight)
            right = CGPoint(x: top.x + (superViewRect.size.width * 0.2 + (triangleBottomLength / 2)), y: left.y)
        case .upperLeft:
            top = CGPoint(x: superViewRect.size.width, y: superViewRect.size.height)
            left = CGPoint(x: top.x - (superViewRect.size.width * 0.2 - (triangleBottomLength / 2)), y: top.y - triangleHeight)
            right = CGPoint(x: top.x - (superViewRect.size.width * 0.2 + (triangleBottomLength / 2)), y: left.y)
        case .lowerLeft:
            top = CGPoint(x: superViewRect.size.width, y: .zero)
            left = CGPoint(x: top.x - (superViewRect.size.width * 0.2 + (triangleBottomLength / 2)), y: top.y + triangleHeight)
            right = CGPoint(x: top.x - (superViewRect.size.width * 0.2 - (triangleBottomLength / 2)), y: left.y)
        }

        return (top, left, right)
    }
}
