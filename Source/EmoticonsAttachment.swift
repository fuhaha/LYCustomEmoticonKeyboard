//
//  EmoticonsAttachment.swift
//  LYCustomEmotionKeyboard
//
//  Created by 李禹 on 15/11/26.
//  Copyright © 2015年 dayu. All rights reserved.
//

import UIKit

class EmoticonsAttachment: NSTextAttachment {

    var emoticon: Emoticon!;
    
    class func emoticonString(emo: Emoticon, height: CGFloat) -> NSAttributedString {
        let attachment = EmoticonsAttachment();
        let bundlePath =  (NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil) as NSString!);

        let name = (bundlePath.stringByAppendingPathComponent(emo.emoticon_group_path!) as NSString).stringByAppendingPathComponent(emo.png!);
        attachment.emoticon = emo;
        let image = UIImage(named: name)
        attachment.image = image;
        attachment.bounds = CGRectMake(0, -4, height, height);
        let attributedStr = NSAttributedString(attachment: attachment);
        return attributedStr;
    }
}
