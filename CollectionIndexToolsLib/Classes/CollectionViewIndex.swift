//
//  CollectionViewIndex.swift
//  CollectionIndexTools
//
//  Created by StevenXie on 16/7/22.
//  Copyright © 2016年 StevenXie. All rights reserved.
//

import UIKit


func floor(_ x: CGFloat, scale: CGFloat) -> CGFloat {
    return floor(x * scale) / scale
}


func round(_ x: CGFloat, scale: CGFloat) -> CGFloat {
    return round(x * scale) / scale
}


func ceil(_ x: CGFloat, scale: CGFloat) -> CGFloat {
    return ceil(x * scale) / scale
}


func floorOdd(_ x: Int) -> Int {
    return x % 2 == 1 ? x : x - 1
}

open class CollectionViewIndex: UIControl {
    
    open var indexTitles = [String]() {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    var _selectedIndex: Int?
    open var selectedIndex: Int {
        return _selectedIndex ?? 0
    }
    
    let font = UIFont.boldSystemFont(ofSize: 14)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 0.9)
        contentMode = .redraw
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }
    
    enum IndexEntry {
        case text(String)
        case bullet
    }
    
    var titleHeight: CGFloat {
        return font.lineHeight
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let maxNumberOfIndexTitles = Int(floor(bounds.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        var indexEntries = [IndexEntry]()
        if indexTitles.count <= maxNumberOfIndexTitles {
            indexEntries = indexTitles.map { .text($0) }
        } else {
            let numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
            
            indexEntries.append(.text(indexTitles[0]))
            
            for i in 1...(numberOfIndexTitles / 2) {
                indexEntries.append(.bullet)
                
                let index = Int(round(Float(i) / (Float(numberOfIndexTitles / 2)) * Float(indexTitles.count - 1)))
                indexEntries.append(.text(indexTitles[index]))
            }
        }
        
        let totalHeight = titleHeight * CGFloat(indexEntries.count)
        
        let context = UIGraphicsGetCurrentContext()
        tintColor.setFill()
        
        var y = (bounds.height - totalHeight) / 2
        for indexEntry in indexEntries {
            switch indexEntry {
            case .text(let indexTitle):
                let CATextLayer = attributedStringForTitle(indexTitle)
                let width = CATextLayer.size().width
                let x = round((bounds.width - width) / 2, scale: contentScaleFactor)
                CATextLayer.draw(in: CGRect(x: x, y: round(y, scale: contentScaleFactor), width: width, height: titleHeight))
            case .bullet:
                let diameter: CGFloat = 6
                let x = round((bounds.width - diameter) / 2, scale: contentScaleFactor)
                let top = round(y + (titleHeight - diameter) / 2, scale: contentScaleFactor)
                context?.fillEllipse(in: CGRect(x: x, y: top, width: diameter, height: diameter))
            }
            
            y += titleHeight
        }
    }
    
    func attributedStringForTitle(_ title: String) -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.gray])
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        let selectedIndex = indexForTouch(touch)
        if _selectedIndex != selectedIndex {
            _selectedIndex = selectedIndex
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let selectedIndex = indexForTouch(touch)
        if _selectedIndex != selectedIndex {
            _selectedIndex = selectedIndex
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    func indexForTouch(_ touch: UITouch) -> Int {
        let maxNumberOfIndexTitles = Int(floor(bounds.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        let numberOfIndexTitles: Int
        if indexTitles.count <= maxNumberOfIndexTitles {
            numberOfIndexTitles = indexTitles.count
        } else {
            numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
        }
        
        let totalHeight = titleHeight * CGFloat(numberOfIndexTitles)
        
        let location = touch.location(in: self)
        
        let index = Int((location.y - (bounds.height - totalHeight) / 2) / totalHeight * CGFloat(indexTitles.count))
        return max(0, min(indexTitles.count - 1, index))
    }
    
    open var preferredMaxLayoutHeight: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize : CGSize {
        return sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: preferredMaxLayoutHeight))
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxNumberOfIndexTitles = Int(floor(size.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        var indexEntries = [IndexEntry]()
        if indexTitles.count <= maxNumberOfIndexTitles {
            indexEntries = indexTitles.map { .text($0) }
        } else {
            let numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
            
            indexEntries.append(.text(indexTitles[0]))
            
            for i in 1...(numberOfIndexTitles / 2) {
                indexEntries.append(.bullet)
                
                let index = Int(round(Float(i) / (Float(numberOfIndexTitles / 2)) * Float(indexTitles.count - 1)))
                indexEntries.append(.text(indexTitles[index]))
            }
        }
        
        let width: CGFloat = indexEntries.reduce(0, { width, indexEntry in
            switch indexEntry {
            case .text(let indexTitle):
                return max(width, self.attributedStringForTitle(indexTitle).size().width)
            case .bullet:
                return width
            }
        })
        
        return CGSize(width: max(15, width + 4), height: size.height)
    }

}
