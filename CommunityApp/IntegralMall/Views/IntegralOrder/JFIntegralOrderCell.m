//
//  JFIntegralOrderCell.m
//  CommunityApp
//
//  Created by yuntai on 16/5/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFIntegralOrderCell.h"
#import <UIImageView+WebCache.h>
#import "JFOrderCollectCell.h"
@interface JFIntegralOrderCell ()
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic, strong) JFOrderModel *model;
@property (nonatomic, strong) UIButton *b;
@end
@implementation JFIntegralOrderCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}
+ (JFIntegralOrderCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)tableViewIndexPath  delegate:(id)object {
    
    JFIntegralOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JFIntegralOrderCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JFIntegralOrderCell" owner:nil options:0]lastObject];
    }
    
    cell.delegate = object;
    cell.tableViewIndexPath = tableViewIndexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    
    self.confirmBtn.layer.borderColor = HEXCOLOR(0xEA7E36).CGColor;
    _confirmBtn.layer.borderWidth = 1.0f;
    _confirmBtn.layer.cornerRadius = 5.0f;
    _confirmBtn.layer.masksToBounds = YES;
    
    self.cancalBtn.layer.borderColor = HEXCOLOR(0xEA7E36).CGColor;
    _cancalBtn.layer.borderWidth = 1.0f;
    _cancalBtn.layer.cornerRadius = 5.0f;
    _cancalBtn.layer.masksToBounds = YES;
    
    self.followBtn.layer.borderColor = HEXCOLOR(0xEA7E36).CGColor;
    _followBtn.layer.borderWidth = 1.0f;
    _followBtn.layer.cornerRadius = 5.0f;
    _followBtn.layer.masksToBounds = YES;
    
    self.delBtn.layer.borderColor = HEXCOLOR(0xEA7E36).CGColor;
    _delBtn.layer.borderWidth = 1.0f;
    _delBtn.layer.cornerRadius = 5.0f;
    _delBtn.layer.masksToBounds = YES;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectview.frame = CGRectMake(7.5, 0, APP_SCREEN_WIDTH-15, 90);

}

//类型 all：全部，20：待发货，30：待收货，40：已完成
- (void)configCellWithOrderModel:(JFOrderModel *)model{
    self.model = model;
    
    self.integralLabel.text = [NSString stringWithFormat:@"共%@件商品  合计:%@积分",model.goods_count,model.total_price];
    self.storeNameLabel.text = model.store_name;
    
    [self.collectview removeFromSuperview];
    if ([model.goods_count integerValue]>1) {//订单中商品数量大于1
        [self hideOneGoodsView:YES];
        [self initCollectView];
        self.array = model.goods;
        [self.collectview reloadData];
    }
    if ([model.goods_count integerValue]==1) {//订单中商品数量等于1
        [self hideOneGoodsView:NO];
        JFOrderGoodModel *goodModel = model.goods[0];
        [self.goodsImageIV sd_setImageWithURL:[NSURL URLWithString:goodModel.goods_img] placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
        self.goodsNameLabel.text = goodModel.goods_name;
        self.specLabel.text = goodModel.goods_spec;
        
        self.b = [[UIButton alloc]initWithFrame:self.infoView.bounds];
        [self.b addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self.infoView addSubview:self.b];
    }
    
    if ([model.order_status isEqualToString:@"20"]) {//待发货
        //确认收货按钮 和 间距
        self.confirmBtnWith.constant = 0.f;
        self.bTob3.constant = 0.f;
        //物流跟踪按钮 和 间距
        self.followBtnWith.constant = 0.f;
        self.bTob2.constant = 0.f;
        //删除订单按钮
        self.delBtnWith.constant = 0.f;
        
        if ([self.model.order_flag isEqualToString:@"1"]) {//取消按钮隐藏
            //取消订单按钮 和 间距
            self.cancalBtnWith.constant = 0.f;
            self.bTob.constant = 0.f;
        }else{//不隐藏
            //取消订单按钮 和 间距
            self.cancalBtnWith.constant = 70.f;
            self.bTob.constant = 0.f;
        }
        self.orderStateLabel.text = @"待发货";
        
    }else if([model.order_status isEqualToString:@"30"]) {//待收货
        //确认收货按钮
        self.confirmBtnWith.constant = 70.f;
        self.bTob3.constant = 0.f;
        //取消订单按钮 和 间距
        self.cancalBtnWith.constant = 0.f;
        self.bTob.constant = 0.f;
        //物流跟踪按钮 和 间距
        self.followBtnWith.constant = 70.f;
        self.bTob2.constant = 10.f;
        //删除订单按钮
        self.delBtnWith.constant = 0.f;
        
        self.orderStateLabel.text = @"待收货";
        
    }else if([model.order_status isEqualToString:@"40"]) {//已完成
        //确认收货按钮
        self.confirmBtnWith.constant = 0.f;
        self.bTob3.constant = 10.f;
        //取消订单按钮 和 间距
        self.cancalBtnWith.constant = 0.f;
        self.bTob.constant = 0.f;
        //物流跟踪按钮 和 间距
        self.followBtnWith.constant = 0.f;
        self.bTob2.constant = 0.f;
        //删除订单按钮
        self.delBtnWith.constant = 70.f;
        
        self.orderStateLabel.text = @"已完成";
    }else{
        //确认收货按钮
        self.confirmBtnWith.constant = 0.f;
        self.bTob3.constant = 10.f;
        //取消订单按钮 和 间距
        self.cancalBtnWith.constant = 0.f;
        self.bTob.constant = 0.f;
        //物流跟踪按钮 和 间距
        self.followBtnWith.constant = 0.f;
        self.bTob2.constant = 0.f;
        //删除订单按钮
        self.delBtnWith.constant = 70.f;
        
        self.orderStateLabel.text = @"已取消";
    }
}

#pragma mark - UICollectionView data source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFOrderCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JFOrderCollectCell" forIndexPath:indexPath];
    JFOrderGoodModel *m = self.array[indexPath.row];
    [cell.imageIV sd_setImageWithURL:[NSURL URLWithString:m.goods_img] placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate integralOrderCell:self numberOfItemsInTableViewIndexPath:self.tableViewIndexPath];
}



- (void)hideOneGoodsView:(BOOL)isHidden{
    self.specLabel.hidden = isHidden;
    self.goodsImageIV.hidden = isHidden;
    self.goodsNameLabel.hidden = isHidden;
}

- (void)initCollectView{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.0f;
    layout.itemSize = CGSizeMake(90, 90);
    self.collectview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    UINib *contentCellViewNib = [UINib nibWithNibName:@"JFOrderCollectCell" bundle:nil];
    [self.collectview registerNib:contentCellViewNib forCellWithReuseIdentifier:@"JFOrderCollectCell"];
    self.collectview.showsHorizontalScrollIndicator = NO;
    [self.infoView addSubview:self.collectview];
    self.collectview.backgroundColor = self.contentView.backgroundColor;
    self.collectview.delegate = self;
    self.collectview.dataSource = self;
    //图片总宽度小于屏幕宽度时 创建btn 实现点击空白处也能跳转
    if (self.array.count*90<APP_SCREEN_WIDTH-15) {
        self.b = [[UIButton alloc]initWithFrame:CGRectMake(7.5+self.array.count*90, 0, APP_SCREEN_WIDTH-self.array.count*90-7.5, 90)];
        [self.b addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self.infoView addSubview:self.b];
    }else{
        [self.b removeFromSuperview];
    }

}

- (IBAction)btnClickAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101://物流跟踪
            [self.delegate integralOrderCell:self OrderFollowIndexPath:self.tableViewIndexPath];
            break;
            
        case 102://取消订单
            [self.delegate integralOrderCell:self cancalOrderIndexPath:self.tableViewIndexPath];
            break;
        case 103://收货
            [self.delegate integralOrderCell:self confirmOrderIndexPath:self.tableViewIndexPath];
            break;
        case 104://删除订单
            [self.delegate integralOrderCell:self delOrderIndexPath:self.tableViewIndexPath];
            break;
    }
}

- (void)click{
    [self.delegate integralOrderCell:self numberOfItemsInTableViewIndexPath:self.tableViewIndexPath];
}
@end
