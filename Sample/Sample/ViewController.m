//
//  ViewController.m
//  Sample
//
//  Created by durian on 9/3/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import "ViewController.h"
#import "DOKeyboard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    DOKeyboard *keyboard = [DOKeyboard keyboardWithType:DOKeyboardTypeHex];
    DOKeyboard *keyboard = [DOKeyboard keyboardWithType:DOKeyboardTypeNumericNormal];
    keyboard.input = self.textfield;
    
    self.textfield.delegate = (id)self;
    [self.textfield becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%@", textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@", string);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    NSLog(@"%@", textField.text);    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
