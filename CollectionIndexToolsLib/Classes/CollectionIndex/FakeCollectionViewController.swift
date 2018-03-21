//
//  FakeCollectionViewController.swift
//  CollectionIndexTools
//
//  Created by StevenXie on 16/7/22.
//  Copyright © 2016年 StevenXie. All rights reserved.
//

import UIKit

class FakeCollectionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(collectionViewIndex)
        
        self.setupCollectionIndex()
    }
    
    func setupCollectionIndex() {
        let views: [String: AnyObject] = [
            "topLayoutGuide": topLayoutGuide,
            "bottomLayoutGuide": bottomLayoutGuide,
            "collectionViewIndex": collectionViewIndex,
            ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[collectionViewIndex]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topLayoutGuide][collectionViewIndex][bottomLayoutGuide]", options: [], metrics: nil, views: views))
    }
    
    lazy var collectionViewIndex: CollectionViewIndex = {
        let collectionViewIndex = CollectionViewIndex()
        collectionViewIndex.indexTitles = ["肺", "大", "胃", "脾", "心", "小", "膀", "肾", "包", "三", "胆", "肝", "督", "任", "冲", "带", "维", "跷", "奇"]
        collectionViewIndex.addTarget(self, action: #selector(FakeCollectionViewController.selectedIndexDidChange(_:)), for: .valueChanged)
        collectionViewIndex.translatesAutoresizingMaskIntoConstraints = false
        return collectionViewIndex
    }()
    
    func selectedIndexDidChange(_ collectionViewIndex: CollectionViewIndex) {
        title = collectionViewIndex.indexTitles[collectionViewIndex.selectedIndex]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
