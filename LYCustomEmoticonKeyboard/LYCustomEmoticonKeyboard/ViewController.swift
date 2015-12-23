//
//  ViewController.swift
//  LYCustomEmoticonKeyboard
//
//  Created by 李禹 on 15/12/23.
//  Copyright © 2015年 dayu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: EmoticonsTextView!
    
    lazy var emoticonsVC: EmoticonsViewController = {
        let emoticonsVC = EmoticonsViewController();
        emoticonsVC.completion = {
            (emo: Emoticon) in
            if emo.isDeleteBtn {
                
            }else if let code = emo.code {
                print(code);
            }else if let chs = emo.chs {
                print(chs);
            }
            
        }
        return emoticonsVC;
        }()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(emoticonsVC);
        emoticonsVC.completion = {
            (emo: Emoticon) in
            if emo.isDeleteBtn {
                self.textView.deleteBackward();
            }else if let emoji = emo.emoji {
                self.textView.insertText(emoji)
            }else if let _ = emo.chs {
                self.textView.insertEmoticon(emo);
            }
        }
        
        
        textView.inputView = emoticonsVC.view;
        
    }
    
    // MARK: SendMessage
    @IBAction func sendMessage() {
        print(self.textView.fullText());
    }
    
    
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder();
    }

}

