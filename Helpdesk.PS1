Add-Type -AssemblyName PresentationFramework
Add-PSSnapin Quest.ActiveRoles.ADManagement 
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010



function script_path(){
    $path = $MyInvocation.MyCommand.Path
    if (!$path) {$path = $psISE.CurrentFile.Fullpath}
    if ( $path) {$path = split-path $path -Parent}
    set-location $path

}

$sessions = Get-PSSession | Where-Object {$_.Name -eq "Exchange2013"}
if(!$sessions)
{
    Import-PSSession -Verbose (New-PSSession -Verbose -Name Exchange2013 -ConfigurationName Microsoft.Exchange -ConnectionUri http://(server address)/PowerShell/ -Authentication Kerberos) -AllowClobber
}



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

function GetProcess(){
if($TxtCINuber.Text -eq ''){
    $TxtPCDetails.Text = "Enter Asset Number: " }
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


function GetMailboxName{
    param ( [Parameter(Mandatory)]
            [string]$MailboxOnTextbox
        )  
     $AliasName = Get-Mailbox -identity $MailboxOnTextbox -ErrorAction Silentlycontinue |`
                  select-Object -ExpandProperty Samaccountname
    
    if(!$AliasName){       
        $AliasName = Get-Mailbox -Anr $MailboxOnTextbox | Out-GridView -PassThru -Title "Select Mailbox Name" |`
                     select-Object -ExpandProperty Samaccountname                 
    }#...End If statement
    return($AliasName) #...Return Alias name to calling function
}#...End GetMailbox Function

function GetMailboxFullName{
    param ( [Parameter(Mandatory)]
            [string]$MailboxOnTextbox
        )  
     $AliasName = Get-Mailbox -identity $MailboxOnTextbox -ErrorAction Silentlycontinue |`
                  select-Object -ExpandProperty Name
    
    if(!$AliasName){       
        $AliasName = Get-Mailbox -Anr $MailboxOnTextbox | Out-GridView -PassThru -Title "Select Mailbox Name" |`
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
   $x = Get-MailboxPermission -Identity $TxtMailboxName.Text | Select-Object User, AccessRights
   $Bindable_memberof = $x|  Sort-Object User| Select-Object -Property @{Name='Name';Expression={$_.User}} ,@{Name='Rights';Expression={$_.AccessRights }}
   $ListMailboxPermission.ItemsSource = $Bindable_memberof
}
Function MailboxSendAsPermission{
   $TxtMailboxName.Text = GetMailboxFullName($TxtMailboxName.Text)
   $x = Get-ADPermission -Identity $TxtMailboxName.Text | Where-Object{$_.extendedrights -like "*send*"}
   $Bindable_memberof = $x|  Sort-Object User| Select-Object -Property @{Name='Name';Expression={$_.User}} ,@{Name='Rights';Expression={$_.AccessRights }}
   $ListMailboxPermission.ItemsSource = $Bindable_memberof
}

Function RemoveCalendarAccess{
    $CalendarName = $TxtMailboxName.Text + ":\calendar"
    $ToRemove = $ListMailboxPermission.SelectedItem | Select-Object -ExpandProperty Name
    Remove-MailboxFolderPermission -Identity $CalendarName -User $ToRemove -Confirm:$false
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



[xml]$xaml = @"
<Window
    
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="MainWindow" Height="596" Width="794" ResizeMode="CanMinimize" WindowStartupLocation="CenterScreen">
    <TabControl HorizontalAlignment="Left" Height="568" VerticalAlignment="Top" Width="784" Margin="0,0,0,-1" Background="#FFEFEFF2">
        <TabItem Header="Exchange &amp; DL">

            <Grid Margin="0,-3,0,3" Background="#FFF0F0F0">
                <Canvas HorizontalAlignment="Left" Height="161" Margin="10,10,0,0" VerticalAlignment="Top" Width="399" Background="White">
                    <Label Content="Mailbox &amp; Calendar Access" Width="390"/>
                    <Label Content="M or C Name" Canvas.Left="2" Canvas.Top="36" Height="27" Width="118"/>
                    <ComboBox x:Name="ORights" Canvas.Left="301" Canvas.Top="37" Width="89" SelectedIndex="0">
                        <ComboBoxItem Content="Calendar A." HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Calendar E." HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Calendar O." HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Mailbox F." HorizontalAlignment="Left" Width="92"/>
                        <ComboBoxItem Content="Mailbox FS" HorizontalAlignment="Left" Width="92"/>
                    </ComboBox>
                    <TextBox x:Name="OTxtMailboxName" Height="24" Canvas.Left="94" TextWrapping="Wrap" Canvas.Top="35" Width="204"/>
                    <TextBox x:Name="OTxtUsername" Height="24" Canvas.Left="94" TextWrapping="Wrap" Canvas.Top="73" Width="204"/>
                </Canvas>
                <Label Content="Username" HorizontalAlignment="Left" Margin="10,85,0,0" VerticalAlignment="Top" Width="75"/>
                <Button x:Name="OBtnProvideAccess" Content="Provide Access" HorizontalAlignment="Left" Margin="18,120,0,0" VerticalAlignment="Top" Width="88" Height="30"/>
                <Button x:Name="OBtnCheckAccess" Content="Check Access" HorizontalAlignment="Left" Margin="125,120,0,0" VerticalAlignment="Top" Width="88" Height="30"/>
                <Canvas HorizontalAlignment="Left" Height="190" Margin="10,203,0,0" VerticalAlignment="Top" Width="399" Background="White">
                    <Label Content="Set Out of Office Message" Canvas.Top="1" Canvas.Left="-1" Width="400"/>
                    <Label Content="Username" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Canvas.Left="10" Canvas.Top="32"/>
                    <TextBox x:Name="OTxtUsernameAR" Height="24" Canvas.Left="85" TextWrapping="Wrap" Canvas.Top="32" Width="204"/>
                    <TextBox x:Name="OTxtAutoReply" Height="79" Canvas.Left="85" TextWrapping="Wrap" Canvas.Top="69" Width="304"/>
                    <Label Content="Message" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Canvas.Left="10" Canvas.Top="75"/>
                    <Button x:Name="OBtnSetAutoReply" Content="Set Auto reply" HorizontalAlignment="Left" VerticalAlignment="Top" Width="88" Height="30" Canvas.Left="85" Canvas.Top="153"/>
                </Canvas>
                <Label x:Name="OMessage" Content="" HorizontalAlignment="Left" Margin="1,514,0,0" VerticalAlignment="Top" Width="777"/>
                <ListView x:Name="ListMailboxPermission" HorizontalAlignment="Left" Height="393" Margin="479,0,0,0" VerticalAlignment="Top" Width="299">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn x:Name="Header1"  Header="Name" DisplayMemberBinding="{Binding Name}" Width="140" />
                            <GridViewColumn x:Name="Header2"  Header="Rights" DisplayMemberBinding="{Binding Rights}" Width="160" />
                        </GridView>
                    </ListView.View>
                </ListView>
                <Canvas HorizontalAlignment="Left" Height="120" Margin="10,410,0,0" VerticalAlignment="Top" Width="399" Background="White">
                    <Label Content="Check Access" Width="390"/>
                    <Label Content="DL or ACL Name" Canvas.Top="32" Height="27" Width="118" Canvas.Left="-1"/>
                    <TextBox x:Name="OTxtDLName" Height="24" Canvas.Left="98" TextWrapping="Wrap" Canvas.Top="35" Width="204"/>
                    <Button x:Name="BtnGetDLMembers" Content="Get Members" HorizontalAlignment="Left" VerticalAlignment="Top" Width="91" Height="30" Canvas.Left="95" Canvas.Top="72"/>
                    <Button x:Name="BtnExportDLMembers" Content="Export List" HorizontalAlignment="Left" VerticalAlignment="Top" Width="88" Height="30" Canvas.Left="210" Canvas.Top="72"/>
                    <ComboBox x:Name="DLorACL" Height="24" Canvas.Left="310" Canvas.Top="35" Width="76" SelectedIndex="0">
                        <ComboBoxItem Content="DL" HorizontalAlignment="Left" Width="92" IsSelected="True"/>
                        <ComboBoxItem Content="ACL" HorizontalAlignment="Left" Width="92"/>
                    </ComboBox>
                </Canvas>
                <Button x:Name="OBtnRemoveAccess" Content="Remove Access" HorizontalAlignment="Left" Margin="231,120,0,0" VerticalAlignment="Top" Width="88" Height="30"/>
                <Button x:Name="OneClearAll" Content="Clear All" HorizontalAlignment="Left" Height="36" Margin="431,473,0,0" VerticalAlignment="Top" Width="126"/>
            </Grid>
        </TabItem>
        <TabItem Header="Active Directory">
            <Grid Background="#FFE5E5E5">
                <Canvas HorizontalAlignment="Left" Height="126" VerticalAlignment="Top" Width="376" Background="White">
                    <Label Content="Username" Canvas.Left="18" Canvas.Top="14"/>
                    <TextBox x:Name="TTxtusername" Height="24" Canvas.Left="86" TextWrapping="Wrap" Canvas.Top="17" Width="204"/>
                    <Button x:Name="TUnlockAd" Content="Unlock AD" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="30" Canvas.Top="54" Canvas.Left="13"/>
                    <Button x:Name="BtnGetADMembership" Content="AD Membership" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="30" Canvas.Top="54" Canvas.Left="128"/>
                    <Button x:Name="BtnDisableADAccount" Content="Disable Account" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="30" Canvas.Top="89" Canvas.Left="128"/>
                    <Button x:Name="BtnLoginDT" Content="Login Date/Time" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="30" Canvas.Top="89" Canvas.Left="13"/>
                    <ComboBox x:Name="ComboDLList" Canvas.Left="241" Canvas.Top="56" Width="125">
                        <ComboBoxItem Content="Select Domain" HorizontalAlignment="Left" Width="123" IsSelected="True"/>
                    </ComboBox>
                </Canvas>
                <TextBox x:Name="TTXTADResult" HorizontalAlignment="Left" Height="135" Margin="0,131,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="376"/>
                <Canvas HorizontalAlignment="Left" Height="128" Margin="0,271,0,0" VerticalAlignment="Top" Width="376" Background="White">
                    <Label Content="Folder Path" Canvas.Left="3" Canvas.Top="39"/>
                    <TextBox x:Name="TTxtFolderPath" Height="24" Canvas.Left="74" TextWrapping="Wrap" Canvas.Top="41" Width="275"/>
                    <Button x:Name="BtnFolderACL" Content="Check Folder ACL" HorizontalAlignment="Left" VerticalAlignment="Top" Width="104" Height="30" Canvas.Top="75" Canvas.Left="127"/>
                    <Label x:Name="label" Content="Check Folder Access" Height="34" Width="376"/>
                </Canvas>
                <ListView x:Name="ListADMembership" HorizontalAlignment="Left" Height="409" Margin="398,0,0,0" VerticalAlignment="Top" Width="380">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn x:Name="MembershipHeader"  Header="Type" DisplayMemberBinding="{Binding Name}" Width="140" />
                            <GridViewColumn x:Name="TypeHeader"  Header="Rights" DisplayMemberBinding="{Binding Description}" Width="160" />
                        </GridView>
                    </ListView.View>
                </ListView>
                <Canvas HorizontalAlignment="Left" Height="83" Margin="441,414,0,0" VerticalAlignment="Top" Width="327" Background="White">
                    <Button x:Name="BtnRemoveAccess" Content="Remove Selected" HorizontalAlignment="Left" VerticalAlignment="Top" Width="99" Height="30" Canvas.Top="10" Canvas.Left="10"/>
                    <Button x:Name="BtnRemoveAllDL" Content="Remove All DL" HorizontalAlignment="Left" VerticalAlignment="Top" Width="99" Height="30" Canvas.Top="10" Canvas.Left="227"/>
                    <Button x:Name="BtnBackupAccess" Content="Backup Access" HorizontalAlignment="Left" VerticalAlignment="Top" Width="99" Height="30" Canvas.Top="10" Canvas.Left="118"/>
                </Canvas>
                <Canvas HorizontalAlignment="Left" Height="128" Margin="0,408,0,0" VerticalAlignment="Top" Width="376" Background="White">
                    <Label x:Name="label1" Content="Copy Template User" Height="34" Width="376"/>
                    <Label x:Name="label2" Content="Username" Height="28" Canvas.Left="10" Canvas.Top="28" Width="102"/>
                    <Label x:Name="label2_Copy" Content="Copy from" Height="28" Canvas.Left="10" Canvas.Top="52" Width="102"/>
                    <TextBox x:Name="UsernameToModify" Height="24" Canvas.Left="86" TextWrapping="Wrap" Canvas.Top="33" Width="204"/>
                    <TextBox x:Name="UsernameToCopyFrom" Height="24" Canvas.Left="87" TextWrapping="Wrap" Canvas.Top="67" Width="204"/>
                    <Button x:Name="BtnCopyADAccount" Content="Copy Account" HorizontalAlignment="Left" VerticalAlignment="Top" Width="98" Height="30" Canvas.Top="95" Canvas.Left="128"/>
                </Canvas>
            </Grid>
        </TabItem>
        <TabItem Header="Remote PC">
            <Grid Background="#FFE5E5E5">
                <Canvas HorizontalAlignment="Left" Height="126" VerticalAlignment="Top" Width="371" Background="#FFF9F9F9">
                    <Label Content="Asset Number" Canvas.Left="4" Canvas.Top="10"/>
                    <TextBox x:Name="TxtCINuber" Height="24" Canvas.Left="81" TextWrapping="Wrap" Canvas.Top="10" Width="204"/>
                    <Button x:Name="BtnPing" Content="Ping" HorizontalAlignment="Left" VerticalAlignment="Top" Width="61" Height="30" Canvas.Top="54" Canvas.Left="119"/>
                    <Button x:Name="BtnUserLoggedin" Content="User Loggedin" HorizontalAlignment="Left" VerticalAlignment="Top" Width="90" Height="30" Canvas.Top="88" Canvas.Left="8"/>
                    <Button x:Name="BtnProcess" Content="Process" HorizontalAlignment="Left" VerticalAlignment="Top" Width="61" Height="30" Canvas.Top="54" Canvas.Left="201"/>
                    <Button x:Name="BtnInstalledApps" Content="Installed Apps" HorizontalAlignment="Left" VerticalAlignment="Top" Width="85" Height="30" Canvas.Top="53" Canvas.Left="10"/>
                    <Button x:Name="BtnPCDetails" Content="PC Details" HorizontalAlignment="Left" VerticalAlignment="Top" Width="61" Height="30" Canvas.Top="89" Canvas.Left="119"/>
                    <Button x:Name="BtnEndProcess" Content="End Process" HorizontalAlignment="Left" VerticalAlignment="Top" Width="77" Height="30" Canvas.Top="88" Canvas.Left="201"/>
                    <Button x:Name="BtnFlushDns" Content="Flush DNS" HorizontalAlignment="Left" VerticalAlignment="Top" Width="71" Height="30" Canvas.Top="54" Canvas.Left="290"/>
                    <Button x:Name="BtnDisplayDns" Content="Display DNS" HorizontalAlignment="Left" VerticalAlignment="Top" Width="71" Height="30" Canvas.Top="89" Canvas.Left="290"/>

                </Canvas>
                <ListView x:Name="ListProcessAndApps" HorizontalAlignment="Left" Height="409" Margin="400,0,0,0" VerticalAlignment="Top" Width="378">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn x:Name="ProcessHeader"  Header="Name" DisplayMemberBinding="{Binding ProcessName}" Width="220" />
                            <GridViewColumn x:Name="IDHeader"  Header="ID" DisplayMemberBinding="{Binding ProcessID}" Width="160" />
                        </GridView>
                    </ListView.View>
                </ListView>
                <TextBox x:Name="TxtPCDetails" HorizontalAlignment="Left" Height="278" Margin="0,131,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="371"/>
            </Grid>
        </TabItem>

    </TabControl>
</Window>
"@



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
$OBtnSetAutoReply.Add_Click({    
    $adaccounts = GetUsername($OTxtUsernameAR.Text)
    $Message = $OTxtAutoReply.Text
    Set-MailboxAutoReplyConfiguration $adaccounts -AutoReplyState enabled -ExternalAudience all -InternalMessage “$Message” -ExternalMessage “$Message”
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


$BtnGetDLMembers.Add_Click({
    $Header1.Header = "Name"
    $Header2.Header = "Email Address"
    switch($DLorACL.Text){
        'DL'{
        $DLName = Get-DistributionGroup -Anr $OTxtDLName.Text| Out-GridView -PassThru -Title "Select Distribution List" | select-Object -ExpandProperty PrimarySMTPAddress
        $OTxtDLName.Text = $DLName
        $x =  Get-DistributionGroupMember -Identity $DLName |Select-Object Name, PrimarySMTPAddress
        $Bindable_memberof = $x|  Sort-Object User| Select-Object -Property @{Name='Name';Expression={$_.Name}} ,@{Name='Rights';Expression={$_.PrimarySMTPAddress }}
        $ListMailboxPermission.ItemsSource = $Bindable_memberof
        }

    'ACL'{
        $Header2.Header = "Username"
        $x = Get-ADGroupMember -identity $OTxtDLName.Text  | Sort-Object Name | Select-Object Name, SamAccountName
        $Bindable_memberof = $x|  Sort-Object Name| Select-Object -Property @{Name='Name';Expression={$_.Name}} ,@{Name='Rights';Expression={$_.SamAccountName }}
        $ListMailboxPermission.ItemsSource = $Bindable_memberof
    
    }  
    
    } 
    
        msgbox "Out of office has been set."
 


})

$BtnExportDLMembers.Add_Click({

$DLName = Get-DistributionGroup -Anr $OTxtDLName.Text| Out-GridView -PassThru -Title "Select Distribution List" | select-Object -ExpandProperty PrimarySMTPAddress
$OTxtDLName.Text = $DLName
$DLMembers = Get-DistributionGroupMember -Identity $DLName |Select-Object Name, PrimarySMTPAddress, Alias, Title | Export-Csv -Path C:\temp\dlitems.csv -NoTypeInformation
Invoke-Item C:\temp\dlitems.csv
})
#...End Region Distribution List


#Region for Active Directory Tab
$all_domain = [System.Directoryservices.Activedirectory.Domain]::GetCurrentDomain()
$dcs = @($all_domain| ForEach-Object { $_.DomainControllers }) | Select-Object Name -ExpandProperty Name | Sort-Object Name
$ComboDLList = $window.FindName("ComboDLList")
$TTXTADResult = $window.FindName("TTXTADResult")
$BtnGetADMembership = $window.FindName("BtnGetADMembership")
$BtnDisableADAccount = $window.FindName("BtnDisableADAccount")
$BtnLoginDT = $window.FindName("BtnLoginDT")
$BtnTUnlockAd = $window.FindName("TUnlockAd")
$TTxtusername = $window.FindName("TTxtusername")
$ListADMembership = $window.FindName("ListADMembership")
$TypeHeader = $window.FindName("TypeHeader")


foreach($dc in $dcs){

    $ComboDLList.items.Add($dc)

}

#Region Unlock account button clicked
$BtnTUnlockAd.Add_Click({    
    $adaccount = GetUsername($TTxtusername.Text)
    UnlockAdAccount($adaccount)
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
#...End Region Get AD Membership
#Start Region Get login details
$BtnLoginDT.Add_Click({
    $adaccount = GetUsername($TTxtusername.Text)
    $result = Get-QADUser -Identity $adaccount | Select-Object SamAccountname, HomeDirectory, PasswordAge, PasswordStatus, LastLogon, CreationDate | Out-String
    $TTXTADResult.text = $result
})
#...End Region Get 
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
#...End Region Get Folder Path from Textbox
#Start Region Get ACL Button
$MembershipHeader = $window.FindName("MembershipHeader")
$ComboAclList = $window.FindName("ComboAclList")

$BtnFolderACL.Add_Click({
    $MembershipHeader.header = "Folder Path"
    $MembershipHeader.Width = "350"
    $selectedItem = $ListADMembership.SelectedItem.FullName
    $TTxtFolderPath.Text = $TTxtFolderPath.Text
    if($selectedItem.length -eq 0){
        $TTxtFolderPath.Text = $TTxtFolderPath.Text
    }else{$TTxtFolderPath.Text = $selectedItem}

    if($TTxtFolderPath.Text -notmatch '\\$'){
        $TTxtFolderPath.Text = $TTxtFolderPath.Text + "\"
    }
    $path = $TTxtFolderPath.Text
    $TTXTADResult.text = (Get-Acl $path).Access | Out-String

})
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
$UsernameToCopyFrom = $window.FindName("UsernameToCopyFrom")
$BtnCopyADAccount = $window.FindName("BtnCopyADAccount")

$DomainController = "dcpdc07.mercynet.com.au"

$BtnCopyADAccount.Add_Click({

    if($UsernameToModify.Text -eq ""){
        $TTXTADResult.Text = "Please enter username of user you want to modify"

     }elseif($UsernameToCopyFrom.Text = "") {
     
       $TTXTADResult.Text = "Please enter username of copy user" 
     }

    else{

    $SourceUser = GetUsername($UsernameToModify.Text)
    $CopyUser = GetUsername($UsernameToCopyFrom.Text)

    $CopyUserObject = Get-ADUser $CopyUser -Properties Description, Office, Title, Department, Company, DistinguishedName -Server $DomainController

    $SourceOU = Get-ADUser $SourceUser

    $TargetOU = ($CopyUserObject.DistinguishedName -split ",",2)[1]

    Set-ADUser -Identity $SourceUser -Office $CopyUserObject.Office `
              -StreetAddress $CopyUserObject.StreetAddress -City $CopyUserObject.City -State $CopyUserObject.State -PostalCode $CopyUserObject.PostalCode `
              -Server $DomainController -Verbose

    Get-ADUser -Identity $CopyUserObject -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $SourceUser -Server $DomainController -Verbose #Copy group memberships

    #$Guess=read-host "Another account ? (y/n):" #prompt user to continue
    Move-ADObject -Identity $SourceOU -TargetPath $TargetOU -Server $DomainController -Verbose

    }

})

#...End region copy template user
#...End Region Active Directory

#Start Region Remote PC Details
#Start Region Ping
$BtnPing = $window.FindName("BtnPing")
$TxtCINuber = $window.FindName("TxtCINuber")
$TxtPCDetails = $window.FindName("TxtPCDetails")


$BtnPing.Add_Click({
    if($TxtCINuber.Text -eq ""){ $TxtPCDetails.Text = "Enter Asset Number of PC"}
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
        $TxtPCDetails.Text = "Enter Asset number of PC."
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
    if($TxtCINuber.Text -eq ""){ $TxtPCDetails.Text = "Enter Asset Number of PC"}
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
    if($TxtCINuber.Text -eq ""){ $TxtPCDetails.Text = "Enter Asset Number of PC"}
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

$BtnInstalledApps.Add_Click({
 if($TxtCINuber.Text -eq ""){ $TxtPCDetails.Text = "Enter Asset Number of PC"}
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
        script_path
    Try{
        $remotepc = $TxtCINuber.Text.ToString()
        $TxtPCDetails.Text = .\PsExec.exe -s \\$remotepc ipconfig /displaydns | fl | out-string
    }Catch{    
            $TxtPCDetails.text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"
    }
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

$window.ShowDialog()
