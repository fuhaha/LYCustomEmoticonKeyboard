
//
//  EmoticonsTextView.swift
//  LYCustomEmotionKeyboard
//
//  Created by 李禹 on 15/11/25.
//  Copyright © 2015年 dayu. All rights reserved.
//

import UIKit

public class EmoticonsTextView: UITextView {
    
    public func insertEmoticon(emo: Emoticon) {
        if let _ = emo.chs {
            let attrStr = EmoticonsAttachment.emoticonString(emo, height: font!.lineHeight);
            let textStr = NSMutableAttributedString(attributedString: self.attributedText);
            textStr.replaceCharactersInRange(selectedRange, withAttributedString: attrStr);
            //重新添加整个文本的属性
            textStr.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, textStr.length));
            
            let range = selectedRange;
            attributedText = textStr;
            selectedRange = NSMakeRange(range.location+1, 0);
            
        }else if let emoji = emo.emoji {
            replaceRange(selectedTextRange!, withText: emoji);
        }else if emo.isDeleteBtn {
            self.deleteBackward();
        }
    }
    
    public func fullText() -> String {
        let text = self.attributedText;
        var strM = String();
        text.enumerateAttributesInRange(NSMakeRange(0, text.length), options: NSAttributedStringEnumerationOptions()) { (dict, range, _) -> Void in
            if let attachment = (dict["NSAttachment"] as? EmoticonsAttachment) {
                let str = attachment.emoticon.chs!;
                strM += str;
            }else {
                let str = (text.string as NSString).substringWithRange(range);
                strM += str;
            }
        }
        return strM;
    }
    
    
}
