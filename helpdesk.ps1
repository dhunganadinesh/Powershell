Add-Type -AssemblyName PresentationFramework
Add-PSSnapin Quest.ActiveRoles.ADManagement 

[xml]$xaml = @"

<Window
    
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="MainWindow" Height="670.7" Width="853" ResizeMode="CanMinimize" WindowStartupLocation="CenterScreen" Background="#FF04616E">
    <Window.Resources>
        <Style x:Key="FocusVisual">
            <Setter Property="Control.Template">
                <Setter.Value>
                    <ControlTemplate>
                        <Rectangle Margin="2" SnapsToDevicePixels="true" Stroke="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}" StrokeThickness="1" StrokeDashArray="1 2"/>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <SolidColorBrush x:Key="Button.Static.Background" Color="#FFDDDDDD"/>
        <SolidColorBrush x:Key="Button.Static.Border" Color="#FF707070"/>
        <SolidColorBrush x:Key="Button.MouseOver.Background" Color="#FF31317C"/>
        <SolidColorBrush x:Key="Button.MouseOver.Border" Color="#FFA2A2E2"/>
        <SolidColorBrush x:Key="Button.Pressed.Background" Color="#FFDEDE92"/>
        <SolidColorBrush x:Key="Button.Pressed.Border" Color="#FF2C628B"/>
        <SolidColorBrush x:Key="Button.Disabled.Background" Color="#FFF4F4F4"/>
        <SolidColorBrush x:Key="Button.Disabled.Border" Color="#FFADB2B5"/>
        <SolidColorBrush x:Key="Button.Disabled.Foreground" Color="#FF838383"/>
        <Style TargetType="{x:Type Button}">
            <Setter Property="FocusVisualStyle" Value="{StaticResource FocusVisual}"/>
            <Setter Property="Background" Value="{StaticResource Button.Static.Background}"/>
            <Setter Property="BorderBrush" Value="{StaticResource Button.Static.Border}"/>
            <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="HorizontalContentAlignment" Value="Center"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="Padding" Value="1"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type Button}">
                        <Border x:Name="border" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" Background="{TemplateBinding Background}" SnapsToDevicePixels="true">
                            <ContentPresenter x:Name="contentPresenter" Focusable="False" HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" Margin="{TemplateBinding Padding}" RecognizesAccessKey="True" SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}" VerticalAlignment="{TemplateBinding VerticalContentAlignment}" OpacityMask="{DynamicResource Button.MouseOver.Border}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsDefaulted" Value="true">
                                <Setter Property="BorderBrush" TargetName="border" Value="{DynamicResource {x:Static SystemColors.HighlightBrushKey}}"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="true">
                                <Setter Property="Background" TargetName="border" Value="{StaticResource Button.MouseOver.Background}"/>
                                <Setter Property="BorderBrush" TargetName="border" Value="{StaticResource Button.MouseOver.Border}"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="true">
                                <Setter Property="Background" TargetName="border" Value="{StaticResource Button.Pressed.Background}"/>
                                <Setter Property="BorderBrush" TargetName="border" Value="{StaticResource Button.Pressed.Border}"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="false">
                                <Setter Property="Background" TargetName="border" Value="{StaticResource Button.Disabled.Background}"/>
                                <Setter Property="BorderBrush" TargetName="border" Value="{StaticResource Button.Disabled.Border}"/>
                                <Setter Property="TextElement.Foreground" TargetName="contentPresenter" Value="{StaticResource Button.Disabled.Foreground}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <SolidColorBrush x:Key="TextBox.Static.Border" Color="#FFABAdB3"/>
        <SolidColorBrush x:Key="TextBox.MouseOver.Border" Color="#FF7EB4EA"/>
        <SolidColorBrush x:Key="TextBox.Focus.Border" Color="#FF569DE5"/>
        <Style TargetType="{x:Type TextBox}">
            <Setter Property="Background" Value="{DynamicResource {x:Static SystemColors.WindowBrushKey}}"/>
            <Setter Property="BorderBrush" Value="{StaticResource TextBox.Static.Border}"/>
            <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="KeyboardNavigation.TabNavigation" Value="None"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
            <Setter Property="AllowDrop" Value="true"/>
            <Setter Property="ScrollViewer.PanningMode" Value="VerticalFirst"/>
            <Setter Property="Stylus.IsFlicksEnabled" Value="False"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type TextBox}">
                        <Border x:Name="border" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" Background="{TemplateBinding Background}" SnapsToDevicePixels="True">
                            <ScrollViewer x:Name="PART_ContentHost" Focusable="false" HorizontalScrollBarVisibility="Hidden" VerticalScrollBarVisibility="Hidden"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsEnabled" Value="false">
                                <Setter Property="Opacity" TargetName="border" Value="0.56"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="true">
                                <Setter Property="BorderBrush" TargetName="border" Value="{StaticResource TextBox.MouseOver.Border}"/>
                            </Trigger>
                            <Trigger Property="IsKeyboardFocused" Value="true">
                                <Setter Property="BorderBrush" TargetName="border" Value="{StaticResource TextBox.Focus.Border}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <MultiTrigger>
                    <MultiTrigger.Conditions>
                        <Condition Property="IsInactiveSelectionHighlightEnabled" Value="true"/>
                        <Condition Property="IsSelectionActive" Value="false"/>
                    </MultiTrigger.Conditions>
                    <Setter Property="SelectionBrush" Value="{DynamicResource {x:Static SystemColors.InactiveSelectionHighlightBrushKey}}"/>
                </MultiTrigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>
    <TabControl HorizontalAlignment="Left" Height="640" VerticalAlignment="Top" Width="843" Background="#FFEFEFF2">
        <TabItem Header="Exchange &amp; DL" Margin="-2,-2,-2,-7">

            <Grid Margin="0,-3,-6,-8" Background="#336B87">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="211*"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="152*"/>
                </Grid.ColumnDefinitions>
                <Canvas Margin="0,0,10.008,428.04">
                    <Canvas HorizontalAlignment="Left" Height="195" VerticalAlignment="Top" Width="480" Background="#2A3132" Margin="0,0,0,0">
                        <Label Content="Mailbox &amp; Calendar Access" Width="390" FontStyle="Normal" Foreground="White" FontFamily="Verdana" Canvas.Top="9" Canvas.Left="-4"/>
                        <Label Content="M or C Name" Canvas.Left="2" Canvas.Top="36" Height="27" Width="118" Foreground="White" FontFamily="Verdana"/>
                        <ComboBox x:Name="ORights" Canvas.Left="334" Canvas.Top="37" Width="89" SelectedIndex="0" Background="#FF28285D" Foreground="#FFA60B0B">
                            <ComboBoxItem Content="Calendar A." HorizontalAlignment="Left" Width="92"/>
                            <ComboBoxItem Content="Calendar E." HorizontalAlignment="Left" Width="92"/>
                            <ComboBoxItem Content="Calendar O." HorizontalAlignment="Left" Width="92"/>
                            <ComboBoxItem Content="Mailbox F." HorizontalAlignment="Left" Width="92"/>
                            <ComboBoxItem Content="Mailbox FS" HorizontalAlignment="Left" Width="92"/>
                        </ComboBox>
                        <TextBox x:Name="OTxtMailboxName" Height="30" Canvas.Left="127" TextWrapping="Wrap" Canvas.Top="35" Width="204" Foreground="#FFD81818"/>
                        <TextBox x:Name="OTxtUsername" Height="30" Canvas.Left="127" TextWrapping="Wrap" Canvas.Top="73" Width="204"/>
                        <Button x:Name="OBtnCheckAccess" Content="Check Access" HorizontalAlignment="Left" VerticalAlignment="Top" Width="88" Height="40" Background="#FF28285D" Canvas.Left="159" Canvas.Top="137" Foreground="#FFFBFBFB"/>
                        <Label Content="Username" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" FontFamily="Verdana" Foreground="White" Canvas.Left="10" Canvas.Top="73"/>
                        <Button x:Name="OBtnProvideAccess" Content="Provide Access" HorizontalAlignment="Left" VerticalAlignment="Top" Width="88" Height="40" Background="#FF28285D" Foreground="White" Canvas.Left="49" Canvas.Top="136">
                            <Button.Resources>
                                <Style TargetType="{x:Type Button}">
                                    <Setter Property="FocusVisualStyle" Value="{StaticResource FocusVisual}"/>
                                    <Setter Property="Background" Value="{StaticResource Button.Static.Background}"/>
                                    <Setter Property="BorderBrush" Value="{StaticResource Button.Static.Border}"/>
                                    <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
                                    <Setter Property="BorderThickness" Value="1"/>
                                    <Setter Property="HorizontalContentAlignment" Value="Center"/>
                                    <Setter Property="VerticalContentAlignment" Value="Center"/>
                                    <Setter Property="Padding" Value="1"/>
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="{x:Type Button}">
                                                <Border x:Name="border" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" Background="{TemplateBinding Background}" SnapsToDevicePixels="true">
                                                    <ContentPresenter x:Name="contentPresenter" Focusable="False" HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" Margin="{TemplateBinding Padding}" RecognizesAccessKey="True" SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}" VerticalAlignment="{TemplateBinding VerticalContentAlignment}" OpacityMask="{DynamicResource Button.Pressed.Background}"/>
                                                </Border>
                                                <ControlTemplate.Triggers>
                                                    <Trigger Property="IsDefaulted" Value="true">
                                                        <Setter Property="BorderBrush" TargetName="border" Value="{DynamicResource {x:Static SystemColors.HighlightBrushKey}}"/>
                                                    </Trigger>
                                                    <Trigger Property="IsMouseOver" Value="true">
                                                        <Setter Property="Background" TargetName="border" Value="{StaticResource Button.MouseOver.Background}"/>
                                                        <Setter Property="BorderBrush" TargetName="border" Value="{StaticResource Button.MouseOver.Border}"/>
                                                    </Trigger>
                                                    <Trigger Property="IsPressed" Value="true">
                                                        <Setter Property="Background" TargetName="border" Value="{StaticResource Button.Pressed.Background}"/>
                                                        <Setter Property="BorderBrush" TargetName="border" Value="{StaticResource Button.Pressed.Border}"/>
                                                    </Trigger>
                                                    <Trigger Property="IsEnabled" Value="false">
                                                        <Setter Property="Background" TargetName="border" Value="{StaticResource Button.Disabled.Background}"/>
                                                        <Setter Property="BorderBrush" TargetName="border" Value="{StaticResource Button.Disabled.Border}"/>
                                                        <Setter Property="TextElement.Foreground" TargetName="contentPresenter" Value="{StaticResource Button.Disabled.Foreground}"/>
                                                    </Trigger>
                                                </ControlTemplate.Triggers>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </Style>
                            </Button.Resources>
                        </Button>
                    </Canvas>
                    <Button x:Name="OBtnRemoveAccess" Content="Remove Access" HorizontalAlignment="Left" VerticalAlignment="Top" Width="115" Height="40"           Background="#FF28285D" Foreground="#FFF1F1F1" Canvas.Left="267" Canvas.Top="136"/>
                </Canvas>
                <Canvas Margin="0,199,10.008,170.04">
                    <Canvas HorizontalAlignment="Left" Height="254" VerticalAlignment="Top" Width="480" Background="#2A3132">
                        <Label Content="Set Out of Office Message" Canvas.Top="1" Width="400" Foreground="White" FontFamily="Verdana"/>
                        <Label Content="Username" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Canvas.Left="10" Canvas.Top="32" FontFamily="Verdana" Foreground="White"/>
                        <TextBox x:Name="OTxtUsernameAR" Height="30" Canvas.Left="127" TextWrapping="Wrap" Canvas.Top="32" Width="204"/>
                        <Label Content="Message" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Canvas.Left="10" Canvas.Top="62" FontFamily="Verdana" Foreground="White"/>
                        <Button x:Name="OBtnSetAutoReply" Content="Set Auto reply" HorizontalAlignment="Left" VerticalAlignment="Top" Width="105" Height="40" Canvas.Top="182" Canvas.Left="128" Background="#FF28285D" Foreground="White"/>
                        <TextBox x:Name="OTxtAutoReplyMSG" AcceptsReturn="True" Height="72" TextWrapping="Wrap" Canvas.Top="97" Width="432"/>
                        <Label x:Name="OMessage" Content="" HorizontalAlignment="Left" VerticalAlignment="Top" Width="479" Canvas.Left="1" Canvas.Top="530"/>
                    </Canvas>
                </Canvas>
                <ListView x:Name="ListMailboxPermission" HorizontalAlignment="Left" Height="606" VerticalAlignment="Top" Width="350" Grid.ColumnSpan="3" Margin="484,0,0,0">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn x:Name="Header1"  Header="Name" DisplayMemberBinding="{Binding Name}" Width="140" />
                            <GridViewColumn x:Name="Header2"  Header="Rights" DisplayMemberBinding="{Binding Rights}" Width="160" />
                        </GridView>
                    </ListView.View>
                </ListView>
                <Canvas HorizontalAlignment="Left" Height="155" Margin="0,458,0,0" VerticalAlignment="Top" Width="480" Background="#2A3132">
                    <Label Content="Check Access" Width="390" FontFamily="Verdana" Foreground="White"/>
                    <Label Content="DL or ACL Name" Canvas.Top="32" Height="27" Width="118" Canvas.Left="-1" FontFamily="Verdana" Foreground="White"/>
                    <TextBox x:Name="OTxtDLName" Height="30" Canvas.Left="131" TextWrapping="Wrap" Canvas.Top="35" Width="204"/>
                    <Button x:Name="BtnGetDLMembers" Content="Get Members" HorizontalAlignment="Left" VerticalAlignment="Top" Width="91" Height="40" Canvas.Left="129" Canvas.Top="96" Background="#FF28285D" Foreground="White"/>
                    <Button x:Name="BtnExportDLMembers" Content="Export List" HorizontalAlignment="Left" VerticalAlignment="Top" Width="88" Height="40" Canvas.Left="243" Canvas.Top="96" Background="#FF28285D" Foreground="White"/>
                    <ComboBox x:Name="DLorACL" Height="30" Canvas.Left="343" Canvas.Top="35" Width="76" SelectedIndex="0" Background="#FF28285D" Foreground="#FFA60B0B">
                        <ComboBoxItem Content="DL" HorizontalAlignment="Left" Width="92" IsSelected="True"/>
                        <ComboBoxItem Content="ACL" HorizontalAlignment="Left" Width="92"/>
                    </ComboBox>
                </Canvas>
            </Grid>
        </TabItem>
        <TabItem Header="Active Directory" Margin="-2,-2,-2,-7" BorderBrush="{x:Null}">
            <TabItem.Background>
                <LinearGradientBrush EndPoint="0,1" StartPoint="0,0">
                    <GradientStop Color="#FFF0F0F0" Offset="0"/>
                    <GradientStop Color="#FFC4C6C7" Offset="1"/>
                </LinearGradientBrush>
            </TabItem.Background>
            <Grid Background="#336B87" Margin="0,-2,-5,-3">
                <Canvas Margin="0,0,362,477.04">
                    <Canvas HorizontalAlignment="Left" Height="140" VerticalAlignment="Top" Width="480" Background="#2A3132" Margin="0,0,0,0">
                        <Label Content="Username" Canvas.Left="18" Canvas.Top="17" Foreground="White" FontFamily="Verdana"/>
                        <TextBox x:Name="TTxtusername" Height="30" Canvas.Left="98" TextWrapping="Wrap" Canvas.Top="17" Width="204"/>
                        <Button x:Name="TUnlockAd" Content="Unlock AD" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="40" Canvas.Top="54" Canvas.Left="13" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnGetADMembership" Content="AD Membership" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="40" Canvas.Top="54" Canvas.Left="128" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnDisableADAccount" Content="Disable Account" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="40" Canvas.Top="89" Canvas.Left="128" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnLoginDT" Content="Login Date/Time" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="40" Canvas.Top="89" Canvas.Left="13" Background="#FF28285D" Foreground="White"/>
                        <ComboBox x:Name="SelectDC" Canvas.Left="241" Canvas.Top="56" Width="125" Background="#FF28285D" Foreground="#FFA60B0B">
                            <ComboBoxItem Content="Select Domain" HorizontalAlignment="Left" Width="123" IsSelected="True"/>
                        </ComboBox>
                        <Button x:Name="BtnPwdReset" Content="Reset Password" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="40" Canvas.Top="89" Canvas.Left="241" Background="#FF28285D" Foreground="White"/>
                    </Canvas>
                </Canvas>
                <TextBox x:Name="TTXTADResult" AcceptsReturn="True" HorizontalAlignment="Left" Height="160" Margin="0,151,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="480" Background="#FF28285D" Foreground="White" FontFamily="Verdana"/>
                <Canvas Margin="0,315,362,157.04">
                    <Canvas HorizontalAlignment="Left" Height="145" VerticalAlignment="Top" Width="480" Background="#2A3132">
                        <Label Content="Folder Path" Canvas.Left="3" Canvas.Top="33" Foreground="White" FontFamily="Verdana"/>
                        <TextBox x:Name="TTxtFolderPath" Height="29" Canvas.Left="98" TextWrapping="Wrap" Canvas.Top="33" Width="372"/>
                        <Button x:Name="BtnFolderACL" Content="Check Folder ACL" HorizontalAlignment="Left" VerticalAlignment="Top" Width="104" Height="40" Canvas.Top="100" Canvas.Left="99" Background="#FF28285D" Foreground="White"/>
                        <Label x:Name="label" Content="Check Folder Access" Height="34" Width="376" Foreground="White" FontFamily="Verdana"/>
                        <Button x:Name="BtnSeeShares_Btn" Content="Get Shared Drives" HorizontalAlignment="Left" VerticalAlignment="Top" Width="104" Height="40" Canvas.Top="100" Canvas.Left="208" Background="#FF28285D" Foreground="White"/>
                        <TextBox x:Name="TxtCIToCopy" AcceptsReturn="True" Height="30" Canvas.Left="98" TextWrapping="Wrap" Canvas.Top="64" Width="372"/>
                        <Label Content="CI Number" Canvas.Left="10" Canvas.Top="66" Foreground="White" FontFamily="Verdana"/>
                        <Button x:Name="BtnCopyContent" Content="Copy Over" HorizontalAlignment="Left" VerticalAlignment="Top" Width="99" Height="40" Canvas.Top="100" Canvas.Left="317" Background="#FF28285D" Foreground="White"/>
                        <Label Content="Split with ,&#xA;for multiple" Canvas.Left="10" Canvas.Top="83" Foreground="White" FontFamily="Verdana" Height="47" Width="84"/>
                        <CheckBox x:Name="checkBox" Content="Recurse" Canvas.Left="416" Canvas.Top="103.862" Height="36.138" Width="64" Background="White" Foreground="#FFFBFBFB"/>
                    </Canvas>
                </Canvas>
                <ListView x:Name="ListADMembership" HorizontalAlignment="Left" Height="455" Margin="486,0,0,0" VerticalAlignment="Top" Width="351">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn x:Name="MembershipHeader"  Header="Type" DisplayMemberBinding="{Binding Name}" Width="140" />
                            <GridViewColumn x:Name="TypeHeader"  Header="Rights" DisplayMemberBinding="{Binding Description}" Width="160" />
                        </GridView>
                    </ListView.View>
                </ListView>
                <Canvas HorizontalAlignment="Left" Height="148" Margin="481,465,0,0" VerticalAlignment="Top" Width="351" Background="#2A3132">
                    <Button x:Name="BtnRemoveAccess" Content="Remove Selected" HorizontalAlignment="Left" VerticalAlignment="Top" Width="99" Height="40" Canvas.Top="10" Canvas.Left="10" Background="#FF28285D" Foreground="White"/>
                    <Button x:Name="BtnRemoveAllDL" Content="Remove All DL" HorizontalAlignment="Left" VerticalAlignment="Top" Width="99" Height="40" Canvas.Top="10" Canvas.Left="242" Background="#FF28285D" Foreground="White"/>
                    <Button x:Name="BtnBackupAccess" Content="Backup Access" HorizontalAlignment="Left" VerticalAlignment="Top" Width="99" Height="40" Canvas.Top="10" Canvas.Left="125" Background="#FF28285D" Foreground="White"/>
                </Canvas>
                <Canvas HorizontalAlignment="Left" Margin="0,465,0,0" Width="480" Background="#2A3132" Height="148" VerticalAlignment="Top">
                    <Label x:Name="label1" Content="Copy Template User" Height="34" Width="376" Foreground="White" FontFamily="Verdana"/>
                    <Label x:Name="label2" Content="Username" Height="30" Canvas.Left="10" Canvas.Top="28" Width="102" Foreground="White" FontFamily="Verdana"/>
                    <Label x:Name="label2_Copy" Content="Copy from" Height="30" Canvas.Left="10" Canvas.Top="68" Width="102" Foreground="White" FontFamily="Verdana"/>
                    <TextBox x:Name="UsernameToModify" Height="25" Canvas.Left="86" TextWrapping="Wrap" Canvas.Top="33" Width="204"/>
                    <TextBox x:Name="UsernameToCopyFrom" Height="23" Canvas.Left="87" TextWrapping="Wrap" Canvas.Top="67" Width="204"/>
                    <Button x:Name="BtnCopyADAccount" Content="Copy Account" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="40" Canvas.Top="100" Canvas.Left="128" Background="#FF28285D" Foreground="White"/>
                </Canvas>
            </Grid>
        </TabItem>
        <TabItem Header="Remote PC" Margin="-2,-2,-2,-7">
            <TabItem.Background>
                <LinearGradientBrush EndPoint="0,1" StartPoint="0,0">
                    <GradientStop Color="White" Offset="0"/>
                    <GradientStop Color="#FFC3C6C7" Offset="1"/>
                </LinearGradientBrush>
            </TabItem.Background>
            <Grid Background="#336B87" Margin="0,-3,-3,-2">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="150*"/>
                    <ColumnDefinition Width="239*"/>
                </Grid.ColumnDefinitions>
                <Canvas Grid.ColumnSpan="2" Margin="0,0,353,457.04">
                    <Canvas HorizontalAlignment="Left" Height="233" VerticalAlignment="Top" Width="487" Background="#2A3132" Margin="0,0,0,0">
                        <Label Content="CI Number" Canvas.Left="4" Canvas.Top="10" Foreground="White" FontFamily="Verdana"/>
                        <TextBox x:Name="TxtCINuber" Height="30" Canvas.Left="81" TextWrapping="Wrap" Canvas.Top="10" Width="204"/>
                        <Button x:Name="BtnPing" Content="Ping" HorizontalAlignment="Left" VerticalAlignment="Top" Width="61" Height="40" Canvas.Top="54" Canvas.Left="119" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnUserLoggedin" Content="User Loggedin" HorizontalAlignment="Left" VerticalAlignment="Top" Width="90" Height="40" Canvas.Top="102" Canvas.Left="8" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnProcess" Content="Process" HorizontalAlignment="Left" VerticalAlignment="Top" Width="71" Height="40" Canvas.Top="54" Canvas.Left="201" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnInstalledApps" Content="Installed Apps" HorizontalAlignment="Left" VerticalAlignment="Top" Width="85" Height="40" Canvas.Top="53" Canvas.Left="10" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnPCDetails" Content="PC Details" HorizontalAlignment="Left" VerticalAlignment="Top" Width="93" Height="40" Canvas.Top="103" Canvas.Left="103" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnEndProcess" Content="End Process" HorizontalAlignment="Left" VerticalAlignment="Top" Width="71" Height="40" Canvas.Top="102" Canvas.Left="201" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnFlushDns" Content="Flush DNS" HorizontalAlignment="Left" VerticalAlignment="Top" Width="71" Height="40" Canvas.Top="54" Canvas.Left="290" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnDisplayDns" Content="Display DNS" HorizontalAlignment="Left" VerticalAlignment="Top" Width="71" Height="40" Canvas.Top="103" Canvas.Left="290" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnRemoveOst" Content="Remove OST" HorizontalAlignment="Left" VerticalAlignment="Top" Width="77" Height="40" Canvas.Top="54" Canvas.Left="375" Background="#FF28285D" Foreground="White"/>
                        <Button x:Name="BtnCopytoH" Content="Desktop to H" HorizontalAlignment="Left" VerticalAlignment="Top" Width="77" Height="40" Canvas.Top="103" Canvas.Left="375" Background="#FF28285D" Foreground="White"/>

                    </Canvas>
                </Canvas>
                <ListView x:Name="ListProcessAndApps" HorizontalAlignment="Left" Height="602" Margin="168,0,0,0" VerticalAlignment="Top" Width="350" Grid.Column="1">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn x:Name="ProcessHeader"  Header="Name" DisplayMemberBinding="{Binding ProcessName}" Width="220" />
                            <GridViewColumn x:Name="IDHeader"  Header="ID" DisplayMemberBinding="{Binding ProcessID}" Width="160" />
                        </GridView>
                    </ListView.View>
                </ListView>
                <TextBox x:Name="TxtPCDetails" HorizontalAlignment="Left" Height="372" Margin="0,235,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="487" Background="#FF28285D" Foreground="White" Grid.ColumnSpan="2" FontFamily="Verdana"/>
            </Grid>
        </TabItem>
        <TabItem Header="Files" Margin="2,-2,-6,-6">
            <TabItem.Background>
                <LinearGradientBrush EndPoint="0,1" StartPoint="0,0">
                    <GradientStop Color="White" Offset="0"/>
                    <GradientStop Color="#FFC3C6C7" Offset="1"/>
                </LinearGradientBrush>
            </TabItem.Background>
            <Grid Background="#336B87" Margin="0,-3,-6,0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="150*"/>
                    <ColumnDefinition Width="239*"/>
                </Grid.ColumnDefinitions>
                <Canvas HorizontalAlignment="Left" Height="148" Margin="0,0,0,0" VerticalAlignment="Top" Width="480" Background="#2A3132" Grid.ColumnSpan="2">
                    <Label Content="Printer Access Lists" Width="390" FontFamily="Verdana" Foreground="White" Canvas.Top="12" Canvas.Left="-2"/>
                    <ComboBox x:Name="DropFile" Height="30" Canvas.Left="8" Canvas.Top="42" Width="96" SelectedIndex="0" Foreground="#FFA60B0B">
                        <ComboBoxItem Content="Select Site" HorizontalAlignment="Left" Width="92" IsSelected="True"/>
                        <ComboBoxItem Content="Albury" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Ballarat" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Bethlehem" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Boronia" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Colac" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="EME" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Fernhill" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Montrose" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Parkville" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="RiceVillage" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Young" HorizontalAlignment="Left" Width="92"/>

                    </ComboBox>
                    <Button x:Name="BtnGetFile" Content="Get File" HorizontalAlignment="Left" VerticalAlignment="Top" Width="71" Height="40" Canvas.Top="39" Canvas.Left="142" Background="#FF28285D" Foreground="White"/>
                </Canvas>
            </Grid>
        </TabItem>


        <TabItem Header="Create Mailbox" Margin="2,-2,-6,-6">
            <TabItem.Background>
                <LinearGradientBrush EndPoint="0,1" StartPoint="0,0">
                    <GradientStop Color="White" Offset="0"/>
                    <GradientStop Color="#FFC3C6C7" Offset="1"/>
                </LinearGradientBrush>
            </TabItem.Background>
            <Grid Background="#336B87" Margin="0,-3,-6,0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="150*"/>
                    <ColumnDefinition Width="239*"/>
                </Grid.ColumnDefinitions>
                <Canvas HorizontalAlignment="Left" Height="354" Margin="0,0,0,0" VerticalAlignment="Top" Width="650" Background="#FF2A3132" Grid.ColumnSpan="2">
                    <ComboBox x:Name="NewMailboxType" Canvas.Left="10" Canvas.Top="27" Width="142" SelectedIndex="0" Background="#FF28285D" Foreground="#FFA60B0B" Height="29.96">
                        <ComboBoxItem Content="Select Mailbox Type" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="UserMailbox" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="SharedMailbox" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="RoomMailbox" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="ExternalContact" HorizontalAlignment="Left" Width="92"/>
                    </ComboBox>
                    <ComboBox x:Name="NewMailboxDB" Canvas.Left="10" Canvas.Top="73" Width="142" SelectedIndex="0" Background="#FF28285D" Foreground="#FFA60B0B" Height="29.96">
                        <ComboBoxItem Content="Select Database" HorizontalAlignment="Left" Width="142" Margin="0,0,-2,0"/>
                        <ComboBoxItem Content="DBAC01" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="DBCS01" HorizontalAlignment="Left" Width="136"/>
                        <ComboBoxItem Content="DBHS01" HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="DBSS01" HorizontalAlignment="Left" Width="138"/>
                    </ComboBox>
                    <TextBox x:Name="TxtFNameForMB" Height="30" Canvas.Left="171" TextWrapping="Wrap" Canvas.Top="27" Width="204" Text="First Name"/>
                    <TextBox x:Name="TxtLNameForMB" Height="30" Canvas.Left="171" TextWrapping="Wrap" Canvas.Top="72" Width="204" Text="Last Name"/>
                    <Button x:Name="BtnCreateMBC" Content="Create Mailbox" HorizontalAlignment="Left" VerticalAlignment="Top" Width="104" Height="40" Canvas.Top="119" Canvas.Left="171" Background="#FF28285D" Foreground="White"/>
                    <Label Content="First Name" Width="75" FontFamily="Verdana" Foreground="White" Canvas.Top="32.416" Canvas.Left="380"/>
                    <Label Content="Last Name" Width="75" FontFamily="Verdana" Foreground="White" Canvas.Top="74.416" Canvas.Left="380"/>
                    <TextBox x:Name="OTxtMailboxCreationDetails" AcceptsReturn="True" Height="72" TextWrapping="Wrap" Canvas.Top="164" Width="432" Canvas.Left="10"/>
                </Canvas>
            </Grid>
        </TabItem>

    </TabControl>
</Window>



"@

$syncHash = [hashtable]::Synchronized(@{})
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$syncHash.Window=[Windows.Markup.XamlReader]::Load( $reader )

function script_path(){
    $path = $MyInvocation.MyCommand.Path
    if (!$path) {$path = $psISE.CurrentFile.Fullpath}
    if ( $path) {$path = split-path $path -Parent}
    set-location $path

}

#uncomment below with server name
<# $script:domainController = "servername"
$connectionURI = "http://servername/PowerShell"

$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $connectionURI -Authentication Kerberos -ErrorAction Stop
Import-PSSession $ExchangeSession -AllowClobber -DisableNameChecking -ErrorAction Stop

#>



Function Ping-PC {
    [CmdletBinding()]
    # This param() block indicates the start of parameters declaration
    param (

        [Parameter(Mandatory)]
        [string]$Computer
    )
   $pingResult = ping $Computer| fl | out-string;
   $TxtPCDetails.Text = $pingResult
}


Function GetProcess(){
if($TxtCINuber.Text -eq ''){
    $TxtPCDetails.Text = "Enter CI number of PC." }
else{  

    $process = Get-WmiObject -Class Win32_Process -ComputerName $TxtCINuber.Text | Sort-Object Name
    $Bindable_Process = $process | Select-Object -Property @{Name='ProcessName';Expression={$_.ProcessName}}, @{Name='ProcessID';Expression={$_.ProcessID}}
    $ListProcessAndApps.ItemsSource = $Bindable_Process
    
    }
}


Function GetUsername{
    param ( [Parameter(Mandatory)]
            [string]$NameOnTextbox )    
    Try{
        $AD_Username =  Get-ADUser $NameOnTextbox -properties SamAccountName |`
                        Select-Object -ExpandProperty SamAccountName
    }#...End Try
    Catch{

        $AD_Username =  Get-ADUser -Filter { anr -eq $NameOnTextbox} -properties DisplayName, `
						Description,EmployeeNumber | Out-GridView -PassThru -Title "Select User" | `
                        Select-Object -ExpandProperty SamAccountName } #...End Catch
    return($AD_Username) #...Return username to calling function
}#...End GetUsername function


Function GetMailboxName{
    param ( [Parameter(Mandatory)]
            [string]$MailboxOnTextbox
        )  
     $AliasName = Get-Mailbox -identity $MailboxOnTextbox.Trim() -ErrorAction Silentlycontinue |`
                  select-Object -ExpandProperty Samaccountname
    
    if(!$AliasName){       
        $AliasName = Get-Mailbox -Anr $MailboxOnTextbox.Trim() | Out-GridView -PassThru -Title "Select Mailbox Name" |`
                     select-Object -ExpandProperty Samaccountname                 
    }#...End If statement
    return($AliasName) #...Return Alias name to calling function
}#...End GetMailbox Function


Function GetMailboxFullName{
    param ( [Parameter(Mandatory)]
            [string]$MailboxOnTextbox
        )  
     $AliasName = Get-Mailbox -identity $MailboxOnTextbox.Trim() -ErrorAction Silentlycontinue |`
                  select-Object -ExpandProperty Name
    
    if(!$AliasName){       
        $AliasName = Get-Mailbox -Anr $MailboxOnTextbox.Trim() | Out-GridView -PassThru -Title "Select Mailbox Name" |`
                     select-Object -ExpandProperty Name                
    }#...End If statement
    return($AliasName) #...Return Alias name to calling function
}


Function CalendarPermission{
   $TxtMailboxName.Text = GetMailboxName($TxtMailboxName.Text)
   $CalendarName = $TxtMailboxName.Text + ":\calendar"
   $x = Get-MailboxfolderPermission -Identity $CalendarName | Select-Object User, AccessRights
   $Bindable_memberof = $x|  Sort-Object User| Select-Object -Property @{Name='Name';Expression={$_.User}} ,@{Name='Rights';Expression={$_.AccessRights }}
   $ListMailboxPermission.ItemsSource = $Bindable_memberof
}


Function MailboxPermission{
   $TxtMailboxName.Text = GetMailboxName($TxtMailboxName.Text)
   #$x = Get-MailboxPermission -Identity $TxtMailboxName.Text | Select-Object User, AccessRights
   #$Bindable_memberof = $x|  Sort-Object User| Select-Object -Property @{Name='Name';Expression={$_.User}} ,@{Name='Rights';Expression={$_.AccessRights }}
   #$ListMailboxPermission.ItemsSource = $Bindable_memberof




   $mbaccess = @()

    $mailboxaccess = Get-MailboxPermission -Identity $TxtMailboxName.Text #| Select-Object User, AccessRights 
    foreach ($x in $mailboxaccess) {
        if($x.User -notlike 'NT AUTHORITY\SELF' -and $x.User -notlike 'NT AUTHORITY\Authenticated Users' -and $x.User -notlike 'NT AUTHORITY\SYSTEM' `
        -and $x.User -notlike 'NT AUTHORITY\NETWORK SERVICE'    ){
    
        $Properties = [ordered]@{'User'=$x.user;'AccessRights'=$x.AccessRights}
        $mbaccess += New-Object -TypeName PSObject -Property $Properties
    
        }
   
    } #end for loop

   $Bindable_memberof = $mbaccess|  Sort-Object User | Select-Object -Property @{Name='Name';Expression={$_.User}} ,@{Name='Rights';Expression={$_.AccessRights }}
   $ListMailboxPermission.ItemsSource = $Bindable_memberof
}

Function MailboxSendAsPermission{
   $TxtMailboxName.Text = GetMailboxFullName($TxtMailboxName.Text)
   $x = Get-ADPermission -Identity $TxtMailboxName.Text | Where-Object{$_.extendedrights -like "*send*"}
   $Bindable_memberof = $x|  Sort-Object User| Select-Object -Property @{Name='Name';Expression={$_.User}} ,@{Name='Rights';Expression={$_.AccessRights }}
   $ListMailboxPermission.ItemsSource = $Bindable_memberof
}

Function RemoveCalendarAccess{
    

    $ToRemove =GetUsername( $ListMailboxPermission.SelectedItem | Select-Object -ExpandProperty Name )
    #write-host $ToRemove
    $CalendarName = $TxtMailboxName.Text + ":\calendar"
    $cad_username =  Get-ADUser $ToRemove -properties SamAccountName | Select-Object -ExpandProperty SamAccountName
    Remove-MailboxFolderPermission -Identity $CalendarName -User $cad_username -Confirm:$false
    calendarPermission
}

Function RemoveMailboxAccess{
    $ToRemove = $ListMailboxPermission.SelectedItem | Select-Object -ExpandProperty Name
    Remove-MailboxPermission -Identity $TxtMailboxName.Text -User $ToRemove -AccessRights FullAccess -Confirm:$false
    MailboxPermission
    
}

function UnlockAdAccount([string]$username){
    $server = $ComboDLList.SelectedItem
    Unlock-ADAccount -Identity $username -Server $server


}

function CalendarAccess(){
     param ( [Parameter(Mandatory)]
            [string]$MailboxName, [string]$username, [string]$AccessRight )
     $calendar = "$MailboxName" + ":\calendar"
     #$err = Add-MailboxFolderPermission -Identity $mailboxCalendar -User $username -AccessRights $AccessRight #-ErrorAction SilentlyContinue
     #$MsgLabel.content = "$err"
     #Write-Host $MailboxName, $username $calendar
}



$esc = [char]27
$nl = [Environment]::NewLine
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

#Start Region Declare firtst tab form items
$TxtMailboxName = $window.FindName("OTxtMailboxName")
$TxtUserName = $window.FindName("OTxtUsername")
$BtnMA = $window.FindName("OBtnProvideAccess")
$Rights = $window.FindName("ORights")
$BtnCheckAccess = $window.FindName("OBtnCheckAccess")

$TxtUserNameAutoReply = $window.FindName("OTxtUsernameAR")
$TxtAutoReply = $window.FindName("OTxtAutoReply")
$BtnSetAutoReply = $window.FindName("OBtnSetAutoReply")
$MsgLabel = $window.FindName("OMessage")

#...End Region Declare first tab form items
#...End Region Clear All
#Start Region Provide Calendar Access
$BtnMA.Add_Click({
   
    $TxtUserName.Text = GetUsername($TxtUserName.Text)
    $TxtMailboxName.Text = GetMailboxName($TxtMailboxName.Text)
    $nameForSendAs = GetMailboxFullName($TxtMailboxName.Text)
    $CalendarName = $TxtMailboxName.Text + ":\calendar"
    switch($Rights.Text){    
        'Calendar A.'{Add-MailboxFolderPermission -Identity $CalendarName -User $TxtUserName.Text -AccessRights "Author"} #-ErrorAction SilentlyContinue
        'Calendar E.'{Add-MailboxFolderPermission -Identity $CalendarName -User $TxtUserName.Text -AccessRights "Editor"}
        'Calendar O.'{Add-MailboxFolderPermission -Identity $CalendarName -User $TxtUserName.Text -AccessRights "Owner"}
        'Mailbox F.' {Add-MailboxPermission -Identity $TxtMailboxName.Text -User $TxtUserName.Text -AccessRights FullAccess }
        'Mailbox FS' {Add-MailboxPermission -Identity $TxtMailboxName.Text -User $TxtUserName.Text -AccessRights FullAccess
                      Add-ADPermission -Identity $nameForSendAs  -User $TxtUserName.Text -AccessRights ExtendedRight -ExtendedRights "Send As"
         }
    }
})


$ListMailboxPermission = $window.FindName("ListMailboxPermission")

$BtnCheckAccess.Add_Click({
    $Header1.Width = "140"
    $Header2.Width = "160"
    switch($Rights.Text){    
        'Calendar A.'{CalendarPermission}
        'Calendar E.'{CalendarPermission}
        'Calendar O.'{CalendarPermission}
        'Mailbox F.' {MailboxPermission}
        'Mailbox FS' {MailboxSendAsPermission}
    }
   
})
#...End Region Provide Calendar Access
#Start Region Remove Mailbox Access
$BtnRemoveAccess = $window.FindName("OBtnRemoveAccess")
$BtnRemoveAccess.Add_Click({
   
    
    switch($Rights.Text){    
        'Calendar A.'{RemoveCalendarAccess} #-ErrorAction SilentlyContinue
        'Calendar E.'{RemoveCalendarAccess}
        'Calendar O.'{RemoveCalendarAccess}
        'Mailbox F.' {RemoveMailboxAccess}
        'Mailbox FS' {RemoveMailboxAccess
                      remove-ADPermission -Identity $nameForSendAs -User $TxtUserName.Text
         }
    }
})

#...End Region Remove Calendar Access
#Start Region Set Auto reply
$OBtnSetAutoReply = $window.FindName("OBtnSetAutoReply")
$OTxtUsernameAR = $window.FindName("OTxtUsernameAR")
$OTxtAutoReply = $window.FindName("OTxtAutoReply")
$richTextBox = $window.FindName("richTextBox")

$OTxtAutoReplyMSG = $window.FindName("OTxtAutoReplyMSG")

$OBtnSetAutoReply.Add_Click({ 
   
    Write-Host $OTxtAutoReplyMSG.text
    $adaccount = GetUsername($OTxtUsernameAR.Text)
    Set-MailboxAutoReplyConfiguration $adaccount -AutoReplyState enabled -ExternalAudience all -InternalMessage $OTxtAutoReplyMSG.text.ToString() -ExternalMessage $OTxtAutoReplyMSG.text.ToString()

    })


#...End region Set Auto Reply
#Start Region Distribution List
$OTxtDLName = $window.FindName("OTxtDLName")
$BtnGetDLMembers = $window.FindName("BtnGetDLMembers")
$Header1 = $window.FindName("Header1")
$Header2 = $window.FindName("Header2")
$BtnExportDLMembers = $window.FindName("BtnExportDLMembers")
$CBUsername = $window.FindName("CBUsername")
$CBEmail = $window.FindName("CBEmail")
$CBTitle = $window.FindName("CBTitle")
$DLorACL = $window.FindName("DLorACL")
$TxtFilter = $window.FindName("TxtFilter")


function GetDL{
    param (

        [Parameter(Mandatory)]
        [string]$FindDL
    )
    #$DLNameResult = 
    return(Get-DistributionGroup -Anr $FindDL| Out-GridView -PassThru -Title "Select Distribution List" | select-Object -ExpandProperty PrimarySMTPAddress)
    
}


function GetDLMembers{
    param (

        [Parameter(Mandatory)]
        [string]$DLName
    )
    return(Get-DistributionGroupMember -Identity $DLName| Sort-Object Name |Select-Object Name, PrimarySMTPAddress)
}



$BtnGetDLMembers.Add_Click({
    $Header1.Header = "Name"
    $Header2.Header = "Email Address"
    if($DLorACL.Text -eq 'DL'){
        
        $OTxtDLName.Text = GetDL($OTxtDLName.Text)
        $x =  GetDLMembers($OTxtDLName.Text)
        $Bindable_memberof = $x|  Sort-Object User| Select-Object -Property @{Name='Name';Expression={$_.Name}} ,@{Name='Rights';Expression={$_.PrimarySMTPAddress }}
        $ListMailboxPermission.ItemsSource = $Bindable_memberof

      }

    else{
        $Header2.Header = "Username"
        $x = Get-ADGroupMember -identity $OTxtDLName.Text  | Sort-Object Name | Select-Object Name, SamAccountName
        $Bindable_memberof = $x|  Sort-Object Name| Select-Object -Property @{Name='Name';Expression={$_.Name}} ,@{Name='Rights';Expression={$_.SamAccountName }}
        $ListMailboxPermission.ItemsSource = $Bindable_memberof
    
    }  
   
})

$TxtFilter.Add_TextChanged({

    $x = $ListMailboxPermission.ItemsSource | Select-Object Name
   # Write-Host $x

        
        #$x | Where-Object -Property Name -Match $TxtFilter.Text
        #$x.where({$_.Name -match $TxtFilter.Text})
        $x= $x.Name -match $TxtFilter.Text
        Write-Host $x
        write-host $TxtFilter.text
    
        #$ListFolderView.ItemsSource = $dir #| ForEach {"{0}`r" -f $_})
        $Bindable_memberof = $x #|  Sort-Object Name | Select-Object -Property @{Name='Name';Expression={$_.Name}} ,@{Name='Rights';Expression={$_.Rights }}
        $ListMailboxPermission.ItemsSource = $Bindable_memberof

})

$BtnExportDLMembers.Add_Click({

<# $DLName = Get-DistributionGroup -Anr $OTxtDLName.Text| Out-GridView -PassThru -Title "Select Distribution List" | select-Object -ExpandProperty PrimarySMTPAddress
$OTxtDLName.Text = $DLName
$DLMembers = Get-DistributionGroupMember -Identity $DLName |Select-Object Name, PrimarySMTPAddress, Alias, Title | Export-Csv -Path C:\temp\dlitems.csv -NoTypeInformation
#>

if($DLorACL.Text -eq 'DL'){
    $DLName = Get-DistributionGroup -Anr $OTxtDLName.Text| Out-GridView -PassThru -Title "Select Distribution List" | select-Object -ExpandProperty PrimarySMTPAddress
    $OTxtDLName.Text = $DLName
    $DLMembers = Get-DistributionGroupMember -Identity $DLName |Select-Object Name, PrimarySMTPAddress, Alias, Title | Export-Csv -Path C:\temp\dlitems.csv -NoTypeInformation
}
if($DLorACL.Text -eq 'ACL'){
    write-host "In the acl"
    $ACLName = get-group -anr $OTxtDLName.Text | out-gridview -PassThru -Title "Select Security group name" | select -ExpandProperty SamAccountname
    $OTxtDLName.Text = $ACLName
    $ACLMembers = Get-ADGroupMember -Identity $ACLName| Select-Object Name, samaccountname | Export-Csv -Path C:\temp\dlitems.csv -NoTypeInformation
}
Invoke-Item C:\temp\dlitems.csv

})
#...End Region Distribution List


#Region for Active Directory Tab
$all_domain = [System.Directoryservices.Activedirectory.Domain]::GetCurrentDomain()
$dcs = @($all_domain| ForEach-Object { $_.DomainControllers }) | Select-Object Name -ExpandProperty Name | Sort-Object Name
$SelectDC = $window.FindName("SelectDC")
$TTXTADResult = $window.FindName("TTXTADResult")
$BtnGetADMembership = $window.FindName("BtnGetADMembership")
$BtnDisableADAccount = $window.FindName("BtnDisableADAccount")
$BtnLoginDT = $window.FindName("BtnLoginDT")
$BtnTUnlockAd = $window.FindName("TUnlockAd")
$TTxtusername = $window.FindName("TTxtusername")
$ListADMembership = $window.FindName("ListADMembership")
$TypeHeader = $window.FindName("TypeHeader")
$BtnPwdReset = $window.FindName("BtnPwdReset")


foreach($dc in $dcs){

    #$SelectDC.items.Add($dc)

}

#Region Unlock account button clicked
$BtnTUnlockAd.Add_Click({    
    $adaccount = GetUsername($TTxtusername.Text)

    Unlock-ADAccount -Identity $adaccount -Server $SelectDC.Text
    Unlock-ADAccount -Identity $adaccount -Server dcpdc05
    #Unlock-ADAccount -Identity $adaccount -Server wmhad01
    #Unlock-ADAccount -Identity $adaccount -Server mhwad01
    })
#...End Region Unlock account
#Start Region Get AD Membership
$BtnGetADMembership.Add_Click({
    $MembershipHeader.Header = "Name"
    $TypeHeader.Header = "Category"
    $MembershipHeader.Width = "160"
    $TypeHeader.width = "160"
    $adaccount = GetUsername($TTxtusername.Text)
    $TTxtusername.Text = $adaccount    
    $member_of = Get-ADPrincipalGroupMembership -Identity $adaccount  #-server dcpdc03
    $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -Property @{Name='Name';Expression={$_.SamAccountName}} ,@{Name='Description';Expression={$_.GroupCategory }}
    $ListADMembership.ItemsSource = $Bindable_memberof

})

#Start Password Reset
$BtnPwdReset.Add_click({
    $adaccount = GetUsername($TTxtusername.Text)
    $TTxtusername.Text = $adaccount
    $newpwd = ConvertTo-SecureString -String "NewPassword" -AsPlainText –Force
    Set-ADAccountPassword $adaccount -NewPassword $newpwd –Reset -Server DCPDC05
    Set-ADuser -Identity $adaccount -ChangePasswordAtLogon $True -Server DcpDC05
})

#...End Password Reset


#...End Region Get AD Membership
#Start Region Get login details
$BtnLoginDT.Add_Click({

    $input_user = $TTxtusername.Text

    if($input_user.StartsWith("7") -or $input_user.StartsWith("1") -or $input_user.StartsWith("2") -or $input_user.StartsWith("3") -or $input_user.StartsWith("4") -or $input_user.StartsWith("5") -or $input_user.StartsWith("6") -or $input_user.StartsWith("8") )
        {
            $adaccount = get-aduser -filter {employeenumber -eq $input_user} |Select-Object  sAMAccountName -ExpandProperty sAMAccountName 
        }else{

         $adaccount = GetUsername($TTxtusername.Text)
    
    }
    $TTxtusername.Text = $adaccount
    $result = Get-QADUser -Identity $adaccount | Select-Object Name, SamAccountname,PrimarySMTPAddress, HomeDirectory, PasswordAge, PasswordStatus, LastLogon, CreationDate, AccountIsLockedOut, AccountIsDisabled, DN   | Out-String
    $emp = Get-ADUser -Identity $adaccount -Properties employeenumber | select employeenumber | out-string
    $result = $result.Trim() + $emp
    $result = $result -replace "SamAccountname", "Username"
    $result = $result -replace "PrimarySMTPAddress", "Email"
    $result = $result -replace "False", "No"
    $result = $result -replace "True", "Yes"
    $TTXTADResult.text = $result
})
#...End Region Get


#Start Disable Account
$BtnDisableADAccount.Add_Click({

$adaccount = GetUsername($TTxtusername.Text)
$TTxtusername.Text = $adaccount
$targetou = "OU=Recently Disabled,OU=Inactive Objects,DC=DOmain,DC=com,DC=au"
$descrption =  Get-ADUser $adaccount -Properties Description | Select-Object -ExpandProperty Description
$name =  Get-ADUser $adaccount -Properties name | Select-Object -ExpandProperty name
#Working on exchange settings.
$date = Get-Date
$newdesc = $descrption + " " + $date.ToString()

Set-ADUser -Identity $adaccount -Description $newdesc
Set-Mailbox -Identity $adaccount -HiddenFromAddressListsEnabled $true
Set-Mailbox -Identity $adaccount -MaxSendSize 0KB -MaxReceiveSize 0KB

#working on backup
$member_of = Get-ADPrincipalGroupMembership -Identity $adaccount  #-server dcpdc03
$Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -ExpandProperty Name
$fileFullname = ('C:\AD and Backups\AD Backup\') + $adaccount + " AD Backup.txt"
$filename = $adaccount + " AD Backup.txt"

        Add-content -Path $fileFullname -Value (Get-Date)
        Add-content -Path $fileFullname -Value $name
        Add-content -Path $fileFullname -Value $Bindable_memberof
        Add-content -Path $fileFullname -Value $nl
        Add-content -Path $fileFullname  -Value $nl


#working on AD object
Disable-ADAccount -Identity $adaccount -Server dcpdc05
Get-ADUser -identity $adaccount | Move-ADObject -TargetPath $targetou

$DLS =  Get-ADPrincipalGroupMembership -Identity $adaccount | Select-Object * | foreach{$_.SamAccountName}
    foreach($dl in $DLS){
        #Write-Host $dl
        Remove-ADGroupMember -Identity "$dl" -Members $adaccount -Confirm:$false #-WarningAction Continue -Server $default_server
    }

$TTXTADResult.text = "Removed access to applications
Removed memberships
Disabled account
Hid email from address book."


})



#... End Region for disable account
 
#Start Region Get Folder Path from Textbox
$BtnFolderACL = $window.FindName("BtnFolderACL")
$TTxtFolderPath = $window.FindName("TTxtFolderPath")
$TTxtFolderPath.Add_TextChanged({
    $MembershipHeader.header = "Folder Path"
    $MembershipHeader.Width = "350"
    $folderPath = $TTxtFolderPath.Text + "*"
    #$dir = @(Get-ChildItem -Directory -path ("{0}*" -f $TTxtFolderPath.Text )  )  | Select -ExpandProperty Name
    $dir = @(Get-ChildItem  -path $folderPath -ErrorAction SilentlyContinue)
    #$ListFolderView.ItemsSource = $dir #| ForEach {"{0}`r" -f $_})
    $Bindable_memberof = $dir
    $ListADMembership.ItemsSource = $Bindable_memberof

})


$ListADMembership.Add_MouseDoubleClick({


    #write-host("Double click")
    $path = $ListADMembership.SelectedItem.ToString()
    #write-host $path
    $TTxtFolderPath.Text = $path + "\"
    

    
      
    #$TTxtFolderPath.Text = $SelectedItem.text


})
#...End Region Get Folder Path from Textbox


#Start Region Get ACL Button
$MembershipHeader = $window.FindName("MembershipHeader")
$ComboAclList = $window.FindName("ComboAclList")

$BtnFolderACL.Add_Click({
    $MembershipHeader.header = "Folder Path"
    $MembershipHeader.Width = "350"
    $selectedItem = $ListADMembership.SelectedItem.FullName
    #$TTxtFolderPath.Text = $TTxtFolderPath.Text
    if($selectedItem.length -eq 0){
        $TTxtFolderPath.Text = $TTxtFolderPath.Text
    }else{$TTxtFolderPath.Text = $selectedItem} 

   <# if($TTxtFolderPath.Text -notmatch '\\$'){
        $TTxtFolderPath.Text = $TTxtFolderPath.Text + "\"
    } #>
    $path = $TTxtFolderPath.Text
    #$TTXTADResult.text = (Get-Acl $path).Access | Out-String


    $Results = @()
    $Folder = $TTxtFolderPath.Text
    $Acl = Get-Acl -Path $Folder
    foreach ($Access in $acl.Access) {
        if ($Access.IdentityReference -notlike "BUILTIN\Administrators" -and $Access.IdentityReference -notlike "domain\Domain Admins" -and $Access.IdentityReference -notlike "CREATOR OWNER" -and $access.IdentityReference -notlike "NT AUTHORITY\SYSTEM") {
            $Properties = [ordered]@{'AD Group'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
            $Results += New-Object -TypeName PSObject -Property $Properties
            }
            }
    $TTXTADResult.Text = $Results | out-string


})


#Start Region Get Network share drives
$NetworkShareResults = @()
$NetworkShare = $window.FindName("BtnSeeShares_Btn")

$NetworkShare.Add_click({
    $NetworkShareServer = $TTxtFolderPath.Text
    #write-host $NetworkShareServer
    $NetworkShareResults = (net view $NetworkShareServer /all| Where-Object { $_ -match '\sDisk\s' }) -replace '\s\s+', ',' | ForEach-Object{ ($_ -split ',')[0] }
    #write-host ($NetworkShareResult | fl *)
    


    $NetResults = @()

    foreach ($NetworkShareResult  in $NetworkShareResults )
    {
   
      #$TargetObject = New-Object PSObject –Property $NetworkShareResult
      #$Target += $TargetObject
      $fulshare = $TTxtFolderPath.Text + '\' + $NetworkShareResult
      $Properties = [ordered]@{'SharedDrive'= $fulshare}
      $NetResults += New-Object -TypeName PSObject -Property $Properties

    }
    $Bindable_memberof = $NetResults |  Select-Object -Property @{Name='Name';Expression={$_.SharedDrive}}
    $ListADMembership.ItemsSource = $Bindable_memberof

})





#...End Get Network share drives







#End Region Check FOlder ACL
#Start Region Remove selected ACL for user
$BtnRemoveAccess = $window.FindName("BtnRemoveAccess")
$BtnRemoveAccess.Add_Click({
    $AclToRemove = $ListADMembership.SelectedItem.Name
    Remove-ADGroupMember -Identity $AclToRemove -Members $TTxtusername.Text -Confirm:$false
    Remove-DistributionGroupMember -Identity $AclToRemove -Member $TTxtusername.Text -Confirm:$false
    Start-Sleep 3.6
    $member_of = Get-ADPrincipalGroupMembership -Identity $TTxtusername.Text #-server dcpdc03
    $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -Property @{Name='Name';Expression={$_.SamAccountName}} ,@{Name='Description';Expression={$_.GroupCategory }}
    $ListADMembership.ItemsSource = $Bindable_memberof
})
#...End Region Remove selected ACL for user
#Start Region Remove all Distribution List
$BtnRemoveAllDL = $window.FindName("BtnRemoveAllDL")
$BtnRemoveAllDL.Add_Click({
    $adaccount =  GetUsername($TTxtusername.Text)
    $TTxtusername.Text = $adaccount 
    $DLS =  Get-ADPrincipalGroupMembership -Identity $adaccount | Where-Object {$_.GroupCategory -eq 'Distribution'} | Select-Object * | foreach{$_.SamAccountName}
    foreach($dl in $DLS){
        #Write-Host $dl
        Remove-ADGroupMember -Identity "$dl" -Members $adaccount -Confirm:$false #-WarningAction Continue -Server $default_server
    }
    $member_of = Get-ADPrincipalGroupMembership -Identity $TTxtusername.Text #-server dcpdc03
    $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -Property @{Name='Name';Expression={$_.SamAccountName}} ,@{Name='Description';Expression={$_.GroupCategory }}
    $ListADMembership.ItemsSource = $Bindable_memberof
})
#...End Region Remove al distribution list
#Start Region backu access
$BtnBackupAccess = $window.FindName("BtnBackupAccess")
$BtnBackupAccess.Add_click({
    $adaccount = Getusername($TTxtusername.Text)
    $TTxtusername.Text = $adaccount
    $testpath = Test-Path('C:\Temp\AD Backup')
    if(Test-Path("c:\Temp")){
    #do nothing    
    }
    else{ New-Item -Path "c:\" -Name "Temp" -ItemType "directory"}

    if(Test-path ("C:\temp\ad backup")){
    #do nothing
    }
    else{ write-host "Folder doesn't exist"
    New-Item -Path "c:\Temp" -Name "AD Backup" -ItemType "directory" } 

    $member_of = Get-ADPrincipalGroupMembership -Identity $adaccount  #-server dcpdc03
    $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -ExpandProperty Name
    $fileFullname = ('C:\Temp\AD Backup\') + $TTxtusername.Text + " AD Backup.txt"
    $filename = $TTxtusername.Text + " AD Backup.txt"
    $filecheck =Test-path ($fileFullname)
    if($filecheck -eq 'True'){
        Add-content -Path $fileFullname -Value (Get-Date)
        Add-content -Path $fileFullname  -Value $nl
        Add-content -Path $fileFullname -Value $Bindable_memberof
        Add-content -Path $fileFullname -Value $nl
        Add-content -Path $fileFullname  -Value $nl
    }

    else{
        New-Item -path 'C:\temp\AD Backup' -Name "$filename" -ItemType "file" -Value (Get-Date)
        Add-content -Path $fileFullname  -Value $nl
        Add-content -Path $fileFullname -Value $Bindable_memberof
        Add-content -Path $fileFullname  -Value $nl
        Add-content -Path $fileFullname  -Value $nl
    }

})
#...End region backup access

#Start region copy template user

$UsernameToModify = $window.FindName("UsernameToModify")
$UsernameToCopy = $window.FindName("UsernameToCopyFrom")
$BtnCopyADAccount = $window.FindName("BtnCopyADAccount")

$DomainController = "Domain.com.au"

$BtnCopyADAccount.Add_Click({

    #Write-Host ($UsernameToCopy.Text)
     #Write-Host ($UsernameToModify.Text)

  <#  if($UsernameToModify.Text -eq ""){
        $TTXTADResult.Text = "Please enter username of user you want to modify"

     }elseif($UsernameToCopy.Text = "") {
     
       $TTXTADResult.Text = "Please enter username of copy user" 
     }

    else{ #>

    $SourceUser = GetUsername($UsernameToModify.Text)
    $CopyUser = GetUsername($UsernameToCopy.Text)

    $UsernameToModify.Text = $SourceUser
    $UsernameToCopy.Text = $CopyUser


    $CopyUserObject = Get-ADUser $CopyUser -Properties Description, Office, telephoneNumber, StreetAddress, City, State, PostalCode, Title, Department, Company, DistinguishedName -Server $DomainController

    $SourceOU = Get-ADUser $SourceUser

    $TargetOU = ($CopyUserObject.DistinguishedName -split ",",2)[1]

    Set-ADUser -Identity $SourceUser -Office $CopyUserObject.Office `
              -StreetAddress $CopyUserObject.StreetAddress -City $CopyUserObject.City -State $CopyUserObject.State -PostalCode $CopyUserObject.PostalCode `
              -Server $DomainController -Verbose

    Get-ADUser -Identity $CopyUserObject -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $SourceUser -Server $DomainController -Verbose #Copy group memberships

    #$Guess=read-host "Another account ? (y/n):" #prompt user to continue
    Move-ADObject -Identity $SourceOU -TargetPath $TargetOU -Server $DomainController -Verbose

    #}

})

#...End region copy template user
#...End Region Active Directory

#Start Region Remote PC Details
#Start Region Ping
$BtnPing = $window.FindName("BtnPing")
$TxtCINuber = $window.FindName("TxtCINuber")
$TxtPCDetails = $window.FindName("TxtPCDetails")
$BtnRemoveOst = $window.FindName("BtnRemoveOst")
$BtnRemoveOst = $window.FindName("BtnRemoveOst")
$BtnCopytoH = $window.FindName("BtnCopytoH")


$BtnPing.Add_Click({
    if($TxtCINuber.Text -eq ""){ $TxtPCDetails.Text = "Enter CI Number of PC"}
    else{
    Ping-PC($TxtCINuber.Text) }
})
#End Region ping
#Start Region Get Process from Remote PC
$BtnProcess = $window.FindName("BtnProcess")
$ListProcessAndApps = $window.FindName("ListProcessAndApps")

$BtnProcess.Add_Click({
    $ProcessHeader.Header = "Process Name"
    $IDHeader.Header = "ID"
    GetProcess($TxtCINuber.Text)
})
#...End Region Get Process from Remote PC
#Start Region End Process
$BtnEndProcess = $window.FindName("BtnEndProcess")
$BtnEndProcess.Add_Click({
    if($TxtCINuber.Text -eq ""){
        $TxtPCDetails.Text = "Enter CI number of PC."
    }
    else{
        #Write-Host "In else loop"
        $process_selected = $ListProcessAndApps.SelectedItem.ProcessName
        #Write-Host $ListProcessAndApps.SelectedItem.ProcessName
        $returnval = (Get-WmiObject -Class Win32_Process -ComputerName $TxtCINuber.Text | ?{ $_.name -eq $process_selected } | %{ $_.Terminate() })
        Write-Warning "Failed to end the process. Review the error message"
        Write-Warning $_.Exception.Message 
        Start-Sleep 3.6
        Getprocess($TxtCINuber)
    }
 })
#...End Regioni End Process

#Start Region PC Details

$BtnPCDetails = $window.FindName("BtnPCDetails")
$BtnPCDetails.Add_Click({
    if($TxtCINuber.Text -eq ""){ $TxtPCDetails.Text = "Enter CI Number of PC"}
    else{
     Try{       
       $caption = Get-WmiObject -class Win32_OperatingSystem -ComputerName $TxtCINuber.Text -ErrorAction Stop| Select-Object  Caption | ForEach{ $_.Caption }
       <#$bootTime = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text -ErrorAction Stop| Select-Object  LastBootUpTime| ForEach{ $_.LastBootUpTime }
       $uptime = (Get-Date) - ($bootTime.ConvertToDateTime($bootTime.lastbootuptime))
       $Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes" #>
       $servicepack = Get-WmiObject -class Win32_OperatingSystem -ComputerName $TxtCINuber.Text| Select-Object  ServicePackMajorVersion | ForEach{ $_.ServicePackMajorVersion }
       $osarch = Get-WmiObject -class Win32_OperatingSystem -ComputerName $TxtCINuber.Text| Select-Object  OSArchitecture | ForEach{ $_.OSArchitecture }
       $build_number = Get-WmiObject -class Win32_OperatingSystem -ComputerName $TxtCINuber.Text| Select-Object  BuildNumber | ForEach{ $_.BuildNumber }
       $host_name = Get-WmiObject -class Win32_OperatingSystem -ComputerName $TxtCINuber.Text| Select-Object  CSName | ForEach{ $_.CSName }
       $pcmodel = Get-WmiObject -Class win32_computersystem -ComputerName $TxtCINuber.Text | Select-Object Model | ForEach {$_.Model}
       
       $disk = Get-WmiObject -Class Win32_logicaldisk -ComputerName $TxtCINuber.Text -Filter "DriveType = '3'" | Select-Object -Property DeviceID, DriveType, VolumeName, @{L='FreeSpaceGB';E={"{0:N2}" -f ($_.FreeSpace /1GB)}},@{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}} | fl | Out-String
       $TxtPCDetails.Text = "OS Version: $caption " + $nl + "Service Pack Version: $servicepack " + $nl + "OS Architecture: $osarch " + $nl + "Build Number: $build_number"  + $nl + "PC Model: " + $pcmodel + $nl + "Host Name: $host_name " + $nl + $nl + "Disk Info: $disk"
   }
   catch{
      $TxtPCDetails.Text = "Unable to connect to PC"  
   } }
})
#...End Regon PC Details
#Start Region User Logged In
$BtnUserLoggedin = $window.FindName("BtnUserLoggedin")
$BtnUserLoggedin.Add_Click({ 
    if($TxtCINuber.Text -eq ""){ $TxtPCDetails.Text = "Enter CI Number of PC"}
    else{
        $pc = $TxtCINuber.Text
        #$username = query user /server:$pc
        $username = Get-WmiObject -Class Win32_computersystem -ComputerName $TxtCINuber.Text | Select-Object -ExpandProperty Username
        $TxtPCDetails.Text = $username }
})
#...End Region User Logged In
#Start Region End Process
#...End Region End Process

#Start Region Get Installed Apps on remote pc
$BtnInstalledApps = $window.FindName("BtnInstalledApps")
$ListProcessAndApps = $window.FindName("ListProcessAndApps")
$IDHeader = $window.FindName("IDHeader")
$ProcessHeader = $window.FindName("ProcessHeader")
$remotepc = $TxtCINuber.Text.ToString()

$BtnInstalledApps.Add_Click({
 if($TxtCINuber.Text -eq ""){ $TxtPCDetails.Text = "Enter CI Number of PC"}
    else{

        $ProcessHeader.Header = "Application Name"
        $IDHeader.Header = "Vendor"
        $installed_apps = Get-Wmiobject -Class Win32_Product -ComputerName $TxtCINuber.Text | select Name, Vendor | sort Name
        $Bindable = $installed_apps | Select-Object -Property @{Name='ProcessName';Expression={$_.Name}}, @{Name='ProcessID';Expression={$_.Vendor}}
        $ListProcessAndApps.ItemsSource = $Bindable


    }
})

#...End region Get installed apps on remote pc 
#Start Region Display Remote PC Dns
$BtnDisplayDns = $window.FindName("BtnDisplayDns")
$BtnDisplayDns.Add_Click({
    $remotepc = $TxtCINuber.Text.ToString()
        script_path
    Try{
        
        $TxtPCDetails.Text = .\PsExec.exe -s \\$remotepc ipconfig /displaydns | fl | out-string
    }Catch{    
            $TxtPCDetails.text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"
    }
})

$BtnRemoveOst.Add_Click({
    $remotepc = $TxtCINuber.Text.ToString()
    $users_path = '\\'+$remotepc + '\c$\users\'
    $username = Get-ChildItem -Path  $users_path

    foreach($username in $username.Name){

    $location  = '\\'+$remotepc +'\c$\users\' + $username + '\appdata\local\Microsoft\Outlook'
    Write-Host $location
    Remove-Item $location\*.ost
    }


})


$BtnCopytoH.Add_Click({
    
    BackUpPC[$remotepc]


})



#...End Region Display Remote PC DNS
#Start Region Remote PC Flush DNS
$BtnFlushDns = $window.FindName("BtnFlushDns")
$BtnFlushDns.Add_Click({
    script_path   
    Try{
        $remotepc = $TxtCINuber.Text.ToString()
        $TxtPCDetails.Text = .\PsExec.exe -s \\$remotepc ipconfig /flushdns | fl | out-string
        $TxtPCDetails.Text = "Cache has been cleared."
    }
    Catch{
    
        $ping_result_show.text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"
    }
})
#...End Region Remote PC Flush DNS
#...End Region Remote PC Details



#...Start Get Files


$BtnGetFile = $window.FindName("BtnGetFile")
$ListFile = $window.FindName("ListFile")



$BtnBrowse = $window.FindName("BtnBrowse")
$TxtCopyFrom = $window.FindName("TxtCopyFrom")
$TxtCIToCopy = $window.FindName("TxtCIToCopy")
$BtnCopyContent = $window.FindName("BtnCopyContent")
$TTxtFolderPath.Text = "\\dcpsccm01\source$\"


$BtnCopyContent.Add_Click({
   $ci_numbers =  $TxtCIToCopy.Text -split ","
   
   $fileSize = Get-ChildItem -Path $TTxtFolderPath.Text -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum | Select-Object @{Name="Size(MB)";Expression={("{0:N2}" -f($_.Sum/1mb))}}

                foreach($ci_number in $ci_numbers)
                   {
                        $destinationPath = "\\" + $ci_number + "\c$\temp"
                        Copy-Item -Path $TTxtFolderPath.Text -Destination $destinationPath -Recurse
                   }

   
   
})


$TxtFNameForMB = $window.FindName("TxtFNameForMB")
$TxtLNameForMB = $window.FindName("TxtLNameForMB")
$BtnCreateMBC = $window.FindName("BtnCreateMBC")

$NewMailboxType = $window.FindName("NewMailboxType")
$NewMailboxDB = $window.FindName("NewMailboxDB")
$OTxtMailboxCreationDetails = $window.FindName("OTxtMailboxCreationDetails")

$BtnCreateMBC.Add_Click({
    #Write-Host $TxtFNameForMB.Text  " "  $TxtLNameForMB.Text

    if($TxtFNameForMB.Text -eq "" -or $TxtLNameForMB.Text -eq ""){
        [System.Windows.MessageBox]::Show('First or Last name cannot be black') #prompt
        
    }else{
            if($NewMailboxDB.Text -eq "Select Database")
            {
                [System.Windows.MessageBox]::Show('Please select the database.')
            
            }else{
                
                if($NewMailboxType.Text -eq "Select Mailbox Type"){
                    
                    [System.Windows.MessageBox]::Show('Please select mailbox type.')
                }
                
                elseif($NewMailboxType.Text -eq 'SharedMailbox'){
                    #create shared mailbox
                    $ResolvedStaffArray.Clear()
                    Clear-Variable ResolvedStaffUsername
                    Clear-Variable ResolvedStaffArray
                    $OU = "OU=Generic Emails,OU=Groups,DC=Domain,DC=com,DC=au"
                    $DC = "DCPDC05.Domain.com.au"

                    $SecurePassword = ConvertTo-SecureString "NewPassword" -AsPlainText -Force
                    $GenericMailboxOU = "OU=Generic Emails,OU=Groups,DC=Domain,DC=com,DC=au"

                    #Get input
                    $FirstName = $TxtFNameForMB.Text
                    $LastName = $TxtLNameForMB.Text
                    $Alias = $FirstName + $LastName
                    $MailboxDB = $NewMailboxDB.Text
                    $DisplayName = $FirstName + " " + $LastName
                    $Description = $DisplayName
                    $ProposedEmailAddress = $Alias+"domain.com.au"
                    $UPN = $FirstName+$LastName+"@domain.com.au"

                    $ResolvedStaffArray = @()

                    #create/Set mailbox/user
                    #New-Mailbox -Shared -UserPrincipalName $UPN -Alias $Alias -Database $MailboxDB -Name $DisplayName -OrganizationalUnit $OU -Password $SecurePassword -FirstName $FirstName -LastName $LastName -DisplayName $DisplayName -ResetPasswordOnNextLogon $false -DomainController $DC
                    #Set-Mailbox -Identity $Alias -EmailAddressPolicyEnabled $false -DomainController $DC
                    #Set-Mailbox -Identity $Alias -PrimarySmtpAddress  $ProposedEmailAddress -DomainController $DC
                    $OTxtMailboxCreationDetails.Text =  Get-Mailbox $Alias | Select-Object Database, SamAccountName, DisplayName, PrimarySmtpAddress 


                }
                elseif($NewMailboxType.Text -eq 'UserMailbox'){
                    $lookfor = ($TxtFNameForMB.Text + " " + $TxtLNameForMB.Text)
                    $UsernametoActivate = GetUsername($lookfor)
                    #Enable-Mailbox -Identity $UsernametoActivate -Database $NewMailboxDB.Text
                    write-host "looking for" + " " + $UsernametoActivate
            
            
                }
                elseif($NewMailboxType.Text -eq 'RoomMailbox'){
            
            
                }
                elseif($NewMailboxType.Text -eq 'ExternalContact'){
            
            
                }else
                {
            
                } #last else for choosing mailbox type
             }#else closing for choosing database type
        }#else closing for checking if the first and last name is empty

})


$window.ShowDialog()
