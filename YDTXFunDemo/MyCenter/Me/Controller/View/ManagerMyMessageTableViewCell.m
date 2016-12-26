//
//  ManagerMyMessageTableViewCell.m
//  YDTXFunDemo
//
//  Created by 舒通 on 2016/12/20.
//  Copyright © 2016年 Story5. All rights reserved.
//

#import "ManagerMyMessageTableViewCell.h"

@implementation ManagerMyMessageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        NSArray *imgName = @[@"my_order",@"my_recivingAddress",@"my_coupon",@"my_equity"];
        NSArray *titleName = @[@"我的订单",@"收货地址",@"优惠券",@"我的权益"];
        
        for (int i = 0; i < imgName.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 10+i;
            
            [btn setTitle:titleName[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imgName[i]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            btn.frame = CGRectMake(ScreenWidth/4*i, 0, ScreenWidth/4, 100*HeightScale);
            //    / button标题的偏移量
            btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.frame.size.height+15, -btn.imageView.bounds.size.width, 0,0);
            //    // button图片的偏移量
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width/2,btn.titleLabel.frame.size.height+15, -btn.titleLabel.frame.size.width/2);
            
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
    }
    return self;
}

- (void) btnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickBtn:tag:manageCellView:)]) {
        [_delegate didClickBtn:sender tag:sender.tag manageCellView:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end