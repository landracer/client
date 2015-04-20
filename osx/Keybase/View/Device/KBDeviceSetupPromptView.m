//
//  KBDeviceSetupPromptView.m
//  Keybase
//
//  Created by Gabriel on 3/2/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "KBDeviceSetupPromptView.h"
#import "AppDelegate.h"

@interface KBDeviceSetupPromptView ()
@property KBTextField *deviceNameField;
@property KBButton *button;
@end

@implementation KBDeviceSetupPromptView

- (void)viewInit {
  [super viewInit];
  [self kb_setBackgroundColor:KBAppearance.currentAppearance.backgroundColor];
  
  YOView *contentView = [[YOView alloc] init];
  [self addSubview:contentView];

  KBLabel *header = [[KBLabel alloc] init];
  [header setText:@"Set a Device Name" style:KBTextStyleHeaderLarge alignment:NSCenterTextAlignment lineBreakMode:NSLineBreakByTruncatingTail];
  [contentView addSubview:header];

  KBLabel *label = [[KBLabel alloc] init];
  [label setText:@"This is the first time you've logged into this device. You need to register this device by choosing a name. For example, Macbook or Desktop." style:KBTextStyleDefault];
  [contentView addSubview:label];

  _deviceNameField = [[KBTextField alloc] init];
  _deviceNameField.placeholder = @"e.g. Macbook";
  [contentView addSubview:_deviceNameField];

  GHWeakSelf gself = self;
  YOView *footerView = [YOView view];
  _button = [KBButton buttonWithText:@"Save" style:KBButtonStylePrimary];
  _button.targetBlock = ^{ [gself save]; };
  [footerView addSubview:_button];
  _cancelButton = [KBButton buttonWithText:@"Cancel" style:KBButtonStyleDefault];
  [footerView addSubview:_cancelButton];
  footerView.viewLayout = [YOLayout layoutWithLayoutBlock:[KBLayouts layoutForButton:_button cancelButton:_cancelButton horizontalAlignment:KBHorizontalAlignmentCenter]];
  [contentView addSubview:footerView];

  YOSelf yself = self;
  contentView.viewLayout = [YOLayout layoutWithLayoutBlock:^(id<YOLayout> layout, CGSize size) {
    CGFloat y = 0;

    y += [layout sizeToFitVerticalInFrame:CGRectMake(40, y, size.width - 80, 0) view:header].size.height + 20;
    y += [layout centerWithSize:CGSizeMake(400, 0) frame:CGRectMake(40, y, size.width - 80, 0) view:label].size.height + 40;

    y += [layout centerWithSize:CGSizeMake(300, 0) frame:CGRectMake(40, y, size.width - 80, 0) view:yself.deviceNameField].size.height + 40;

    y += [layout sizeToFitVerticalInFrame:CGRectMake(40, y, size.width - 80, 0) view:footerView].size.height;

    return CGSizeMake(MIN(480, size.width), y);
  }];

  self.viewLayout = [YOLayout layoutWithLayoutBlock:[KBLayouts center:contentView]];
}

- (void)viewDidAppear:(BOOL)animated {
  [self.window recalculateKeyViewLoop];
  [self.window makeFirstResponder:_deviceNameField];
}

- (void)save {
  NSString *deviceName = self.deviceNameField.text;

  if ([NSString gh_isBlank:deviceName]) {
    [AppDelegate setError:KBErrorAlert(@"You need to enter a device name.") sender:_deviceNameField];
    return;
  }

  self.completion(self, nil, deviceName);
}

@end
