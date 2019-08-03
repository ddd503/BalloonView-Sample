//
//  BalloonView.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/07/29.
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

    var expandLength: (width: CGFloat, height: CGFloat) {
        // 方向別に吹き出しの外枠のサイズを拡張したいときは、分岐を書く
        return (30, 30)
    }

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
}

final class BalloonView: UIView {
    // 三角部分の幅
    private let triangleBottomLength: CGFloat
    // 三角部分の高さ
    private let triangleHeight: CGFloat
    // 吹き出しの色
    private let color: UIColor
    // 吹き出しの内容が入るView
    private let innerView: UIView
    // 吹き出すを出す方向
    private let directionType: BalloonViewDirectionType
    // 中身のViewサイズと比較して拡張する吹き出しの幅
    static private let expandWidth: CGFloat = 30
    // 中身のViewサイズと比較して拡張する吹き出しの高さ
    static private let expandHeight: CGFloat = 30

    /// 吹き出しのイニシャライズ
    ///
    /// - Parameters:
    ///   - focusPoint: 吹き出しが出る地点(三角形の頂点)
    ///   - contentView: 吹き出しの中に入れたいView（今回は長方形のUILabelを渡しています）
    ///   - color: 吹き出しの色
    ///   - directionType: 吹き出すを出す方向
    ///   - triangleBottomLength: 三角形部分の幅
    ///   - triangleHeight: 三角形部分の高さ
    init(focusPoint: CGPoint, contentView: UIView,
         color: UIColor, directionType: BalloonViewDirectionType,
         triangleBottomLength: CGFloat = 25, triangleHeight: CGFloat = 20) {
        self.color = color
        self.directionType = directionType
        self.triangleBottomLength = triangleBottomLength
        self.triangleHeight = triangleHeight

        let viewSize = directionType.viewSize(contentViewSize: contentView.frame.size, triangleHeight: triangleHeight)
        let viewOrigin = BalloonView.viewOrigin(balloonDirection: directionType, viewSize: viewSize, focusPoint: focusPoint)
        let viewFrame = CGRect(origin: viewOrigin, size: viewSize)

        self.innerView = UIView(frame: BalloonView.getInnerViewFrame(balloonDirection: directionType,
                                                                     parentViewFrame: viewFrame,
                                                                     triangleHeight: triangleHeight))

        super.init(frame: CGRect(origin: viewOrigin, size: viewSize))

        // BalloonView自体の背景を透明に（吹き出しのみを見せるため）
        backgroundColor = .clear
        // 吹き出し内容Viewを設定
        innerView.backgroundColor = self.color
        addSubview(innerView)
        innerView.layer.masksToBounds = true
        innerView.layer.cornerRadius = 10
        innerView.addSubview(contentView)
        contentView.center = self.convert(innerView.center, to: innerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            // UIGraphicsGetCurrentContextを用意できない場合は吹き出しは描画しない
            return
        }
        contextBalloonPath(context: context, rect: rect)
    }

    /// BalloonViewのOriginを取得する
    ///
    /// - Parameters:
    ///   - balloonDirection: 吹き出しを出す方向
    ///   - viewSize: BalloonViewのサイズ
    ///   - focusPoint: 吹き出しが出る地点
    /// - Returns: BalloonView自体のOrigin
    static private func viewOrigin(balloonDirection: BalloonViewDirectionType,
                                   viewSize: CGSize,
                                   focusPoint: CGPoint) -> CGPoint {
        let origin: CGPoint

        switch balloonDirection {
        case .up:
            origin = CGPoint(x: focusPoint.x - viewSize.width / 2, y: focusPoint.y - viewSize.height)
        case .under:
            origin = CGPoint(x: focusPoint.x - viewSize.width / 2, y: focusPoint.y)
        case .right:
            origin = CGPoint(x: focusPoint.x, y: focusPoint.y - (viewSize.height / 2))
        case .left:
            origin = CGPoint(x: focusPoint.x - viewSize.width, y: focusPoint.y - (viewSize.height / 2))
        case .upperRight:
            origin = CGPoint(x: focusPoint.x, y: focusPoint.y - viewSize.height)
        case .lowerRight:
            origin = focusPoint
        case .upperLeft:
            origin = CGPoint(x: focusPoint.x - viewSize.width, y: focusPoint.y - viewSize.height)
        case .lowerLeft:
            origin = CGPoint(x: focusPoint.x - viewSize.width, y: focusPoint.y)
        }

        return origin
    }

    /// 吹き出し部分のViewのframeを取得する
    ///
    /// - Parameters:
    ///   - balloonDirection: 吹き出しを出す方向
    ///   - parentViewFrame: BalloonView自体のframe
    ///   - triangleHeight: 三角形の高さ
    /// - Returns: 吹き出し内のコンテンツ部分のViewのframe
    static private func getInnerViewFrame(balloonDirection: BalloonViewDirectionType,
                                          parentViewFrame: CGRect,
                                          triangleHeight: CGFloat) -> CGRect {
        switch balloonDirection {
        case .up:
            return CGRect(origin: .zero,
                          size: CGSize(width: parentViewFrame.size.width,
                                       height: parentViewFrame.size.height - triangleHeight))
        case .under:
            return CGRect(origin: CGPoint(x: .zero, y: triangleHeight),
                          size: CGSize(width: parentViewFrame.size.width,
                                       height: parentViewFrame.size.height - triangleHeight))
        case .right:
            return CGRect(origin: CGPoint(x: triangleHeight, y: .zero),
                          size: CGSize(width: parentViewFrame.size.width - triangleHeight,
                                       height: parentViewFrame.size.height))
        case .left:
            return CGRect(origin: .zero,
                          size: CGSize(width: parentViewFrame.size.width - triangleHeight,
                                       height: parentViewFrame.size.height))
        case .upperRight:
            return CGRect(origin: .zero,
                          size: CGSize(width: parentViewFrame.width,
                                       height: parentViewFrame.height - triangleHeight))
        case .lowerRight:
            return CGRect(origin: CGPoint(x: .zero, y: triangleHeight),
                          size: CGSize(width: parentViewFrame.width,
                                       height: parentViewFrame.height - triangleHeight))
        case .upperLeft:
            return CGRect(origin: .zero,
                          size: CGSize(width: parentViewFrame.width,
                                       height: parentViewFrame.height - triangleHeight))
        case .lowerLeft:
            return CGRect(origin: CGPoint(x: .zero, y: triangleHeight),
                          size: CGSize(width: parentViewFrame.width,
                                       height: parentViewFrame.height - triangleHeight))
        }
    }

    /// 吹き出しの三角形部分を描画する
    ///
    /// - Parameters:
    ///   - context: UIGraphicsGetCurrentContext
    ///   - rect: BalloonView自体のFrame
    func contextBalloonPath(context: CGContext, rect: CGRect) {
        // 三角部分の色
        context.setFillColor(color.cgColor)
        // 三角形の各頂点を取得
        let cornerPoints = triangleCornerPoints(directionType: directionType,
                                                parentViewRect: rect,
                                                triangleBottomLength: triangleBottomLength,
                                                triangleHeight: triangleHeight)
        // 開始点を指定
        context.move(to: cornerPoints.top)
        // 移動点から二点以上指定して線を引かないと領域の確保がされずに短形は描画されない
        context.addLine(to: cornerPoints.left)
        context.addLine(to: cornerPoints.right)
        // 描画開始
        context.fillPath()
    }

    /// 三角形の各頂点を決定する
    ///
    /// - Parameters:
    ///   - directionType: 吹き出しを出す方向
    ///   - parentViewRect: BalloonView自体のframe
    ///   - triangleBottomLength: 三角形の底辺の長さ
    ///   - triangleHeight: 三角形の高さ
    /// - Returns: 各定点の座標
    private func triangleCornerPoints(directionType: BalloonViewDirectionType,
                                      parentViewRect: CGRect,
                                      triangleBottomLength: CGFloat,
                                      triangleHeight: CGFloat) -> (top: CGPoint, left: CGPoint, right: CGPoint) {
        switch directionType {
        case .up:
            let top = CGPoint(x: parentViewRect.size.width / 2,
                              y: parentViewRect.size.height)
            let left = CGPoint(x: top.x - (triangleBottomLength / 2), y: top.y - triangleHeight)
            let right = CGPoint(x: top.x + (triangleBottomLength / 2), y: left.y)
            return (top, left, right)
        case .under:
            let top = CGPoint(x: parentViewRect.size.width / 2,
                              y: .zero)
            let left = CGPoint(x: top.x - (triangleBottomLength / 2), y: top.y + triangleHeight)
            let right = CGPoint(x: top.x + (triangleBottomLength / 2), y: left.y)
            return (top, left, right)
        case .right:
            let top = CGPoint(x: .zero,
                              y: parentViewRect.size.height / 2)
            let left = CGPoint(x: top.x + triangleHeight,
                               y: top.y - (triangleBottomLength / 2))
            let right = CGPoint(x: left.x,
                                y: top.y + (triangleBottomLength / 2))
            return (top, left, right)
        case .left:
            let top = CGPoint(x: parentViewRect.size.width,
                              y: parentViewRect.size.height / 2)
            let left = CGPoint(x: top.x - triangleHeight,
                               y: top.y - (triangleBottomLength / 2))
            let right = CGPoint(x: left.x,
                                y: top.y + (triangleBottomLength / 2))
            return (top, left, right)
        case .upperRight:
            let top = CGPoint(x: parentViewRect.origin.x, y: parentViewRect.size.height)
            let left = CGPoint(x: top.x + (parentViewRect.size.width * 0.2 - (triangleBottomLength / 2)),
                               y: top.y - triangleHeight)
            let right = CGPoint(x: top.x + (parentViewRect.size.width * 0.2 + (triangleBottomLength / 2)),
                                y: left.y)
            return (top, left, right)
        case .lowerRight:
            let top = parentViewRect.origin
            let left = CGPoint(x: top.x + (parentViewRect.size.width * 0.2 - (triangleBottomLength / 2)),
                               y: top.y + triangleHeight)
            let right = CGPoint(x: top.x + (parentViewRect.size.width * 0.2 + (triangleBottomLength / 2)),
                                y: left.y)
            return (top, left, right)
        case .upperLeft:
            let top = CGPoint(x: parentViewRect.size.width, y: parentViewRect.size.height)
            let left = CGPoint(x: top.x - (parentViewRect.size.width * 0.2 - (triangleBottomLength / 2)),
                               y: top.y - triangleHeight)
            let right = CGPoint(x: top.x - (parentViewRect.size.width * 0.2 + (triangleBottomLength / 2)),
                                y: left.y)
            return (top, left, right)
        case .lowerLeft:
            let top = CGPoint(x: parentViewRect.size.width, y: .zero)
            let left = CGPoint(x: top.x - (parentViewRect.size.width * 0.2 + (triangleBottomLength / 2)),
                               y: top.y + triangleHeight)
            let right = CGPoint(x: top.x - (parentViewRect.size.width * 0.2 - (triangleBottomLength / 2)),
                                y: left.y)
            return (top, left, right)
        }
    }
}
