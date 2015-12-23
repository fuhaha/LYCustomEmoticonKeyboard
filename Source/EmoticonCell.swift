//
//  EmoticonCell.swift
//  LYCustomEmotionKeyboard
//
//  Created by 李禹 on 15/11/18.
//  Copyright © 2015年 dayu. All rights reserved.
//

import UIKit


class EmoticonCell: UICollectionViewCell {
    
    var emoticon: Emoticon? {
        didSet {
            self.emoticonView.emoticon = emoticon;
        }
    }
    
    lazy var emoticonView: EmoticonCellView = {
        let btn = EmoticonCellView(frame: self.bounds);
        btn.userInteractionEnabled = false;
        return btn;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        addSubview(emoticonView);
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        addSubview(emoticonView);
    }
}
