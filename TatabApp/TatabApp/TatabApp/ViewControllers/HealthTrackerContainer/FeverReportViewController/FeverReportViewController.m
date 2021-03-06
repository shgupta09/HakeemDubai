//
//  FeverReportViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//
#import "PaymentVC.h"
#import "FeverReportViewController.h"

@interface FeverReportViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate,UIPickerViewDelegate,ChartViewDelegate>{
    LoderView *loderObj;
    NSMutableArray *dataArray;
    UIView *viewOverPicker;
    NSString *fromDateString;

    NSString *toDateString;

    UIPickerView *pickerObj;
    UIDatePicker* pickerForDate;
    NSDate *toDate;
    NSDate *fromDate;
    UIToolbar *toolBar;
    CustomAlert *alertObj;
}

@end

@implementation FeverReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    toDate = [NSDate date];
    //_txtComments.text = @"comment";
    fromDate = [NSDate date];
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI * 0.5);
    _sliderView.transform = trans;
    _sliderValue.text = [NSString stringWithFormat:@"%.1f",_sliderView.value];
    [_sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _sliderView.maximumValue = 42.0;
    _sliderView.minimumValue = 32.0;

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        fromDateString = [CommonFunction setOneMonthOldGate];
        [_btnFromDate setTitle:fromDateString forState:UIControlStateNormal];
        toDateString = [dateFormatter stringFromDate:toDate];
        [_btnToDate setTitle:toDateString forState:UIControlStateNormal];


    UIImage * white = [[UIImage imageNamed:@"tempratuer-slider"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [_sliderView setMinimumTrackImage:[white stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [_sliderView setMaximumTrackImage:[white stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [_sliderView setThumbImage:[UIImage imageNamed:@"slider-fever"] forState:UIControlStateNormal];
    [_sliderView trackRectForBounds:_sliderView.bounds];
    
    if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        _btnAdd.hidden = true;
    }

    
 
        [_lblPatientName setText:[_dependant.name capitalizedString]];
        [_lblgender setText:_dependant.gender];
        [_lblbirthDate setText:[CommonFunction ConvertDateTime2:_dependant.birthDay]];
   
    
    self.title = @"Multiple Lines Chart";
        
    _graphView.delegate = self;
    
    _graphView.chartDescription.enabled = NO;
    _graphView.leftAxis.enabled = YES;
    _graphView.rightAxis.enabled = NO;
    _graphView.rightAxis.drawAxisLineEnabled = NO;
    _graphView.rightAxis.drawGridLinesEnabled = NO;
    _graphView.xAxis.drawAxisLineEnabled = NO;
    _graphView.xAxis.drawGridLinesEnabled = NO;
    _graphView.xAxis.labelTextColor = [UIColor clearColor];
    _graphView.drawGridBackgroundEnabled = NO;
    _graphView.drawBordersEnabled = NO;
    _graphView.dragEnabled = NO;
    [_graphView setScaleEnabled:NO];
    _graphView.pinchZoomEnabled = NO;
_graphView.legend.enabled = NO;
        //    ChartLegend *l = _graphView.legend;
    //    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    //    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    //    l.orientation = ChartLegendOrientationVertical;
    //    l.drawInside = NO;
    
    [self slidersValueChanged:nil];
    [self setData];
    [self setLanguageData];
    // Do any additional setup after loading the view from its nib.
}

-(void)setData{
    _lbl_WeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight],[Langauge getTextFromTheKey:@"Kg"]];
    _lbl_HeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Height],[Langauge getTextFromTheKey:@"Cm"]];
}
-(void)setLanguageData{
    _lbl_No_Data.text = [Langauge getTextFromTheKey:@"no_data"];
    [_btn_EMR setTitle:[Langauge getTextFromTheKey:@"emr"] forState:UIControlStateNormal];
    [_btn_Health setTitle:[Langauge getTextFromTheKey:@"health_tracker"] forState:UIControlStateNormal];
    [_btnToDate setTitle:toDateString forState:UIControlStateNormal];
    [_btnFromDate setTitle:fromDateString forState:UIControlStateNormal];
    _btnFromDate.imageEdgeInsets = UIEdgeInsetsMake(8, 5, 8, 110);
    _btnToDate.imageEdgeInsets = UIEdgeInsetsMake(8, 5, 8, 110);
    

    [_btn_Refresh setTitle:[Langauge getTextFromTheKey:@"refresh_graph"] forState:UIControlStateNormal];
    
    
    _lbl_title.text = [Langauge getTextFromTheKey:@"emr"];
    _lbl_FeverReport.text = [Langauge getTextFromTheKey:@"fever_report"];
    _lbl_patient.text = [Langauge getTextFromTheKey:@"patient"];
    _lbl_GenderTitle.text = [Langauge getTextFromTheKey:@"gender"];
    _lbl_Height_Title.text = [Langauge getTextFromTheKey:@"height"];
    _lbl_BirthDate.text = [Langauge getTextFromTheKey:@"birthdate"];
    _lbl_WeightTitle.text = [Langauge getTextFromTheKey:@"weight"];
    _lbl_Chronic.text = [Langauge getTextFromTheKey:@"chornic"];
    _lbl_Temp_Title.text = [Langauge getTextFromTheKey:@"temperature"];
    
   
    [_btn_Submit setTitle:[Langauge getTextFromTheKey:@"submit"] forState:UIControlStateNormal];
    [_btn_Cancel setTitle:[Langauge getTextFromTheKey:@"cancel"] forState:UIControlStateNormal];
    
    [_txtComments setPlaceholderWithColor:[Langauge getTextFromTheKey:@"comment"]];
   _lbl_TodaysTemp.text = [Langauge getTextFromTheKey:@"Today_Temp"];
   _lbl_VeryHot.text = [Langauge getTextFromTheKey:@"very_HotTemp"];
   _lbl_Hot.text = [Langauge getTextFromTheKey:@"hot_Tempreture"];
   _lbl_Normal.text = [Langauge getTextFromTheKey:@"normal_Temp"];
   _lbl_Cold.text = [Langauge getTextFromTheKey:@"cold_Temp"];
   _lbl_VeryCold.text = [Langauge getTextFromTheKey:@"normal_Temp"];
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}


- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSLog(@"slider value = %f", sender.value);
    _sliderValue.text = [NSString stringWithFormat:@"%.1f", _sliderView.value];
    
    if (_sliderView.value>39 ) {
        _cons_imgView.constant = -100;
    }
    else if (_sliderView.value>37.5 && _sliderView.value<=39) {
        _cons_imgView.constant = -50;
        
    }
    else if (_sliderView.value>36.5 && _sliderView.value<=37.5) {
        _cons_imgView.constant = 0;
        
    }
    else if (_sliderView.value>=36 && _sliderView.value<=36.5) {
        _cons_imgView.constant = 50;
        
    }
    else if (_sliderView.value<36) {
        _cons_imgView.constant = 100;
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self getFeverReport];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resignResponder{
    
}

- (IBAction)btnBackPopUp:(id)sender {
     [_popUpView removeFromSuperview];
}

#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:false completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopBackNow" object:nil];
    }];
}

#pragma mark - btn Actions
- (IBAction)btnAction_instructions:(id)sender {
    
    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"For more instructions about using TatabApp tracker please visit www.tatabapp.com" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
}

- (IBAction)btnHealthTrackerClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}

- (IBAction)btnEMRClcked:(id)sender {
    
    [self dismissViewControllerAnimated:false completion:nil];
    
}
- (IBAction)btnAddFeverClicked:(id)sender {
    
    [[self popUpView] setAutoresizesSubviews:true];
    [[self popUpView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView] setFrame:frame];
    [self.view addSubview:_popUpView];
    [CommonFunction addAnimationToview:_popUpView];
    
}

- (IBAction)btnSubmitFeverreport:(id)sender {
    [self uploadFeaverReport] ;
}
- (IBAction)btnActionUploadReport:(id)sender {
    
    
    [self generateReport];
}

#pragma mark - api
-(void)generateReport{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    
    if (!_isdependant){
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:@"na" forKey:DEPENDANT_ID];
    }
    else
    {
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:_dependant.depedant_id forKey:DEPENDANT_ID];
    }
    
    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight] forKey:@"weight"];
    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Height] forKey:@"height"];
    [parameterDict setValue:@"1" forKey:@"report"];
    [parameterDict setValue:fromDateString forKey:@"from"];
    [parameterDict setValue:toDateString forKey:@"to"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder:[Langauge getTextFromTheKey:@"download_Report"]];
        
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_REPORT]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    
                    [self removeloder];
                    NSLog(@"%@",responseObj);
                    [self downloadPdf:[responseObj valueForKey:@"download_url"]];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
}

-(void)downloadPdf:(NSString *)str{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"YourPDF.pdf"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:str]];
        //Store the downloaded file  in documents directory as a NSData format
        [pdfData writeToFile:filePath atomically:YES];
    }else{
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:str]];
        //Store the downloaded file  in documents directory as a NSData format
        [pdfData writeToFile:filePath atomically:YES];
    }
    
    PaymentVC *obj = [[PaymentVC alloc]initWithNibName:@"PaymentVC" bundle:nil];
    obj.urlString = filePath;
    obj.isPayment = false;
    obj.navigationTitle = [Langauge getTextFromTheKey:@"fever_report"];
    
    [self.navigationController pushViewController:obj animated:true];
    
}





-(void)uploadFeaverReport{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    
    if (!_isdependant){
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:@"na" forKey:DEPENDANT_ID];
    }
    else
    {
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:_dependant.depedant_id forKey:DEPENDANT_ID];
    }
    
//    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:DOCTOR_ID];
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    Formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringFor = [Formatter stringFromDate:[NSDate date]];
    [parameterDict setValue:[NSString stringWithFormat:@"%.1f", _sliderView.value] forKey:@"temperature"];
   
    if ([_txtComments.text  isEqual: @""]){
        [parameterDict setValue:@"comment" forKey:@"comment"];
        
    }
    else
    {
        [parameterDict setValue:_txtComments.text forKey:@"comment"];
        
    }
    
    [parameterDict setValue:stringFor forKey:@"date"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder:[Langauge getTextFromTheKey:@"please_wait"]];
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UPLOAD_FEVER_REPORT]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                    */
                    [self removeloder];
                    [self getFeverReport];
                    [_popUpView removeFromSuperview];

                    
                     [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
                 }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
}


-(void)getFeverReport{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    
    if (!_isdependant){
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:@"na" forKey:DEPENDANT_ID];

    }
    else
    {
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:_dependant.depedant_id forKey:DEPENDANT_ID];
    }
    
    [parameterDict setValue:fromDateString forKey:@"from"];
    [parameterDict setValue:toDateString forKey:@"to"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder:[Langauge getTextFromTheKey:@"please_wait"]];
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_FEVER_REPORT]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                dataArray = [NSMutableArray new];

                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    NSArray *tempArray = [responseObj valueForKey:@"data"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Report *bloodObj = [Report new];
                        bloodObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        bloodObj.temperature = [obj valueForKey:@"temperature"];
                        bloodObj.comment = [obj valueForKey:@"comment"];
                        bloodObj.date = [obj valueForKey:@"date"];
                        [dataArray addObject:bloodObj];
                    }];
                    [self removeloder];
                    [self updateChartData];
                    if (tempArray.count == 0) {
                        _graphView.hidden = true;
                        _lbl_NoDataa.hidden = false;
                    }else{
                        _graphView.hidden = false;
                        _lbl_NoDataa.hidden = true;
//                        [CommonFunction addBottomLineIngraph:_graphView];
                    }
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            [self updateChartData];

        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
}



- (IBAction)btnSelectYearClicked:(id)sender {
    [self getFeverReport];
    
}
- (IBAction)btnSelectFromDateClicked:(id)sender {
    
    [CommonFunction resignFirstResponderOfAView:self.view];
    pickerForDate = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerForDate.datePickerMode = UIDatePickerModeDate;
    pickerForDate.tag = 0;
    
    [pickerForDate setDate:fromDate];
    [pickerForDate setMaximumDate: [NSDate date]];
    
    
    
    [pickerForDate addTarget:self action:@selector(dueDateChanged:)
            forControlEvents:UIControlEventValueChanged];
    viewOverPicker = [[UIView alloc]initWithFrame:self.view.frame];
    pickerForDate.backgroundColor = [UIColor lightGrayColor];
    viewOverPicker.backgroundColor = [UIColor clearColor];
    [CommonFunction setResignTapGestureToView:viewOverPicker andsender:self];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(doneForPicker:)];
    doneButton.tintColor = [CommonFunction colorWithHexString:@"f7a41e"];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          pickerForDate.frame.size.height-50, self.view.frame.size.width, 50)];
    //    [toolBar setBarTintColor:[UIColor redColor]];
    UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc]
                                    initWithTitle:@"" style:UIBarButtonItemStyleDone
                                    target:nil action:nil];
    //    doneButton2.tintColor = [CommonFunction colorWithHexString:@"f7a41e"];
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0], NSForegroundColorAttributeName: [CommonFunction colorWithHexString:@"f7a41e"]};
    [doneButton2 setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:space,doneButton2,
                             space,doneButton, nil];
    [toolBar setItems:toolbarItems];
    [viewOverPicker addSubview:pickerForDate];
    [viewOverPicker addSubview:toolBar];
    [self.view addSubview:viewOverPicker];
    
}
- (IBAction)btnSelectToDateClciked:(id)sender {
    
    [CommonFunction resignFirstResponderOfAView:self.view];
    pickerForDate = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerForDate.datePickerMode = UIDatePickerModeDate;
    pickerForDate.tag = 1;
    
    [pickerForDate setDate:toDate];
    [pickerForDate setMaximumDate: [NSDate date]];
    
    
    
    [pickerForDate addTarget:self action:@selector(dueDateChanged:)
            forControlEvents:UIControlEventValueChanged];
    viewOverPicker = [[UIView alloc]initWithFrame:self.view.frame];
    pickerForDate.backgroundColor = [UIColor lightGrayColor];
    viewOverPicker.backgroundColor = [UIColor clearColor];
    [CommonFunction setResignTapGestureToView:viewOverPicker andsender:self];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(doneForPicker:)];
    doneButton.tintColor = [CommonFunction colorWithHexString:@"f7a41e"];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          pickerForDate.frame.size.height-50, self.view.frame.size.width, 50)];
    //    [toolBar setBarTintColor:[UIColor redColor]];
    UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc]
                                    initWithTitle:@"" style:UIBarButtonItemStyleDone
                                    target:nil action:nil];
    //    doneButton2.tintColor = [CommonFunction colorWithHexString:@"f7a41e"];
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0], NSForegroundColorAttributeName: [CommonFunction colorWithHexString:@"f7a41e"]};
    [doneButton2 setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:space,doneButton2,
                             space,doneButton, nil];
    [toolBar setItems:toolbarItems];
    [viewOverPicker addSubview:pickerForDate];
    [viewOverPicker addSubview:toolBar];
    [self.view addSubview:viewOverPicker];
    
}

-(void)doneForPicker:(id)sender{
    [self updateChartData];

    [viewOverPicker removeFromSuperview];
    
}
// value change of the date picker
-(void) dueDateChanged:(UIDatePicker *)sender {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    if (sender.tag == 0){
        fromDateString = [dateFormatter stringFromDate:[sender date]];
        fromDate = sender.date;
        [_btnFromDate setTitle:fromDateString forState:UIControlStateNormal];
    }else if (sender.tag == 1){
        toDateString = [dateFormatter stringFromDate:[sender date]];
        toDate = sender.date;
        [_btnToDate setTitle:toDateString forState:UIControlStateNormal];
    }
    
}






#pragma mark - add loder

-(void)addLoder:(NSString *)str{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = str;
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imageName];
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        alertObj.btn2.hidden = false;
        alertObj.btn3.hidden = false;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
         alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.hidden = false;
        alertObj.btn1.tag = firstButtonTag;
        [alertObj.btn1 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn1 addTarget:self
                          action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
    }
    alertObj.transform = CGAffineTransformMakeScale(0.01, 0.01);
   if (![alertObj isDescendantOfView:self.view]) {
        [self.view addSubview:alertObj];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        alertObj.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    
}
-(void)removeAlert{
    if ([alertObj isDescendantOfView:self.view]) {
        [alertObj removeFromSuperview];
    }
    
}

-(IBAction)btnActionForCustomAlert:(id)sender{
    switch (((UIButton *)sender).tag) {
        case Tag_For_Remove_Alert:
            [self removeAlert];
            break;
            
        default:
            
            break;
    }
}


#pragma mark MultipleLinesChartViewController

- (IBAction)slidersValueChanged:(id)sender
{
    
    [self updateChartData];
}

#pragma mark - ChartViewDelegate
- (void)updateChartData
{
    NSArray *colors = @[ChartColorTemplates.vordiplom[0], ChartColorTemplates.vordiplom[1], ChartColorTemplates.vordiplom[2]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[[ChartDataEntry alloc] initWithX:0 y:0]];

    for (int i = 0; i < dataArray.count; i++)
    {
        float val = [[[dataArray objectAtIndex:i] valueForKey:@"temperature"] floatValue];
        [values addObject:[[ChartDataEntry alloc] initWithX:i+1 y:val]];
    }
    
    if (values.count == 1) {
        _graphView.hidden = true;
        _lbl_NoDataa.hidden = false;
    }else{
        _graphView.hidden = false;
        _lbl_NoDataa.hidden = true;
//        [CommonFunction addBottomLineIngraph:_graphView];
    }
    LineChartDataSet *d = [[LineChartDataSet alloc] initWithValues:values label:@"fever"];
    d.lineWidth = 3;
    d.circleRadius = 3.0;
    d.circleHoleRadius = 0.0;

    UIColor *color = [UIColor redColor];
    [d setColor:color];
    
    d.mode = LineChartModeCubicBezier;
    d.drawValuesEnabled =  false;
    [d setCircleColor:color];
    [dataSets addObject:d];
    
    
    ((LineChartDataSet *)dataSets[0]).colors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"SYS"]];
    ((LineChartDataSet *)dataSets[0]).circleColors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"SYS"]];
 
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    _graphView.data = data;
}


- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}



@end
