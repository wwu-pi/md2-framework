// static: \"Supporting Files\"

/***************SCREEN RESOLUTION / DEVICE / ORIENTATION***************/
#define isLandscape
//#define isPortrait

#define isPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define isPhone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define Bounds [[UIScreen mainScreen] bounds]
#define Scale [[UIScreen mainScreen] scale]

#ifdef isLandscape
    #define ScreenResolutionWidth Bounds.size.height * Scale
    #define ScreenResolutionHeight Bounds.size.width * Scale
#else
    #define ScreenResolutionWidth Bounds.size.width * Scale
    #define ScreenResolutionHeight Bounds.size.height * Scale
#endif

/***************GENERAL DIMENSIONS***************/
#define ContentInset 20
#define ContentInsets UIEdgeInsetsMake(ContentInset, ContentInset, ContentInset, ContentInset)
#define ContentOffset CGPointMake(-ContentInset, -ContentInset)

#define PopoverWindowWidth 350.0
#define PopoverWindowHeight 250.0

#define WidgetOffset 10
#define WidgetHeight (((ScreenResolutionHeight * .03) < WidgetMinHeight)? WidgetMinHeight : ScreenResolutionHeight * .03)
#define WidgetMinHeight 20

#define ButtonWidth 30
#define ButtonHeight 30
#define ButtonOffset -4

#define NavigationBarHeight 45

#define SwitchWidth 80
#define SwitchHeight WidgetHeight

#define ColumnSpacing 8
#define RowSpacing 8

#define CenterInset 4

/***************VIEW FRAMES***************/
#define MainFrame CGRectMake(0, 0, ScreenResolutionWidth, ScreenResolutionHeight)
#define ContentViewFrame CGRectMake(0, 0, ScreenResolutionWidth, ScreenResolutionHeight)
#define NavigationBarFrame CGRectMake(0, 0, ScreenResolutionWidth, NavigationBarHeight)
#define ScrollViewFrame CGRectMake(0, 0, ScreenResolutionWidth, ScreenResolutionHeight)
#define ContentViewSize CGSizeMake(ContentFrame.size.width, ContentFrame.size.height)
#define ContentFrame CGRectMake(0, 0, ScreenResolutionWidth - (ContentInset * 2), ScreenResolutionHeight * 3)
#define HelpPickerViewFrame CGRectMake(0, NavigationBarHeight, ScreenResolutionWidth, ScreenResolutionHeight - NavigationBarHeight)

#define ViewFrame ContentFrame//CGRectMake(0, 0, ScreenResolutionWidth, ScreenResolutionHeight)
#define LayoutFrame(bounds) CGRectMake(0, 0, bounds.size.width - (ContentInset * 2), bounds.size.height)

#define HelpViewFrame CGRectMake(0, 0, PopoverWindowWidth, PopoverWindowHeight)
#define HelpScrollViewFrame HelpViewFrame
#define HelpViewContentSize CGSizeMake(HelpTextLabelFrame.size.width, HelpTextLabelFrame.size.height)
#define HelpTextLabelFrame CGRectMake(0, 0, PopoverWindowWidth - (ContentInset * 2), PopoverWindowHeight * 2)
#define HelpNavigationBarFrame(frame) CGRectMake(frame.origin.x, frame.origin.y, PopoverWindowWidth, frame.size.height)

#define PickerViewNavigationBarFrame(frame) CGRectMake(frame.origin.x, frame.origin.y, PopoverWindowWidth, frame.size.height)

#define PopoverContentSize CGSizeMake(PopoverWindowWidth, PopoverWindowHeight)
#define PopoverFrame CGRectMake(0, 0, PopoverWindowWidth, PopoverWindowHeight)
#define PopoverPositionFrame CGRectMake(button.frame.size.width / 2, button.frame.size.height / 2, 1, 1)

/***************WIDGET FRAMES***************/
#define ActualWidth(frame,fraction) (frame.size.width - ButtonWidth) * fraction
#define ActualEnabledWidth(frame,fraction) (frame.size.width - (ButtonWidth * 3) - SwitchWidth) * fraction
#define ActualEntitySelectorWidth(frame,fraction) frame.size.width  * fraction

#define DefaultWidgetFrame(frame) CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, WidgetHeight)

#define WidgetFrame(frame) CGRectMake(frame.origin.x, frame.origin.y, ActualWidth(frame,0.5), WidgetHeight)
#define WidgetLabelFrame(frame) CGRectMake(0, 0, ActualWidth(frame,0.5), WidgetHeight)

#define InfoButtonFrame(frame) CGRectMake(ActualWidth(frame,1), ButtonOffset, ButtonWidth, ButtonHeight)

#define LabelWidgetFrame(frame) CGRectMake(0, 0, frame.size.width, WidgetHeight)

#define TextFieldWidgetFrame(frame) CGRectMake(0, 0, frame.size.width, WidgetHeight)
#define TextFieldFrame(frame) CGRectMake(ActualWidth(frame,0.5), 0, ActualWidth(frame,0.5), WidgetHeight)
#define TextFieldDisabledLabelFrame(frame) CGRectMake(0, 0, frame.size.width - ButtonWidth, frame.size.height)

#define ComboboxTextFieldFrame(frame) CGRectMake(ActualWidth(frame,0.5), 0, ActualWidth(frame,0.5), WidgetHeight)
#define ComboboxTextFieldWidgetFrame(frame) CGRectMake(frame.size.width - (ButtonWidth * 3), 0, ActualWidth(frame,0.5), WidgetHeight)
#define ComboboxPickerButtonFrame(frame) CGRectMake(ActualWidth(frame,1) - ButtonWidth, ButtonOffset, ButtonWidth, ButtonHeight)
#define ComboboxLabelDisabledFrame(frame) CGRectMake(frame.size.width - ButtonWidth * 2, frame.origin.y - CenterInset, ButtonWidth, ButtonHeight)

#define ButtonFrame CGRectMake(0, 0, ButtonWidth, ButtonHeight)
#define ButtonWidgetFrame CGRectMake(0, 0, ButtonWidth, WidgetHeight)
#define ImageFrame(image) CGRectMake(0, 0, image.size.width, image.size.height)
#define ImageWidgetFrame(frm,imageView) CGRectMake(frm.origin.x, frm.origin.y, imageView.frame.size.width, imageView.frame.size.height)

#define DefaultCheckboxWidgetFrame(frame) CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, WidgetHeight + RowSpacing)
#define CheckboxWidgetAdjustedLabelFrame(label) CGRectMake(SwitchWidth + ButtonWidth + WidgetOffset * 2, label.frame.origin.y + CenterInset, label.frame.size.width, label.frame.size.height)
#define CheckboxSwitchFrame CGRectMake(0, 0, SwitchWidth, SwitchHeight)
#define CheckboxLabelFrame(label) CGRectMake(SwitchWidth + ButtonWidth + WidgetOffset * 2, CenterInset, ActualEnabledWidth(frame,0.33), label.frame.size.height)
#define CheckboxInfoButtonFrame CGRectMake(SwitchWidth + WidgetOffset, 0, ButtonWidth, ButtonHeight)

#define EntitySelectorComboboxFrame(frame) CGRectMake(0, 0, frame.size.width, frame.size.height)