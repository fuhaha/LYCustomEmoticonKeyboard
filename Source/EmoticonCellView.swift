//
//  EmoticonCellView.swift
//  LYCustomEmotionKeyboard
//
//  Created by 李禹 on 15/11/30.
//  Copyright © 2015年 dayu. All rights reserved.
//

import UIKit

class EmoticonCellView: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.adjustsImageWhenHighlighted = false;
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.adjustsImageWhenHighlighted = false;
    }

    var emoticon: Emoticon? {
        didSet {
            if emoticon!.isDeleteBtn {
                var image = UIImage(named: emoticon!.png!);
                if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 7.0) {
                    image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
                }
                self.setImage(image, forState: UIControlState.Normal);
                self.setTitle(nil, forState: UIControlState.Normal);
            }else if let name = emoticon!.png {
                UIView.setAnimationsEnabled(false);
                
               let bundlePath = (NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil) as NSString!);
                let path = (bundlePath.stringByAppendingPathComponent(emoticon!.emoticon_group_path!) as NSString).stringByAppendingPathComponent(name);
                
                var image = UIImage(contentsOfFile: path);
                if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 7.0) {
                    image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
                }

                self.setImage(image, forState: UIControlState.Normal);
                self.setTitle(nil, forState: UIControlState.Normal);
                
                let delayInSeconds = 0.1;
                let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                    UIView.setAnimationsEnabled(true);
                }

            }else if let emoji = emoticon!.emoji {
                UIView.setAnimationsEnabled(false);
                self.titleLabel!.font = UIFont.systemFontOfSize(32)
                self.setTitle(emoji, forState: UIControlState.Normal);
                self.setImage(nil, forState: UIControlState.Normal);
                let delayInSeconds = 0.1;
                let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                    UIView.setAnimationsEnabled(true);
                }
            }

        }
    }

}
