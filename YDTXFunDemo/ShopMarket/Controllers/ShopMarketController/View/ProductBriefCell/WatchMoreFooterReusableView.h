//
//  WatchMoreCell.h
//  YDTXFunDemo
//
//  Created by Story5 on 16/12/2016.
//  Copyright © 2016 Story5. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WatchMoreHandler)(UIButton *aSender);

@interface WatchMoreFooterReusableView : UICollectionReusableView

@property (nonatomic,copy) WatchMoreHandler watchMoreHandler;

@end
