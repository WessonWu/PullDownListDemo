//
//  ViewController.m
//  PullDownListDemo
//
//  Created by WessonWu on 16/4/19.
//  Copyright © 2016年 WessonWu. All rights reserved.
//

#import "ViewController.h"
static const CGFloat kPullDownListIndent = 8;
static const CGFloat kPullDownListWidthRatio = 0.9;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ViewController {
    UITableView* _tableView;
    CGRect _emailFrame;
    NSArray* _emailSuffix;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _emailSuffix = @[@"", @"@163.com", @"@126.com", @"@gmail.com", @"@qq.com", @"@outlook.com"];
    

    _emailTextField.delegate = self;
    //注册编辑内容发生改变事件
    [_emailTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _emailFrame = _emailTextField.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.emailTextField resignFirstResponder];
}


#pragma mark TextField
- (IBAction)textFieldEditingChanged:(id)sender {
    if (_tableView != nil) {
        [_tableView reloadData];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_emailFrame.origin.x + kPullDownListIndent, _emailFrame.origin.y + _emailFrame.size.height, _emailFrame.size.width * kPullDownListWidthRatio, 0) style:UITableViewStylePlain];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [UIView animateWithDuration:0.5f animations:^{
        _tableView.frame = CGRectMake(_emailFrame.origin.x + kPullDownListIndent, _emailFrame.origin.y + _emailFrame.size.height, _emailFrame.size.width * kPullDownListWidthRatio, _emailFrame.size.height * 6);
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5f animations:^{
        _tableView.frame = CGRectMake(_emailFrame.origin.x + kPullDownListIndent, _emailFrame.origin.y + _emailFrame.size.height, _emailFrame.size.width * kPullDownListWidthRatio, 0);
    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
    }];
}


#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_emailSuffix count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _emailFrame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.emailTextField.text == nil || [self.emailTextField.text isEqual:@""]) {
        cell.textLabel.text = @"";
    } else {
        NSRange range = [_emailTextField.text rangeOfString:@"@"];
        //        NSLog(@"%lu %lu", (unsigned long)range.location, (unsigned long)range.length);
        if (range.location > 0 && range.length == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = [self.emailTextField.text stringByAppendingString:_emailSuffix[indexPath.row]];
            } else {
                cell.textLabel.text = [[_emailTextField.text substringToIndex:range.location] stringByAppendingString:_emailSuffix[indexPath.row]];
            }
        } else {
            cell.textLabel.text = [self.emailTextField.text stringByAppendingString:_emailSuffix[indexPath.row]];
        }
    }
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%@", indexPath);
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.emailTextField.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
//    [self textFieldValueChanged];
    [_tableView removeFromSuperview];
}

@end
