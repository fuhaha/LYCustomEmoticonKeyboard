//
//  EmoticonPopView.swift
//  LYCustomEmotionKeyboard
//
//  Created by 李禹 on 15/11/30.
//  Copyright © 2015年 dayu. All rights reserved.
//

import UIKit

class EmoticonPopView: UIView {
    
    @IBOutlet weak var emoticonView: EmoticonCellView!
    
    class func popView() -> EmoticonPopView {
        return NSBundle.mainBundle().loadNibNamed("EmoticonPopView", owner: nil, options: nil).last as! EmoticonPopView;
    }
    
    func showFromEmoticonView(fromEmoticonView: EmoticonCell) {
        let emo = fromEmoticonView.emoticon
        print(emo!.emoticon_group_name);
        print(emo!.emoticon_group_path);
        self.emoticonView.emoticon = fromEmoticonView.emoticon;
        let window = UIApplication.sharedApplication().windows.last as UIWindow!;
        window.addSubview(self);
        
        let centerX = fromEmoticonView.center.x;
        let centerY = fromEmoticonView.center.y - self.frame.size.height*0.5;
        let center = CGPointMake(centerX, centerY);
        self.center = window.convertPoint(center, fromView: fromEmoticonView.superview);
    }
    
    func dismiss() {
        self.removeFromSuperview();
    }

    /**
    *  当一个控件显示之前会调用一次（如果控件在显示之前没有尺寸，不会调用这个方法）
    *
    *  @param rect 控件的bounds
    */
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
        UIImage(named: "emoticon_keyboard_magnifier")?.drawInRect(rect);
    }
}
