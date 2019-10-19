Add-Type -AssemblyName PresentationFramework
Add-PSSnapin Quest.ActiveRoles.ADManagement 
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

#check if powershell already have exchange connection, if not establish connection
$sessions = Get-PSSession | Where-Object {$_.Name -eq "Exchange2013"}
if(!$sessions)
{
    Import-PSSession -Verbose (New-PSSession -Verbose -Name Exchange2013 -ConfigurationName Microsoft.Exchange -ConnectionUri http://exchangeserver.com.au/PowerShell/ -Authentication Kerberos) -AllowClobber #changer exchanger server address
}

#declare defaul server which is current domain connected to and all the domain controllers(dcs)
$default_server = [System.Directoryservices.Activedirectory.Domain]::GetCurrentDomain()
$dcs = @($all_domain| ForEach-Object { $_.DomainControllers }) | Select-Object Name -ExpandProperty Name | Sort-Object Name

#Get the current path of script, it will be used later to run Pstool from same folder
function script_path(){
    $path = $MyInvocation.MyCommand.Path
    if (!$path) {$path = $psISE.CurrentFile.Fullpath}
    if ( $path) {$path = split-path $path -Parent}
    set-location $path
}

#Ping PC on network
Function Ping-PC {
    [CmdletBinding()]
    # This param() block indicates the start of parameters declaration
    param (

        [Parameter(Mandatory)]
        [string]$Computer
    )

   $ping_result = ping $Computer| fl | out-string;
   $ping_result_show.Text = $ping_result
}

#Find user logged on to declared PC on network
function userloggedon_function(){
    if($cinumber.Text -eq ''){
        $ping_result_show.Text = "Enter CI number of PC."
    }
    else{
    $username = Get-WmiObject -Class Win32_computersystem -ComputerName $cinumber.Text | Select-Object -ExpandProperty Username
    $ping_result_show.Text = $username
    }
}

#Get all the running process of declared PC on network
function getprocess_function(){
    if($cinumber.Text -eq ''){
        $ping_result_show.Text = "Enter CI number of PC."
    }
    else{
		$header1.Header = "Process Name"
		$header3.Header = "ID"   
		$ping_result_show.Text = "Loading ......."
		$process = Get-WmiObject -Class Win32_Process -ComputerName $cinumber.Text -ErrorVariable get_process_error | Sort-Object Name
		$Bindable_Process = $process | Select-Object -Property @{Name='Name';Expression={$_.ProcessName}}, @{Name='ID';Expression={$_.ProcessID}}
		$listview_process.ItemsSource = $Bindable_Process
		$ping_result_show.Text = ""
		if($get_process_error){ $ping_result_show.Text = $get_process_error} #"Unable to retrieve process from " +  $cinumber.Text + ". Check PC is online or is not local PC"}
    }
}

#End task of network PC listed on listview from above function
function endtask_function(){
    if($cinumber.Text -eq ""){
        $ping_result_show.Text = "Enter CI number of PC."
    }
    else{
        $process_selected = $listview_process.SelectedItem.Name
        write-host $process_selected
        Try {
            $returnval = (Get-WmiObject -Class Win32_Process -ComputerName $cinumber.Text | ?{ $_.name -eq $process_selected } | %{ $_.Terminate() })

        } Catch{
            Write-Warning "Failed to end the process. Review the error message"
            Write-Warning $_.Exception.Message
            exit
          }
        Start-Sleep 3.6
        $process = Get-WmiObject -Class Win32_Process -ComputerName $cinumber.Text -ErrorVariable get_process_error | Sort-Object Name
        $Bindable_Process = $process | Select-Object -Property @{Name='Name';Expression={$_.ProcessName}}, @{Name='ID';Expression={$_.ProcessID}}
        $listview_process.ItemsSource = $Bindable_Process
    }
}

#Get all installed apps on network PC and show as listview
function getinstalledapps_function(){
    if($cinumber.Text -eq ""){
        $ping_result_show.Text = "Enter CI number of PC."
    }
    else{
        $header1.Header = "Application Name"
        $header3.Header = "Vendor"
        $installed_apps = Get-Wmiobject -Class Win32_Product -ComputerName $cinumber.Text | select Name, Vendor | sort Name
        $Bindable = $installed_apps | Select-Object -Property @{Name='Name';Expression={$_.Name}}, @{Name='ID';Expression={$_.Vendor}}
        $listview_process.ItemsSource = $Bindable
        $ping_result_show.Text = ""
    }

}

#Get network PC details like Name, Servicepack, OS Architecture, Build number, PC model, Disk space
function pcdetails_function(){ 
   Try{       
       $caption = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text -ErrorAction Stop| Select-Object  Caption | ForEach{ $_.Caption }>
       $servicepack = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text| Select-Object  ServicePackMajorVersion | ForEach{ $_.ServicePackMajorVersion }
       $osarch = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text| Select-Object  OSArchitecture | ForEach{ $_.OSArchitecture }
       $build_number = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text| Select-Object  BuildNumber | ForEach{ $_.BuildNumber }
       $host_name = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text| Select-Object  CSName | ForEach{ $_.CSName }
       $pcmodel = Get-WmiObject -Class win32_computersystem -ComputerName $cinumber.Text | Select-Object Model | ForEach {$_.Model}
       
       $disk = Get-WmiObject -Class Win32_logicaldisk -ComputerName $cinumber.Text -Filter "DriveType = '3'" | Select-Object -Property DeviceID, DriveType, VolumeName, @{L='FreeSpaceGB';E={"{0:N2}" -f ($_.FreeSpace /1GB)}},@{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}} | fl | Out-String
       $ping_result_show.Text = "OS Version: $caption " + $nl + "Service Pack Version: $servicepack " + $nl + "OS Architecture: $osarch " + $nl + "Build Number: $build_number"  + $nl + "PC Model: " + $pcmodel + $nl + "Host Name: $host_name " + $nl + $nl + "$esc Disk Info: $disk"
   }
   catch{
      $ping_result_show.Text = "Unable to connect to PC"  
   }   
}

# XAML for GUI created from Visual Studio. Copy code between <Window> tag to modify GUI with Visual Studio

[xml]$xaml = @"
<Window
    
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="MainWindow" Height="623.557" Width="793.309">
    <TabControl x:Name="tabControl" HorizontalAlignment="Left" Height="589" Margin="6,3,0,0" VerticalAlignment="Top" Width="777">
        <TabItem Header="Remote PC">
            <Grid Background="#FFE5E5E5">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="69*"/>
                    <ColumnDefinition Width="188*"/>
                </Grid.ColumnDefinitions>
                <Label x:Name="label" Content="Enter PC Name" HorizontalAlignment="Left" Height="31" Margin="10,6,0,0" VerticalAlignment="Top" Width="140"/>
                <TextBox x:Name="textBox_CInumber" HorizontalAlignment="Left" Height="28" Margin="131,9,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="155" Grid.ColumnSpan="2"/>
                <ListView x:Name="listView_process" HorizontalAlignment="Left" Height="318" Margin="133,71,0,0" VerticalAlignment="Top" Width="423" Grid.Column="1">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn x:Name="header1" Header="" DisplayMemberBinding="{Binding Name}" />
                            <GridViewColumn x:Name="header3" Header="" DisplayMemberBinding="{Binding ID}" />
                        </GridView>
                    </ListView.View>
                </ListView>
                <Canvas Grid.Column="1" HorizontalAlignment="Left" Height="63" Margin="127,3,0,0" VerticalAlignment="Top" Width="430" Background="#FFC5C5C5">
                    <Button x:Name="button_ping" Content="Ping" HorizontalAlignment="Left" Height="22" VerticalAlignment="Top" Width="135" Canvas.Left="3" Canvas.Top="12"/>
                    <Button x:Name="user_logged_on" Content="User Logged In" HorizontalAlignment="Left" Height="21" VerticalAlignment="Top" Width="137" Canvas.Left="142" Canvas.Top="13"/>
                    <Button x:Name="button_get_process" Content="Process" HorizontalAlignment="Left" Height="21" VerticalAlignment="Top" Width="135" Canvas.Left="3" Canvas.Top="34"/>
                    <Button x:Name="button_end_task" Content="End Task" HorizontalAlignment="Left" Height="21" VerticalAlignment="Top" Width="137" Canvas.Left="142" Canvas.Top="34"/>
                    <Button x:Name="button_get_installed_apps" Content="Get Installed Apps" HorizontalAlignment="Left" Height="21" VerticalAlignment="Top" Width="142" Canvas.Left="284" Canvas.Top="13"/>
                    <Button x:Name="button_pc_details" Content="PC Details" HorizontalAlignment="Left" Height="21" VerticalAlignment="Top" Width="142" Canvas.Left="284" Canvas.Top="34"/>
                </Canvas>
                <Canvas Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="73" Margin="13,358,0,0" VerticalAlignment="Top" Width="316" Background="#FFC5BCBC">
                    <Button x:Name="button_flushdns" Content="Flush DNS" Height="25" Canvas.Left="11" Canvas.Top="5" Width="94"/>
                    <Button x:Name="button_displaydns" Content="DNS Details" Height="25" Canvas.Left="11" Canvas.Top="32" Width="94"/>
                </Canvas>
                <TextBox x:Name="textBlock1" Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="311" Margin="10,42,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="319"/>
                <ProgressBar x:Name="progressbar" HorizontalAlignment="Left" Height="20" Margin="0,541,0,0" VerticalAlignment="Top" Width="329" Grid.ColumnSpan="2"/>
            </Grid>
        </TabItem>
        <TabItem Header="Active Directory">
            <Grid Background="#FFE5E5E5" Margin="10,0,-6,2">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="5*"/>
                    <ColumnDefinition Width="19*"/>
                    <ColumnDefinition Width="54*"/>
                </Grid.ColumnDefinitions>
                <Canvas Grid.ColumnSpan="3" HorizontalAlignment="Left" Height="205" Margin="10,10,0,0" VerticalAlignment="Top" Width="415" Background="#FFB9B9B9">
                    <Label x:Name="label1" Content="Username" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="68" Canvas.Left="10" Canvas.Top="22"/>
                    <TextBox x:Name="textBox_username" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" VerticalAlignment="Top" Width="159" Canvas.Left="83" Canvas.Top="27"/>
                    <Button x:Name="button_lastlogon" Content="Last Logon" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="81" Canvas.Left="-3" Canvas.Top="210"/>
                    <Button x:Name="button_memberof" Content="Member Of" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="81" Canvas.Left="83" Canvas.Top="210"/>
                    <Button x:Name="button_AU" Content="Unlock" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="81" Canvas.Left="169" Canvas.Top="210"/>
                    <TextBox Height="150" x:Name="textbox_lastlogon" TextWrapping="Wrap" Text="" Canvas.Top="55" Width="415"/>
                </Canvas>
                <ListView x:Name="listView_membership" Grid.Column="2" HorizontalAlignment="Left" Height="337" Margin="192,10,0,0" VerticalAlignment="Top" Width="329">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn x:Name="memberof_header1" Header="Member Of" DisplayMemberBinding="{Binding ACLName}" />
                            <GridViewColumn x:Name="memberof_header2" Header="Type" DisplayMemberBinding="{Binding Description}" />
                        </GridView>
                    </ListView.View>
                </ListView>
                <Canvas Grid.ColumnSpan="3" HorizontalAlignment="Left" Height="156" Margin="8,282,0,0" VerticalAlignment="Top" Width="415" Background="#FFBDBDBD">
                    <Label x:Name="label3" Content="Folder Path" Height="25" Canvas.Left="10" Canvas.Top="22" Width="94"/>
                    <Button x:Name="button_openfile" Content="..." Height="29" Canvas.Left="375" Canvas.Top="22" Width="40"/>
                    <Button x:Name="button_folderaccess" Content="Check Folder ACL" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="119" Canvas.Left="87" Canvas.Top="66"/>
                </Canvas>
                <TextBox x:Name="textBox_folderpath" Grid.ColumnSpan="2" Grid.Column="1" HorizontalAlignment="Left" Height="30" Margin="43,304,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="293"/>
                <Button x:Name="button1" Content="Button" Grid.Column="2" HorizontalAlignment="Left" Margin="852,74,-396,0" VerticalAlignment="Top" Width="75"/>
                <Button x:Name="button_remove_memberof" Content="Remove Access" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="109" Grid.Column="2" Margin="192,352,0,0"/>
                <Button x:Name="button_remove_distribution" Content="Remove DL Access" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="109" Grid.Column="2" Margin="192,381,0,0"/>
                <Button x:Name="button_backup" Content="Backup Access" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="109" Grid.Column="2" Margin="192,410,0,0"/>
                <Button x:Name="Button_Disable_Account" Content="Disable Account" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="121" Margin="28,220,0,0" Grid.Column="2"/>

            </Grid>
        </TabItem>
        <TabItem Header="Distribution List" Margin="-2,-2,-2,0">
            <Grid Background="#FFE5E5E5" Margin="10,0,-6,2">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="49*"/>
                    <ColumnDefinition Width="187*"/>
                    <ColumnDefinition Width="531"/>
                </Grid.ColumnDefinitions>
                <Label Grid.ColumnSpan="2" Content="DL Name" HorizontalAlignment="Left" Height="30" Margin="10,10,0,0" VerticalAlignment="Top" Width="115"/>
                <TextBox x:Name="TxtDL" Grid.Column="1" HorizontalAlignment="Left" Height="23" Margin="33,14,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="288" Grid.ColumnSpan="2"/>
                <Button x:Name="Get_DL"  Content="Get Members" Grid.Column="1" HorizontalAlignment="Left" Height="29" Margin="33,45,0,0" VerticalAlignment="Top" Width="93"/>
                <Button x:Name="Export_DL"  Content="Export" Grid.Column="1" HorizontalAlignment="Left" Height="29" Margin="142,45,0,0" VerticalAlignment="Top" Width="93" Grid.ColumnSpan="2"/>

            </Grid>
        </TabItem>
        <TabItem Header="Exchange" Margin="-2,-2,-2,0">
            <Grid Background="#FFE5E5E5" Margin="10,0,-6,2">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="5*"/>
                    <ColumnDefinition Width="19*"/>
                    <ColumnDefinition Width="54*"/>
                </Grid.ColumnDefinitions>
                <Canvas Grid.ColumnSpan="3" HorizontalAlignment="Left" Height="171" Margin="10,20,0,0" VerticalAlignment="Top" Width="402" Background="#FFCFCFCF">
                    <Label Content="Calendar Access" Width="402" Background="#FF11B1D2"/>

                    <Label Content="Calendar Name" Height="30" Canvas.Top="31" Width="153"/>
                    <Label Content="Name or Username" Height="30" Canvas.Top="62" Width="153"/>
                    <TextBox Height="25" Canvas.Left="168" TextWrapping="Wrap" Canvas.Top="32" Width="166" x:Name="TextBox_CalendarName"/>
                    <TextBox Height="25" Canvas.Left="169" TextWrapping="Wrap" Canvas.Top="68" Width="166" x:Name="TextBox_UserName"/>
                    <ComboBox x:Name="CalendarAccess" Canvas.Left="10" Canvas.Top="107" Width="120">
                        <ComboBoxItem Content="Author"/>
                        <ComboBoxItem Content="Editor"/>
                        <ComboBoxItem Content="Owner"/>
                    </ComboBox>
                    <Button Content="Provide Access" Height="33" Canvas.Left="169" Canvas.Top="107" Width="97" x:Name="Button_CalendarAccess"/>

                </Canvas>
                <Canvas Grid.ColumnSpan="3" HorizontalAlignment="Left" Height="155" Margin="10,210,0,0" VerticalAlignment="Top" Width="402" Background="#FFDED7D7">
                    <Label Content="Mailbox Name" Height="24" Canvas.Top="40" Width="126"/>
                    <Label Content="Name or Username" Height="24" Canvas.Top="77" Width="126"/>
                </Canvas>
                <Label Grid.ColumnSpan="3" Content="Mailbox Access" HorizontalAlignment="Left" Height="26" Margin="10,212,0,0" VerticalAlignment="Top" Width="402" Background="#FF11B1D2"/>
                <TextBox x:Name="TxtMailboxName" Grid.ColumnSpan="2" Grid.Column="1" HorizontalAlignment="Left" Height="24" Margin="121,250,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="181"/>
                <TextBox x:Name="TxtUsernameMailAccess" Grid.ColumnSpan="2" Grid.Column="1" HorizontalAlignment="Left" Height="24" Margin="121,291,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="181"/>
                <Button Content="Provide Access" Height="33" Canvas.Left="198" Canvas.Top="325" Width="97" x:Name="Button_MailboxAccess" Margin="123,320,498,206" Grid.Column="1" Grid.ColumnSpan="2"/>
                <ComboBox x:Name="MaibloxAccess" Grid.ColumnSpan="2" Margin="23,331,93,206">
                    <ComboBoxItem Content="FullAccess"/>
                    <ComboBoxItem Content="Send Permission"/>
                </ComboBox>
            </Grid>
        </TabItem>
    </TabControl>
</Window>
"@

#############################################################################################
$nl = [Environment]::NewLine #Variable to insert new line on powershell script
$reader = (New-Object System.Xml.XmlNodeReader $xaml)	#To display XAML code with Powershell
$window = [Windows.Markup.XamlReader]::Load($reader)
########################################################### Tab 1 Ping Program Start
################################ Variable declaration for form items on Tab1 start

#Declaring variable for first Tab
$ping_result_show = $window.FindName("textBlock1")
$pingButton = $window.FindName("button_ping")
$cinumber = $window.FindName("textBox_CInumber")
$user_logged_on = $window.FindName("user_logged_on")
$get_process = $window.FindName("button_get_process")
$listview_process = $window.FindName("listView_process")
$end_task = $window.FindName("button_end_task")
$header1 = $window.FindName("header1")
$header2 = $window.FindName("header2")
$header3 = $window.FindName("header3")
$cinumber.Text = "CI00"
$get_installed_apps = $window.FindName("button_get_installed_apps")
$button_pc_details = $window.FindName("button_pc_details")
$button_flushdns = $window.FindName("button_flushdns")
$button_displaydns = $window.FindName("button_displaydns")

#Call ping function
$pingButton.Add_Click({
        Ping-PC $cinumber.Text
})

#Call function to find user logged on network PC
$user_logged_on.Add_Click({
    userloggedon_function
})

#Call function to get process on network PC
$get_process.Add_Click({
    getprocess_function  

})

#Call function to end task on network PC
$end_task.Add_Click({
    endtask_function
})

#Get installed PC on network PC
$get_installed_apps.Add_Click({
    getinstalledapps_function
})

#Get PC details from network PC
$button_pc_details.Add_Click({
    pcdetails_function
})

#Flush network PC dns cache
$button_flushdns.Add_Click({
    script_path
    Write-Host "Outsite try"    
    Try{
        Write-Host "Inside"
        $remotepc = $cinumber.Text.ToString()
        $ping_result_show.Text = .\PsExec.exe -s \\$remotepc ipconfig /flushdns | fl | out-string
        $ping_result_show.Text = "Cache has been cleared."
    }
    Catch{
    
        $ping_result_show.text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"
    }
})

#Display Dns of network PC
$button_displaydns.Add_Click({
        script_path
    Try{
        $remotepc = $cinumber.Text.ToString()
        $ping_result_show.Text = .\PsExec.exe -s \\$remotepc ipconfig /displaydns | fl | out-string
    }Catch{    
            $ping_result_show.text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"
    }
})

#Start of second tab Active Directory

$username_lastlogon = $window.FindName("textBox_username")
$lastlogon = $window.FindName("button_lastlogon")
$textbox_result =$window.FindName("textbox_lastlogon")
$button_memberof =$window.FindName("button_memberof")
$listview_memberof = $window.FindName("listView_membership")
$memberof_header1 = $window.FindName("memberof_header1")
$memberof_header2 = $window.FindName("memberof_header2")
$button_remove_memberof = $window.FindName("button_remove_memberof")
$button_remove_distribution = $window.FindName("button_remove_distribution")
$button_backup = $window.FindName("button_backup")
$button_AU = $window.FindName("button_AU")
$button_DisableAC = $window.FindName("Button_Disable_Account")
$button_remove_distribution = $window.FindName("button_remove_distribution")
$button_folderaccess = $window.FindName("button_folderaccess")
$textBox_folderpath= $window.FindName("textBox_folderpath")

#Get last logon detail of AD user
$lastlogon.Add_Click({
    $result = Get-ADUser -Identity $username_lastlogon.text -Properties LastLogon -server $default_server | Format-Table UserPrincipalName, @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogon)}} | fl | out-string; #Just retrivie username and last logon date adnd time
    $textbox_result.text = $result
})

#Get all group membership of AD user
$button_memberof.Add_Click({    
    Try{
        $member_of = Get-ADPrincipalGroupMembership -Identity $username_lastlogon.text -server $default_server #Get group membership of ad user.
        $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -Property @{Name='ACLName';Expression={$_.Name}} ,@{Name='Description';Expression={$_.GroupCategory }} #binding data to show as listview
        $listview_memberof.ItemsSource = $Bindable_memberof #loading data on list view
    }
    Catch{        
        $textbox_result.text = ""
        $adaccounts =  Get-ADUser -Filter { anr -eq $username_lastlogon.Text} -properties DisplayName, `
									Description,EmployeeNumber | Out-GridView -PassThru -Title "Select User" | `
                                     Select-Object -ExpandProperty SamAccountName        
        $username_lastlogon.Text = $adaccounts
        $member_of = Get-ADPrincipalGroupMembership -Identity $username_lastlogon.text -server $default_server
        $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -Property @{Name='ACLName';Expression={$_.Name}} ,@{Name='Description';Expression={$_.GroupCategory }}
        $listview_memberof.ItemsSource = $Bindable_memberof
    }

})

#backup users group membership on C:\Temp:\AD Backup folder for future reference.
$button_backup.Add_Click({
    $testpath = Test-Path('C:\Temp\AD Backup')
    if(Test-Path("c:\Temp")){
        pass    
    }
    else{

        New-Item -Path "c:\" -Name "Temp" -ItemType "directory"    
    }

    if(Test-path ("C:\temp\ad backup")){
        pass
    }
    else{
        write-host "Folder doesn't exist"
        New-Item -Path "c:\Temp" -Name "AD Backup" -ItemType "directory"
    } 

    $member_of = Get-ADPrincipalGroupMembership -Identity $username_lastlogon.text #-server dcpdc03
    $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -ExpandProperty Name
    $file_fullname = ('C:\Temp\AD Backup\') + $username_lastlogon.Text + " AD Backup.txt"
    $filename = $username_lastlogon.Text + " AD Backup.txt"
    $filecheck =Test-path ($file_fullname)
    if($filecheck -eq 'True'){
        Add-content -Path $file_fullname -Value (Get-Date)
        Add-content -Path $file_fullname  -Value $nl
        Add-content -Path $file_fullname -Value $Bindable_memberof
        Add-content -Path $file_fullname  -Value $nl
        Add-content -Path $file_fullname  -Value $nl
    }

    else{
        New-Item -path 'C:\temp\AD Backup' -Name "$filename" -ItemType "file" -Value (Get-Date)
        Add-content -Path $file_fullname  -Value $nl
        Add-content -Path $file_fullname -Value $Bindable_memberof
        Add-content -Path $file_fullname  -Value $nl
        Add-content -Path $file_fullname  -Value $nl
    }
    $textbox_result.text = "$"

})
#Unlock account from all AD "Takes lot of time", better modify DC to have limited server
$button_AU.Add_Click({
    Try{
        $textbox_result.text = ""
        $adaccounts =  Get-ADUser $username_lastlogon.Text -properties SamAccountName | Select-Object -ExpandProperty SamAccountName
        $textbox_result.text = "Account Unlocked"
    }
    Catch{
        $textbox_result.text = ""
        $adaccounts =  Get-ADUser -Filter { anr -eq $username_lastlogon.Text} -properties DisplayName, `	# Ambiguous Name Resolution search for username if the above username is incorrect.
									Description,EmployeeNumber | Out-GridView -PassThru -Title "Select User" | `
                                     Select-Object -ExpandProperty SamAccountName
        
        $username_lastlogon.Text = $adaccounts
        $textbox_result.text = "Account Unlocked"
    }
    foreach ($DC in $dcs){
                Unlock-ADAccount -Identity $username_lastlogon.Text -Server $DC -ErrorAction SilentlyContinue
                $unlock_msg = "Account $adaccounts unlocked from $dc.$nl"
                $output = $output + $unlock_msg                               
            }
            $textbox_result.Text = (Get-Date).ToString + $output
            
})

#Disable account. 
$button_DisableAC.Add_Click({
    Try
    {
        $disabled_ou = 'domain.com.au/Inactive Objects/Recently Disabled'  #modify the domain get path for Disabled OU to moved disabled account
        Set-Mailbox -Identity $username_lastlogon.Text -MaxSendSize 0kb -MaxReceiveSize 0kb #Set exchange mailbox send size and receive size to 0KB.
        Disable-ADAccount -Identity $username_lastlogon.Text
        Set-ADUser -Identity $username_lastlogon.Text -description Get-Date #Change description as date for disabled account.
        Move-ADObject -Identity $username_lastlogon.Text -TargetPath $disabled_ou -Verbose #finally move to disabled ou.
    }
    Catch
    {
		write-host "Error"
    }
})

#Remove user from all distribution list, won't remove from Universal security group.
$button_remove_distribution.Add_Click({   
    Try{
        $DLS =  Get-ADPrincipalGroupMembership -Identity $username_lastlogon.text -ErrorAction Stop| Where-Object {$_.GroupCategory -eq 'Distribution'} | foreach{$_.SamAccountName}
        foreach($dl in $DLS){
            Write-Host $dl
            Remove-ADGroupMember -Identity "$dl" -Members $username_lastlogon.Text #-WarningAction Continue -Server $default_server    
        }
    }
    Catch{
        $adaccounts =  Get-ADUser -Filter { anr -eq $username_lastlogon.Text} -properties DisplayName, `
									Description,EmployeeNumber | Out-GridView -PassThru -Title "Select User" | `
                                     Select-Object -ExpandProperty SamAccountName
        
        $username_lastlogon.Text = $adaccounts
        $DLS =  Get-ADPrincipalGroupMembership -Identity $username_lastlogon.text | Where-Object {$_.GroupCategory -eq 'Distribution'} | Select-Object * | foreach{$_.SamAccountName}
        foreach($dl in $DLS){
            Write-Host $dl
            Remove-ADGroupMember -Identity "$dl" -Members $username_lastlogon.Text #-WarningAction Continue -Server $default_server    
        }
    }
})

#Remove selected group membership fron listview
$button_remove_memberof.Add_Click({
        
       $AclToRemove = $listview_memberof.SelectedItem.ACLName
       Remove-ADGroupMember -Identity "$AclToRemove" -Members $username_lastlogon.Text
       Start-Sleep 3.6
       $member_of = Get-ADPrincipalGroupMembership -Identity $username_lastlogon.text #-server dcpdc03
       $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -Property @{Name='ACLName';Expression={$_.Name}} ,@{Name='Description';Expression={$_.GroupCategory }}
       $listview_memberof.ItemsSource = $Bindable_memberof
})

#Displays folder access list 
$button_folderaccess.Add_Click({
    $path = $textBox_folderpath.Text
    if(Test-path $path){
        $path_length = $path.Length
        $trim_path = icacls  $path
        $trim_path= $trim_path.TrimStart($path)
        #$trim_path = $trim_path -match '(?<=\\)(?<x>.*?)(?=:)'
        [regex]$rx = '(?<=\\)(?<x>.*?)(?=:)'
        $result = $rx.Matches($trim_path) | Select-Object -ExpandProperty Value 
        $textbox_result.Text = $result | fl | Out-String
    }
    else {
        $textbox_result.Text = "Please check path. "
           }
})
$open_file = $window.FindName("button_openfile")
$open_file.Add_Click({
    Write-Host "Clicked"
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{Multiselect = $true}
    [void]$FileBrowser.ShowDialog()
    $textBox_folderpath.Text = $FileBrowser.FileNames 

})

#New Tab for Distribution list
$TxtDL = $window.FindName("TxtDL")
$BtnGetDL = $window.FindName("Get_DL")
$TxtCalendar = $window.FindName("TextBox_CalendarName")
$TxtUsername = $window.FindName("TextBox_UserName")
$Button_CalendarAccess = $window.FindName("Button_CalendarAccess")
$CalendarAccessLevel = $window.FindName("CalendarAccess")
$CalendarAccessLevel.Text = "Author"

$BtnGetDL.Add_Click({
		$x = Get-DistributionGroupMember -Identity $TxtDL.Text -ErrorAction SilentlyContinue | Select-Object Name, PrimarySMTPAddress, Alias   
        if(!$x){
			$DLName = Get-DistributionGroup -Anr $TxtDL.Text| Out-GridView -PassThru -Title "Select Distribution List" | select-Object -ExpandProperty PrimarySMTPAddress
			$TxtDL.Text = $DLName			              
        }
        $DLMembers = Get-DistributionGroupMember -Identity $DLName |Select-Object Name, PrimarySMTPAddress, Alias 
        $Manager = Get-DistributionGroup -Identity $DLName | Select-Object Managedby
        $Html = $DLMembers | ConvertTo-Html | Out-File C:\temp\dll.html        
        $Manager | Out-file -Append C:\temp\dll.html
        Invoke-Item C:\temp\dll.html
})

#New tab for Calendar and mailbox access.
$Button_CalendarAccess.Add_Click({
    
    $CalendarRights = $CalendarAccessLevel.Text
     $calendarName = Get-Mailbox -identity $TxtCalendar.Text -ErrorAction Silentlycontinue | select-Object -ExpandProperty Samaccountname
    
    if(!$calendarName){       
        $calendarName = Get-Mailbox -Anr $TxtCalendar.Text | Out-GridView -PassThru -Title "Select Distribution List" | select-Object -ExpandProperty Samaccountname
         $TxtCalendar.Text = $calendarName          
    }

    Try{
    $username = Get-ADUser -Identity $TxtUsername.Text | Select-Object -ExpandProperty SamAccountName

    }Catch{
    $username = Get-ADUser -Filter { anr -eq $TxtUsername.Text } -properties DisplayName, `
									Description,EmployeeNumber | Out-GridView -PassThru -Title "Select User" | `
                                     Select-Object -ExpandProperty SamAccountName 
     }

     $TxtUsername.Text = $username
     $mailboxCalendar = $calendarName + ":\Calendar"
     Add-MailboxFolderPermission -Identity $mailboxCalendar -User $username -AccessRights $CalendarRights

})

$window.ShowDialog()
 

