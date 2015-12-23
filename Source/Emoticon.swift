//
//  Emotion.swift
//  LYCustomEmotionKeyboard
//
//  Created by 李禹 on 15/11/5.
//  Copyright © 2015年 dayu. All rights reserved.
//

import Foundation


public class Emoticon: NSObject, NSSecureCoding {
    
    //最近表情默认存储位置
    static let LYCustomEmoticonRecentFilePath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as NSString!).stringByAppendingPathComponent("RecentEmoticons.data");
    static let EmoticonsBundlePath =  (NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil) as NSString!);

    
    /// 分组名称
    var emoticon_group_name: String?
    /// 分组路径
    var emoticon_group_path: String?
    /// 中文字符
    public var chs: String?
    /// 图片名称
    public var png: String?
    /// 表情类型
    var type: String?
    // emoji 转码后的字符
    public var emoji: String?
    /// emoji 编码
    var code: String? {
        didSet {
            let scanner = NSScanner(string: code!);
            var result: UInt32 = 0;
            scanner.scanHexInt(&result);
            emoji = "\(Character( UnicodeScalar(result)))";
        }
    }
    /// 删除按钮
    var isDeleteBtn: Bool = false;
    
    static let properties = ["emoticon_group_name", "emoticon_group_path", "chs", "png", "type", "code"];

    private func setValues(dict: [String: String]) {
        for key in Emoticon.properties {
            if dict[key] != nil {
                setValue(dict[key], forKeyPath: key);
            }
        }
    }
    
    func toDictionary() -> [String: String] {
        var dict = [String: String]();
        for key in Emoticon.properties {
            if let value = valueForKey(key) as? String {
                dict[key] = value;
                print("key = \(key) value = \(value)");
            }
        }
        return dict;
    }
    
    public static func supportsSecureCoding() -> Bool {
        return true;
    }
  public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.setValue(emoticon_group_name, forKey: "emoticon_group_name");
        aCoder.setValue(emoticon_group_path, forKey: "emoticon_group_path");
        aCoder.setValue(chs, forKey: "chs");
        aCoder.setValue(png, forKey: "png");
        aCoder.setValue(type, forKey: "type");
        aCoder.setValue(code, forKey: "code");
//        aCoder.setValue(NSNumber(bool: isDeleteBtn), forKey: "isDeleteBtn");
    }
    
    override init() {
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init();
        self.emoticon_group_name = aDecoder.valueForKey("emoticon_group_name") as? String;
        self.emoticon_group_path = aDecoder.valueForKey("emoticon_group_path") as? String;
        self.chs = aDecoder.valueForKey("chs") as? String;
        self.png = aDecoder.valueForKey("png") as? String;
        self.type = aDecoder.valueForKey("type") as? String;
        self.code = aDecoder.valueForKey("code") as? String;
//        if (aDecoder.valueForKey("isDeleteBtn") is NSNumber) {
//            self.isDeleteBtn = aDecoder.valueForKey("isDeleteBtn")!.boolValue;
//        }
    }
    
    static var stationaryEmo: [[String: [Emoticon]]]?;

    class func emoticonGroupList() -> [[String: [Emoticon]]] {
        var emoticonGroupList = [[String: [Emoticon]]]();
        
        if Emoticon.stationaryEmo == nil {
            Emoticon.stationaryEmo = [[String: [Emoticon]]]();

            let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle");
            let originalArray = NSArray(contentsOfFile: path!) as! [[String: String]];
            let emoticons = originalArray.sort { (dict1, dict2) -> Bool in
                return dict1["emoticon_group_type"] < dict2["emoticon_group_type"]
            }
            for group in emoticons {
                let groupName = group["emoticon_group_name"];
                let groupPath = group["emoticon_group_path"]!;

                let groupEmoticon = groupEmoticonsByGroupName(groupName!, groupPath: (groupPath as String));
                if groupName == "仅显示" {
                    for emoticon in groupEmoticon![groupName!] as [Emoticon]! {
                        print("png = \(emoticon.png) emoji = \(emoticon.emoji)");
                    }
                }
                if (groupEmoticon == nil) { break; }
                if (groupName! != "仅显示") {
                    Emoticon.stationaryEmo!.append(groupEmoticon!);
                }
                emoticonGroupList.append(groupEmoticon!);
            }
        }else {
            let groupEmoticon = groupEmoticonsByGroupName("仅显示", groupPath: "display_only")
            if (groupEmoticon != nil) {
                emoticonGroupList.append(groupEmoticon!);
            }
            for list in Emoticon.stationaryEmo! {
                emoticonGroupList.append(list);
            }
        }
        
        return emoticonGroupList;
    }
    
    class func emoticonsList() -> [Emoticon] {
        let emoGroupList = Emoticon.emoticonGroupList();
        var emos = [Emoticon]();
        for emoGroup in emoGroupList {
            for (_, groupList) in emoGroup as [String: [Emoticon]] {
                emos += groupList;
            }
        }
        return emos;
    }
    
    class func groupEmoticonsByGroupName(name: String, groupPath path: String) -> [String: [Emoticon]]? {
        
        let compeletePath = EmoticonsBundlePath.stringByAppendingPathComponent(path);
        let infoPath = (compeletePath as NSString).stringByAppendingPathComponent("info.plist");

        let infoDict = NSDictionary(contentsOfFile: infoPath);
        if infoDict == nil {
            return nil;
        }
        let emoticonGroup = infoDict!["emoticon_group_emoticons"];
        if !(emoticonGroup is [NSDictionary]) {
            return nil;
        }

        var emoGroup = emoticonGroup as! [NSDictionary];
        //最近的表情从文件中读取
        if name == "仅显示" {
            let recentEmoticonList = NSArray(contentsOfFile: LYCustomEmoticonRecentFilePath);
            if let recentList = recentEmoticonList as? [NSDictionary] {
                emoGroup.appendContentsOf(recentList);
            }
        }
        
        var emoticonList = [Emoticon]();
        let deleteDict = ["emoticon_group_name": name, "emoticon_group_path": path, "chs": "", "png": "compose_emotion_delete", "type": "", "code": ""];
        let emptyDict = ["emoticon_group_name": name, "emoticon_group_path": path, "chs": "", "png": "", "type": "", "code": ""];
        for emoticonInfo in emoGroup {
            let emoticon = Emoticon();
            
            emoticon.setValues(emoticonInfo as! [String: String]);
            
            if emoticon.emoticon_group_name == nil || emoticon.emoticon_group_name!.isEmpty {
                emoticon.emoticon_group_name = name;
            }
            if emoticon.emoticon_group_path == nil || emoticon.emoticon_group_path!.isEmpty {
                emoticon.emoticon_group_path = path;
            }
            //每20个表情后插入一个删除按钮，分为一页
            if emoticonList.count%21 == 20 {
                let deleteEmo = Emoticon();
                deleteEmo.setValues(deleteDict);
                deleteEmo.isDeleteBtn = true;
                emoticonList.append(deleteEmo);
            }
            emoticonList.append(emoticon);
        }

        // 最后一页，填充不足的部分并增加删除按钮
        while emoticonList.count%21 != 0 {
            if emoticonList.count%21 == 20 {
                let deleteEmo = Emoticon();
                deleteEmo.setValues(deleteDict);
                deleteEmo.isDeleteBtn = true;
                emoticonList.append(deleteEmo);
            }else {
                let emoticon = Emoticon();
                emoticon.setValues(emptyDict);
                emoticonList.append(emoticon);
            }
        }
        var groupEmotion = [String: [Emoticon]]();
        
        groupEmotion[name] = emoticonList;
        return groupEmotion;
    }
    
    // MARK: 存储到本地
    class func addRecentEmoticon(emo: Emoticon) -> Bool {
        
        let infoPath =  (EmoticonsBundlePath.stringByAppendingPathComponent("display_only") as NSString!).stringByAppendingPathComponent("info.plist");
        let infoDict = NSDictionary(contentsOfFile: infoPath)!;
        let emoList = infoDict["emoticon_group_emoticons"] as! NSArray;
        for emoDict in emoList {
            if let png = emoDict["png"] as? String{
                if (png == emo.png) {
                    return false;
                }
            }
            
        }

        var recentEmoList = NSArray(contentsOfFile: LYCustomEmoticonRecentFilePath) as? [[String: String]];
        if recentEmoList == nil {
            recentEmoList = [[String: String]]();
        }
        
        if let path = emo.emoticon_group_path {
            let dir = (path as NSString!).lastPathComponent;
            emo.emoticon_group_path = dir;
        }
        let emoDict = emo.toDictionary();
        
        let recentEmoListCopy = NSMutableArray(array: recentEmoList!, copyItems: true);
        if recentEmoListCopy.count == 17 {
            recentEmoListCopy.removeLastObject();
        }
        for recentEmo in recentEmoList! as NSArray {
            if let png = recentEmo["png"] as? String{
                if (png == emo.png) {
                    recentEmoListCopy.removeObject(recentEmo);
                    break;
                }
            }
            if let code = recentEmo["code"] as? String {
                if code == emo.code {
                    recentEmoListCopy.removeObject(recentEmo);
                    break;
                }
            }
        }
        
        recentEmoListCopy.insertObject(emoDict, atIndex: 0);
        
        (recentEmoListCopy as NSArray!).writeToFile(LYCustomEmoticonRecentFilePath, atomically: true);
        return true;
    }
}