
//
//  EmoticonsViewController.swift
//  LYCustomEmotionKeyboard
//
//  Created by 李禹 on 15/11/4.
//  Copyright © 2015年 dayu. All rights reserved.
//

import UIKit

public class EmoticonsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var delegate: EmoticonsViewControllerDelegate?;
    
    var completion: ((emo: Emoticon)-> Void)?;
    let cellIdentifier = "EmoticonsCell";
    
    lazy var popView: EmoticonPopView = {
        let popView = EmoticonPopView.popView();
        return popView;
        }();
    
    var emoticonList: [Emoticon]!;
    
    //    var dataList = [Emoticon]();
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout);
        collectionView.backgroundColor = UIColor.whiteColor();
        collectionView.pagingEnabled = true;
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier);
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        let gestureRecongnizer = UILongPressGestureRecognizer(target: self, action: "longPress:");
        collectionView.addGestureRecognizer(gestureRecongnizer);
        
        return collectionView;
        }();
    
    lazy var layout: UICollectionViewFlowLayout = {
        let margin: CGFloat = 0;
        let count: CGFloat = 7;
        let w: CGFloat = UIScreen.mainScreen().bounds.size.width/count;
        let layout = UICollectionViewFlowLayout();
        layout.itemSize = CGSizeMake(w, w);
        //        layout.sectionInset = UIEdgeInsetsMake(4, 0, 0, 0)
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal;
        return layout;
        }();
    
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar();
        
        var items = [UIBarButtonItem]();
        var index = 0;
        for title in ["最近", "默认", "emoji", "浪小花"] {
            let barButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Done, target: self, action: "emoticonTypeDidSeleted:");
            barButtonItem.tintColor = UIColor.darkGrayColor();
            barButtonItem.tag = index;
            items.append(barButtonItem);
            
            if index < 3 {
                let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: "");
                items.append(item);
            }
            index++;
        }
        
        toolBar.items = items;
        return toolBar;
        }();
    
    override public func loadView() {
        super.loadView();
        print("loadView++++++\(NSStringFromCGRect(self.view.frame))");
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        setupUI();
        print("viewDidLoad++++++\(NSStringFromCGRect(self.view.frame))");
        
        emoticonList = Emoticon.emoticonsList();
        
        self.collectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: cellIdentifier);
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        print("viewDidAppear++++++\(NSStringFromCGRect(self.view.frame))");
    }
    
    private func setupUI() {
        
        view.addSubview(collectionView);
        view.addSubview(toolBar);
        // 设置自动布局
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        toolBar.translatesAutoresizingMaskIntoConstraints = false;
        
        var cons = [NSLayoutConstraint]();
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["collectionView": collectionView]);
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["toolBar": toolBar]);
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["collectionView": collectionView, "toolBar": toolBar]);
        //
        view.addConstraints(cons)
        
    }
    
    // MARK: UICollectionDataSource
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoticonList.count;
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! EmoticonCell;
        let emo = self.emoticonList[indexPath.row];
        cell.emoticon = emo;
        return cell;
    }
    
    // MARK: UICollectinViewDelegate
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let emo = self.emoticonList[indexPath.row];
        let value = (emo.png == nil) ? emo.code : emo.png!;
        if ( value == nil || value!.isEmpty ) {
            return;
        }
        self.completion?(emo: emo);
        
        if (emo.isDeleteBtn) {
            return;
        }
        //存储最近表情
        Emoticon.addRecentEmoticon(emo);
        
        let emoCell = collectionView.cellForItemAtIndexPath(indexPath) as! EmoticonCell;
        //单独显示Emoticon
        popView.showFromEmoticonView(emoCell);
        
        let delayInSeconds = 0.5;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.popView.dismiss();
        }
        emoticonList = Emoticon.emoticonsList();
        collectionView.reloadData();
    }
    
    // MARK: Button Action
    func emoticonTypeDidSeleted(item: UIBarButtonItem) {
        
        
        let groupInfoList = Emoticon.emoticonGroupList();
        
        let groupNameInfo = ["仅显示", "默认", "Emoji", "浪小花"];
        var count = 0;
        for index in 0..<item.tag {
            var groupInfo: [String: [Emoticon]] = groupInfoList[index];
            let groupName = groupNameInfo[index];
            let emoticons = groupInfo[groupName];
            count += emoticons!.count;
        }
        var number = 0;
        for index in 0..<4 {
            var groupInfo: [String: [Emoticon]] = groupInfoList[index];
            let groupName = groupNameInfo[index];
            let emoticons = groupInfo[groupName];
            number += emoticons!.count;
        }
        
        let indexPath = NSIndexPath(forItem: count, inSection: 0);
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true);
    }
    
    // gestureRecongnizer
    static var count = 0;
    func longPress(recongnize: UILongPressGestureRecognizer) {
        let location = recongnize.locationInView(collectionView);
        
        let correctLocation = CGPointMake(location.x - collectionView.contentOffset.x, location.y);
        if (CGRectContainsPoint(collectionView.frame, correctLocation)) {
            let indexPath = collectionView.indexPathForItemAtPoint(location);
            if let idxPath = indexPath {
                let emoCell = collectionView.cellForItemAtIndexPath(idxPath) as? EmoticonCell;
                if let cell = emoCell {
                    let emo = cell.emoticon;
                    if (emo == nil || (emo!.png == nil && emo!.code == nil) || emo!.isDeleteBtn ) {
                        return;
                    }
                    popView.showFromEmoticonView(cell);
                }
            }
        }else {
            popView.dismiss();
        }
        if recongnize.state == UIGestureRecognizerState.Ended || recongnize.state == UIGestureRecognizerState.Cancelled || recongnize.state == UIGestureRecognizerState.Failed {
            popView.dismiss();
        }
    }
}

protocol EmoticonsViewControllerDelegate : NSObjectProtocol {
    func emoticonDidSeleted(emoticon: Emoticon);
}