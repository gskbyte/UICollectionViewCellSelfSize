//
//  XNGTextImageCollectionViewController.h
//  AutoSizingExample
//
//  Created by Jose Alcalá-Correa on 16/10/14.
//  Copyright (c) 2014 gskbyte. All rights reserved.
//

#import "XNGTextImageCollectionViewController.h"

#import "XNGChiquitoIpsum.h"
#import <Masonry/Masonry.h>

#import <objc/runtime.h>

const static NSUInteger XNGNumTextCells = 1000;

@interface XNGTextImageCell : UICollectionViewCell

@property (nonatomic) NSDictionary *data;

@property (nonatomic) UIImageView * imageView;
@property (nonatomic) UILabel * textLabel;

+ (CGSize)sizeForData:(NSDictionary*)data;

@end

@interface XNGTextImageCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic) BOOL useAutoSizingCells;
@property (nonatomic) NSMutableArray * datas;

@end

@implementation XNGTextImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerClass:XNGTextImageCell.class
            forCellWithReuseIdentifier:NSStringFromClass(XNGTextImageCell.class)];
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    self.useAutoSizingCells = [flow respondsToSelector:@selector(setEstimatedItemSize:)];
    if(self.useAutoSizingCells) {
        flow.estimatedItemSize = CGSizeMake(300, 100); // if collectionView:layout:sizeForItemAtIndexPath is implemented, does not do anything
    }

    self.datas = [NSMutableArray arrayWithCapacity:XNGNumTextCells];
    for(NSUInteger i=0; i<XNGNumTextCells; ++i) {
        NSUInteger numWords = 1 + arc4random_uniform(37);
        NSString * text = [XNGChiquitoIpsum stringWithWordCount:numWords];
        NSString *imageName;
        switch (numWords%3) {
            case 1:
                imageName = @"green.png";
                break;
            case 2:
                imageName = @"power.png";
                break;
            case 0:
            default:
                imageName = @"lab.png";
                break;
        }

        UIImage *image = [UIImage imageNamed:imageName];
        [self.datas addObject:@{@"image": image,
                                @"text":text}];
    }

    NSLog(@"End of text generation");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return XNGNumTextCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XNGTextImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(XNGTextImageCell.class)
                                                                  forIndexPath:indexPath];
    NSDictionary *data = self.datas[indexPath.row];
    cell.data = data;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.datas[indexPath.row];
    return [XNGTextImageCell sizeForData:data];
}

// Why do we do this:
// If collectionView:layout:sizeForItemAtIndexPath is implemented, it will be called at the beginning
// and we will lose the advantage of using autosizing cells
- (BOOL)respondsToSelector:(SEL)aSelector {
    if(self.useAutoSizingCells &&
       aSelector == @selector(collectionView:layout:sizeForItemAtIndexPath:)) {
        return NO;
    }

    return [super respondsToSelector:aSelector];
}

@end


@implementation XNGTextImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // should NEVER be visible
        self.backgroundColor = [UIColor greenColor];

        // content view
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0); //need to be set so that there are no
            make.top.equalTo(@0);
            make.width.greaterThanOrEqualTo(@150);
            make.width.lessThanOrEqualTo(@280);
        }];
        self.contentView.backgroundColor = [UIColor yellowColor];

        // Dynamic imageview
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@50);

            make.left.equalTo(@8);
            make.top.equalTo(@(8));
            make.bottom.equalTo(@(-8)).with.priorityLow();
        }];

        // text label, dynamic
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.numberOfLines = 20;
        self.textLabel.font = [UIFont systemFontOfSize:10];
        self.textLabel.backgroundColor = [UIColor orangeColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).with.offset(8);
            make.top.equalTo(@8);
            make.right.equalTo(@(-8));
            make.bottom.lessThanOrEqualTo(@(-8));
        }];

    }
    return self;
}

#pragma mark - cell configuration

- (void)updateConstraints {
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.imageView.image.size.width));
        make.height.equalTo(@(self.imageView.image.size.height));
    }];

    [super updateConstraints];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    self.imageView.image = data[@"image"];
    self.textLabel.text = data[@"text"];

    [self setNeedsUpdateConstraints];
}

+ (CGSize)sizeForData:(NSDictionary*)data {
    static XNGTextImageCell * cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[XNGTextImageCell alloc] initWithFrame:CGRectZero];
    });
    cell.data = data;
    [cell layoutIfNeeded]; // this needs to be called only on iOS7
    // calling this on the cell itself returns (0,0) on iOS 7
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size;
}

#pragma - mark These methods are here just so that you see how it works

// method called when using auto sizing cells
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *size = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];

    // computed size can be changed here, but should not be necessary

    return size;
}

// called for cells with autolayout
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
    CGSize size = [super systemLayoutSizeFittingSize:targetSize];

    return size;
}

// called if no autolayout is used
- (CGSize)sizeThatFits:(CGSize)targetSize {
    CGSize size = [super sizeThatFits:targetSize];

    return size;
}

@end