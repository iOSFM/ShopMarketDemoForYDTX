//
//  MarketMaskView.m
//  market
//
//  Created by RookieHua on 2016/12/6.
//  Copyright © 2016年 RookieHua. All rights reserved.
//

#import "MarketMaskView.h"

#import "PPNumberButton.h"
@interface MarketMaskView ()

@property(strong,nonatomic)UIView *baseMaskView;//遮罩view
@property(strong,nonatomic)UIView *baseView;//进行商品信息选择的baseView
@property(strong,nonatomic)UICollectionView *modelCollectView;

@end



static NSString *model = @"banner";
@implementation MarketMaskView
//Lazy


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setUI];//创建界面
    }
    return self;
}



//布局界面
-(void)setUI{
    
//底部的maskView
    
    _baseMaskView = [[UIView alloc]initWithFrame:self.bounds];
    
    [_baseMaskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_baseMaskView];
    //添加点击手势  当用户点击的时候移除self
    UITapGestureRecognizer *tapRemoveSelf = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
    [_baseMaskView addGestureRecognizer:tapRemoveSelf];
    
//baseView
     _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, YDTXScreenH , YDTXScreenW, 418)];
    
    _baseView.backgroundColor = [UIColor yellowColor];
    
//    baseView.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:_baseView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _baseView.frame = CGRectMake(0, YDTXScreenH -418, YDTXScreenW, 418);
        
    }];


//右上角的关闭btn
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"market_MaskView_closeBtn"] forState:UIControlStateNormal];
    [_baseView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_baseView).offset(-10);
        make.centerY.equalTo(_baseView.mas_top);
    }];
    
//imageView
    UIImageView *ImgView = [[UIImageView alloc]init];
    ImgView.backgroundColor = [UIColor redColor];
    ImgView.layer.borderWidth = 2;
    ImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    ImgView.layer.cornerRadius = 5;
    ImgView.layer.masksToBounds = YES;
    [_baseView addSubview:ImgView];
    [ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(125, 125));
        make.leading.equalTo(_baseView).offset(15);
        make.top.equalTo(_baseView).offset(-15);
    }];

//商品Label
    UILabel *goodsTitleLabel = [[UILabel alloc]init];
    goodsTitleLabel.numberOfLines = 2;
    goodsTitleLabel.font = [UIFont systemFontOfSize:16];
    goodsTitleLabel.textColor = [UIColor blackColor];
    goodsTitleLabel.text = @"xxx";
    [_baseView addSubview:goodsTitleLabel];
    [goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(ImgView.mas_trailing).offset(10);
        make.top.equalTo(_baseView).offset(30);
        make.trailing.equalTo(_baseView).offset(-10);
    }];
    
//价格Label
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.numberOfLines = 1;
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = [UIFont systemFontOfSize:18];
    priceLabel.text = @"¥xxx.xx";
    [_baseView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(goodsTitleLabel);
        make.top.equalTo(goodsTitleLabel.mas_bottom).offset(20);
    }];
    
//型号Label
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.text = @"型号";
    typeLabel.font = [UIFont systemFontOfSize:16];
    typeLabel.textColor = [UIColor blackColor];
    [_baseView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(ImgView);
        make.top.equalTo(ImgView.mas_bottom).offset(15);
        
    }];
//型号collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _modelCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _modelCollectView.backgroundColor = [UIColor greenColor];
    [_baseView addSubview:_modelCollectView];
    [_modelCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseView);
        make.right.equalTo(_baseView);
        make.top.equalTo(typeLabel.mas_bottom);
        make.height.mas_equalTo(160);
    }];
    
    

    //购买数量Label
    UILabel *buyNumLabel = [[UILabel alloc]init];
    buyNumLabel.text = @"购买数量";
    buyNumLabel.font = [UIFont systemFontOfSize:16];
    buyNumLabel.textColor = [UIColor blackColor];
    [_baseView addSubview:buyNumLabel];
    [buyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(ImgView);
        make.top.equalTo(_modelCollectView.mas_bottom).offset(15);
        
    }];
    

//加入购物车btn
    UIButton *addToCartBtn = [[UIButton alloc]init];
    [addToCartBtn setBackgroundColor:[UIColor orangeColor]];
    addToCartBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [addToCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addToCartBtn addTarget:self action:@selector(addToCartWithModelId:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:addToCartBtn];
    [addToCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_baseView);
        make.leading.equalTo(_baseView);
        make.trailing.equalTo(_baseView);
        make.height.mas_equalTo(50);
    }];
    
    
//加减数量btn与textfiled

    
    PPNumberButton *numberButton = [[PPNumberButton alloc]init];;
    numberButton.shakeAnimation = YES;
    //设置边框颜色
    numberButton.borderColor = [UIColor grayColor];
    
    numberButton.increaseTitle = @"＋";
    numberButton.decreaseTitle = @"－";
    numberButton.inputFieldFont = 14;
    
    numberButton.resultBlock = ^(NSString *num){
        NSLog(@"%@",num);
    };
    
    [_baseView addSubview:numberButton];
    [numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buyNumLabel);
        make.trailing.equalTo(_baseView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(120, 35));
    }];
    
}


-(void)addToCartWithModelId:(NSString *)modelId{

    NSLog(@"--点击了加入购物车按钮--");

 

}



#pragma 提供给外部的方法
-(void)showWithTransformAnimation{
    [self TransformAnimation];
    
}


-(void)updateUIWithGoodsId:(NSString *)goods_id{
    //获取数据
    [[NetWorkService shareInstance]requestForMarketGoodsModelDataWithGoodsId:goods_id responseBlock:^(NSArray *marketProductModelArray) {
        
//        marketProductModel *marketProductModel = marketProductModelArray[0];
        //创建规格视图
//        [self creatModelBtnWithDataArray:marketProductModelArray];
    }];
    
    
    
    
    
}

#pragma 私有方法
-(void)creatModelBtnWithDataArray:(NSArray *)dataArray{
    
    
    for (int i = 0;i < dataArray.count ; i++) {
        
        UIButton *modelBtn = [[UIButton alloc]init];
        [modelBtn setBackgroundColor:RGB(250, 250, 250)];
        [modelBtn setTitleColor:[UIColor colorForHex:@"#2e2e2e"] forState:UIControlStateNormal];
        modelBtn.layer.cornerRadius = 5;
        modelBtn.layer.masksToBounds = YES;
        modelBtn.layer.borderWidth = 1;
        modelBtn.layer.borderColor = RGB(211, 211, 211).CGColor;
        modelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [modelBtn setTitle:@"xx" forState:UIControlStateNormal];
        [_baseView addSubview:modelBtn];
        //frame
        
    }


}


#pragma mark--modelCollectionView Method





#pragma 手势触发的方法
-(void)disMiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.baseView.frame = CGRectMake(0, YDTXScreenH , YDTXScreenW, 418);
    } completion:^(BOOL finished) {
        [self dismissTransformAnimation];
        [_baseView removeFromSuperview];
        [_baseMaskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


#pragma mark - TranslationAnimation

//出现时执行的动画
-(void)TransformAnimation{

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.superview.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.superview.layer setTransform:[self secondTransform]];
            
        } completion:^(BOOL finished) {
            [self setUI];
        }];
        
    }];

}


//消失时执行的动画
-(void)dismissTransformAnimation{

    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.superview.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
            //变为初始值
            [self.superview.layer setTransform:CATransform3DIdentity];
        
    }];

}


//缩放 旋转的动画
- (CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.superview.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.85, 0.75, 1);
    return t2;
}

@end
