//
//  YJ_ScaleCircle.m
//  YueJian
//
//  Created by LG on 2018/4/8.
//  Copyright © 2018年 RHEA. All rights reserved.
//

#import "YJ_ScaleCircle.h"

@interface YJ_ScaleCircle ()
{
    CGFloat radius; //半径
    CGFloat first_animation_time;
    CGFloat second_animation_time;
    CGFloat third_animation_time;
    CGFloat fourth_animation_time;
}

@property(nonatomic) CGPoint CGPoinCerter;
@property(nonatomic) CGFloat endAngle;
@property(nonatomic) BOOL clockwise;
@end

@implementation YJ_ScaleCircle

//  初始化参数
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initCenterLabel];
        
        self.lineWith = 5.0;
        self.unfillColor = [UIColor lightGrayColor];
        self.clockwise = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.firstColor = [UIColor redColor];
        self.secondColor = [UIColor greenColor];
        self.thirdColor = [UIColor yellowColor];
        self.fourthColor = [UIColor blueColor];
        
        self.animation_time = 5.0;
        
        self.centerLable.text = @"0";
        
    }
    return self;
}
#pragma mark setMethod
/**
 *  画图函数
 *
 *  @param rect rect description
 */
-(void)drawRect:(CGRect)rect{
    
    [self initData];
    [self drawMiddlecircle];
    
    dispatch_queue_t queue = dispatch_queue_create("ldz.demo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawOutCCircle_first];
        });
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:first_animation_time];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawOutCCircle_second];
        });
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:second_animation_time];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawOutCCircle_third];
        });
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:third_animation_time];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawOutCCircle_fourth];
        });
    });
}

/**
 *  中心标签设置
 */
- (void)initCenterLabel {
    CGFloat center =MIN(self.bounds.size.height/2, self.bounds.size.width/2);
    self.CGPoinCerter = CGPointMake(center, center);
    self.centerLable = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 0, 2*center, 2*center)];
    self.centerLable.textAlignment = NSTextAlignmentCenter;
    self.centerLable.textColor = [UIColor whiteColor];
    //self.centerLable.adjustsFontSizeToFitWidth = YES;
    //self.centerLable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeRedraw;
    [self addSubview:self.centerLable];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"今日步数";
    label.adjustsFontSizeToFitWidth = YES;
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:label];
    
    [self.centerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.offset(0);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self.centerLable.mas_top).with.offset(0);
        make.height.offset(18);
    }];
}

/**
 *  参数设置
 */
-(void)initData{
    //计算animation时间
    first_animation_time = self.animation_time * self.firstScale;
    second_animation_time = self.animation_time * self.secondScale;
    third_animation_time = self.animation_time * self.thirdScale;
    fourth_animation_time = self.animation_time * self.fourthScale;
    //半径计算
    radius = MIN(self.bounds.size.height/2-self.lineWith/2, self.bounds.size.width/2-self.lineWith/2);
    self.centerLable.font = [UIFont systemFontOfSize:radius/1.5 weight:0.3];
}

/**
 *  显示圆环 -- first
 */
-(void )drawOutCCircle_first{
    UIBezierPath *bPath_first = [UIBezierPath bezierPathWithArcCenter: self.CGPoinCerter radius:radius startAngle: M_PI * 0 endAngle: M_PI * self.firstScale * 2 clockwise: self.clockwise];
    
    CAShapeLayer *lineLayer_first = [ CAShapeLayer layer];
    lineLayer_first.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    lineLayer_first.fillColor = [UIColor clearColor].CGColor;
    lineLayer_first.path = bPath_first.CGPath;
    lineLayer_first.strokeColor = self.firstColor.CGColor;
    lineLayer_first.lineWidth = self.lineWith;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = first_animation_time;
    [lineLayer_first addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    [self.layer addSublayer: lineLayer_first];
}
/**
 *  显示圆环 -- second
 */
-(void )drawOutCCircle_second{
    UIBezierPath *bPath_second = [UIBezierPath bezierPathWithArcCenter: self.CGPoinCerter radius:radius startAngle: M_PI * 2 * self.firstScale endAngle: M_PI * 2 * (self.firstScale + self.secondScale) clockwise: self.clockwise];
    
    CAShapeLayer *lineLayer_second = [CAShapeLayer layer];
    lineLayer_second.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    lineLayer_second.fillColor = [UIColor clearColor].CGColor;
    lineLayer_second.path = bPath_second.CGPath;
    lineLayer_second.strokeColor = self.secondColor.CGColor;
    lineLayer_second.lineWidth = self.lineWith-4;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = second_animation_time;
    [lineLayer_second addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    [self.layer addSublayer: lineLayer_second];
}
/**
 *  显示圆环 -- third
 */
-(void )drawOutCCircle_third{
    UIBezierPath *bPath_third = [UIBezierPath bezierPathWithArcCenter: self.CGPoinCerter radius:radius startAngle: M_PI * 2 * (self.firstScale + self.secondScale) endAngle: M_PI * 2 * (self.firstScale + self.secondScale + self.thirdScale) clockwise: self.clockwise];
    
    CAShapeLayer *lineLayer_third = [CAShapeLayer layer];
    lineLayer_third.frame = _centerLable.frame;
    lineLayer_third.fillColor = [UIColor clearColor].CGColor;
    lineLayer_third.path = bPath_third.CGPath;
    lineLayer_third.strokeColor = self.thirdColor.CGColor;
    lineLayer_third.lineWidth = self.lineWith;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = third_animation_time;
    [lineLayer_third addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    [self.layer addSublayer: lineLayer_third];
}
/**
 *  显示圆环 -- fourth
 */
-(void )drawOutCCircle_fourth{
    UIBezierPath *bPath_fourth = [UIBezierPath bezierPathWithArcCenter: self.CGPoinCerter radius:radius startAngle: M_PI * 2 * (self.firstScale + self.secondScale + self.thirdScale) endAngle: M_PI * 2 * (self.firstScale + self.secondScale + self.thirdScale + self.fourthScale) clockwise: self.clockwise];
    
    CAShapeLayer *lineLayer_fourth = [CAShapeLayer layer];
    lineLayer_fourth.frame = _centerLable.frame;
    lineLayer_fourth.fillColor = [UIColor clearColor].CGColor;
    lineLayer_fourth.path = bPath_fourth.CGPath;
    lineLayer_fourth.strokeColor = self.fourthColor.CGColor;
    lineLayer_fourth.lineWidth = self.lineWith;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = fourth_animation_time;
    [lineLayer_fourth addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    [self.layer addSublayer: lineLayer_fourth];
}
/**
 *  辅助圆环
 */
-(void)drawMiddlecircle{
    UIBezierPath *cPath = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter radius:radius startAngle:M_PI * 0 endAngle:M_PI * 2 clockwise:self.clockwise];
    cPath.lineWidth=self.lineWith;
    cPath.lineCapStyle = kCGLineCapRound;
    cPath.lineJoinStyle = kCGLineJoinRound;
    UIColor *color = self.unfillColor;
    [color setStroke];
    [cPath stroke];
}


@end
