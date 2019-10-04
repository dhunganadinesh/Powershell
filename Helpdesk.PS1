
Add-Type -AssemblyName PresentationFramework
Add-PSSnapin Quest.ActiveRoles.ADManagement 
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

function script_path(){
    $path = $MyInvocation.MyCommand.Path
    if (!$path) {$path = $psISE.CurrentFile.Fullpath}
    if ( $path) {$path = split-path $path -Parent}
    set-location $path


}

function ping_function()
{
    if($cinumber.Text -eq ''){

        $ping_result_show.Text = "Enter CI number of PC."

    }

    else{

    $ping_result = ping $cinumber.text | fl | out-string;

    $ping_result_show.Text = $ping_result

    }
}


function userloggedon_function()
{
    if($cinumber.Text -eq ''){

        $ping_result_show.Text = "Enter CI number of PC."

    }

    else{

    $username = Get-WmiObject -Class Win32_computersystem -ComputerName $cinumber.Text | Select-Object -ExpandProperty Username

    $ping_result_show.Text = $username

    }
}

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


function endtask_function(){
    if($cinumber.Text -eq "")
    {
        $ping_result_show.Text = "Enter CI number of PC."
    }
    else    
    {
        $process_selected = $listview_process.SelectedItem.Name

        write-host $process_selected

        Try {

            $returnval = (Get-WmiObject -Class Win32_Process -ComputerName $cinumber.Text | ?{ $_.name -eq $process_selected } | %{ $_.Terminate() })

        } Catch

        {
            Write-Warning "Failed to end the process. Review the error message"

            Write-Warning $_.Exception.Message

            exit
        }

        #Start-Sleep 3.5

        $process = Get-WmiObject -Class Win32_Process -ComputerName $cinumber.Text -ErrorVariable get_process_error | Sort-Object Name

        $Bindable_Process = $process | Select-Object -Property @{Name='Name';Expression={$_.ProcessName}}, @{Name='ID';Expression={$_.ProcessID}}

        $listview_process.ItemsSource = $Bindable_Process
    }

}

function getinstalledapps_function(){
    if($cinumber.Text -eq "")
    {
        $ping_result_show.Text = "Enter CI number of PC."
    }
    else    
    {

        $header1.Header = "Application Name"

        $header3.Header = "Vendor"

        $installed_apps = Get-Wmiobject -Class Win32_Product -ComputerName $cinumber.Text | select Name, Vendor | sort Name

        $Bindable = $installed_apps | Select-Object -Property @{Name='Name';Expression={$_.Name}}, @{Name='ID';Expression={$_.Vendor}}

        $listview_process.ItemsSource = $Bindable
        $ping_result_show.Text = ""
    }

}

function pcdetails_function(){
 
   Try
   {

       
       $caption = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text -ErrorAction Stop| Select-Object  Caption | ForEach{ $_.Caption }


       $servicepack = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text| Select-Object  ServicePackMajorVersion | ForEach{ $_.ServicePackMajorVersion }

       $osarch = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text| Select-Object  OSArchitecture | ForEach{ $_.OSArchitecture }

       $build_number = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text| Select-Object  BuildNumber | ForEach{ $_.BuildNumber }

       $host_name = Get-WmiObject -class Win32_OperatingSystem -ComputerName $cinumber.Text| Select-Object  CSName | ForEach{ $_.CSName }

       $disk = Get-WmiObject -Class Win32_logicaldisk -ComputerName $cinumber.Text -Filter "DriveType = '3'" | Select-Object -Property DeviceID, DriveType, VolumeName, @{L='FreeSpaceGB';E={"{0:N2}" -f ($_.FreeSpace /1GB)}},@{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}} | fl | Out-String

       $ping_result_show.Text = "OS Version: $caption " + $nl + "Service Pack Version: $servicepack " + $nl + "OS Architecture: $osarch " + $nl + "Build Number: $build_number"  + $nl + "Host Name: $host_name " + $nl + $nl + "$esc Disk Info: $disk"
   }
   catch
   {
      $ping_result_show.Text = "Unable to connect to PC"  
   }
   
}


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
                <Canvas Grid.ColumnSpan="3" HorizontalAlignment="Left" Height="176" Margin="10,10,0,0" VerticalAlignment="Top" Width="415" Background="#FFB9B9B9">
                    <Label x:Name="label1" Content="Username" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="68" Canvas.Left="10" Canvas.Top="22"/>
                    <TextBox x:Name="textBox_username" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" VerticalAlignment="Top" Width="106" Canvas.Left="83" Canvas.Top="27"/>
                    <Button x:Name="button_lastlogon" Content="Last Logon" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="81" Canvas.Left="-3" Canvas.Top="177"/>
                    <TextBlock x:Name="textbox_lastlogon" HorizontalAlignment="Left" Height="117" TextWrapping="Wrap" VerticalAlignment="Top" Width="332" Canvas.Left="10" Canvas.Top="55"/>
                    <Button x:Name="button_memberof" Content="Member Of" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="81" Canvas.Left="83" Canvas.Top="177"/>
                    <Button x:Name="button_AU" Content="Unlock" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="81" Canvas.Left="169" Canvas.Top="177"/>
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
                    <Button x:Name="button" Content="..." Height="29" Canvas.Left="375" Canvas.Top="22" Width="40"/>
                    <Button x:Name="button_folderaccess" Content="Check Folder ACL" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="119" Canvas.Left="87" Canvas.Top="66"/>
                </Canvas>
                <TextBox x:Name="textBox" Grid.ColumnSpan="2" Grid.Column="1" HorizontalAlignment="Left" Height="30" Margin="43,304,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="293"/>
                <Button x:Name="button1" Content="Button" Grid.Column="2" HorizontalAlignment="Left" Margin="852,74,-396,0" VerticalAlignment="Top" Width="75"/>
                <Button x:Name="button_remove_memberof" Content="Remove Access" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="109" Grid.Column="2" Margin="192,352,0,0"/>
                <Button x:Name="button_remove_distribution" Content="Remove DL Access" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="109" Grid.Column="2" Margin="192,381,0,0"/>
                <Button x:Name="button_backup" Content="Backup Access" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="109" Grid.Column="2" Margin="192,410,0,0"/>
                <Button x:Name="button_register" Content="Unlock and Register" HorizontalAlignment="Left" Height="28" VerticalAlignment="Top" Width="121" Margin="28,187,0,0" Grid.Column="2"/>

            </Grid>
        </TabItem>

    </TabControl>
</Window>
"@

#############################################################################################

$esc = [char]27

$nl = [Environment]::NewLine

$reader = (New-Object System.Xml.XmlNodeReader $xaml)

$window = [Windows.Markup.XamlReader]::Load($reader)

########################################################### Tab 1 Ping Program Start

################################ Variable declaration for form items on Tab1 start


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
################################ Variable declaration for form items on Tab1 Ends
################################ Ping Click Event starts

$pingButton.Add_Click({
    
    ping_function 

})

################################ Ping Click Event Ends
################################ User Logged In Click Event starts

$user_logged_on.Add_Click({

    userloggedon_function

})

################################ User Logged In Click Event Ends

################################ Get Process Event starts

$get_process.Add_Click({

    getprocess_function   

})

################################ Get Process Event ends
################################ End Process Event starts

$end_task.Add_Click(

{
    endtask_function

})

################################ End Process Event starts
##################s####################################### Get Installed App Starts
$get_installed_apps.Add_Click({

    getinstalledapps_function


})

$button_pc_details.Add_Click({

    pcdetails_function

})

$button_flushdns.Add_Click({
    
    Try
    {
        $ping_result_show.Text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"

        $remotepc = $cinumber.Text.ToString()
        $ping_result_show.Text = PsExec.exe -s \\$remotepc ipconfig /flushdns | fl | out-string
    }
    Catch
    {
    
        $ping_result_show.text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"
    }
    

})

$button_displaydns.Add_Click({

    Try{
        $ping_result_show.Text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"
        $remotepc = $cinumber.Text.ToString()
        $ping_result_show.Text = ..\PSTools\PsExec.exe -s \\$remotepc ipconfig /displaydns | fl | out-string
    }
    Catch
    {
    
            $ping_result_show.text = "Plese download pstool and save powershell on same folder. https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"
    }


})
##################s####################################### Get Installed App Ends
########################################################### Tab 1 Ping Program Ends


########################################################## Tab 2 Active Directory Starts
################################ Variable declaration for form items in Tab 2 starts

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

################################ Variable declaration for form items in Tab 2 ends
##################s####################################### Get User Last logon start

$lastlogon.Add_Click({

 

    $result = Get-ADUser -Identity $username_lastlogon.text -Properties LastLogon -server dcpdc03|   Format-Table UserPrincipalName, @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogon)}} | fl | out-string;

    $textbox_result.text = $result

 

})

##################s####################################### Get User Last logon Ends
##################s####################################### Get User Membership start
$button_memberof.Add_Click({

    $member_of = Get-ADPrincipalGroupMembership -Identity $username_lastlogon.text -server dcpdc03

    $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -Property @{Name='ACLName';Expression={$_.Name}} ,@{Name='Description';Expression={$_.GroupCategory }}

    $listview_memberof.ItemsSource = $Bindable_memberof

})
##################s####################################### Get User Membership Ends
##################s####################################### Save Backup start

$button_backup.Add_Click({

    $testpath = Test-Path('C:\Temp\AD Backup')

    if(Test-path ("C:\temp\ad backup"))

    {

        $member_of = Get-ADPrincipalGroupMembership -Identity $username_lastlogon.text -server dcpdc03

        $Bindable_memberof = $member_of |  Sort-Object -Property @{Expression = {$_.GroupCategory};}, Name| Select-Object -ExpandProperty Name

        $file_fullname = ('C:\Temp\AD Backup\') + $username_lastlogon.Text + " AD Backup.txt"

        $filename = $username_lastlogon.Text + " AD Backup.txt"

        $filecheck =Test-path ($file_fullname)

         if($filecheck -eq 'True')

        {

            Add-content -Path $file_fullname -Value (Get-Date)

            Add-content -Path $file_fullname  -Value $nl

            Add-content -Path $file_fullname -Value $Bindable_memberof
            Add-content -Path $file_fullname  -Value $nl
            Add-content -Path $file_fullname  -Value $nl



        }

        else

        {

            New-Item -path 'C:\temp\AD Backup' -Name "$filename" -ItemType "file" -Value (Get-Date)

            Add-content -Path $file_fullname  -Value $nl

            Add-content -Path $file_fullname -Value $Bindable_memberof
            Add-content -Path $file_fullname  -Value $nl
            Add-content -Path $file_fullname  -Value $nl

        }

    }

    else

    {

        write-host "Folder doesn't exist"

        New-Item -Path "c:\Temp" -Name "AD Backup" -ItemType "directory"

    } 

})
##################s####################################### Save Backup Ends
##################s####################################### Account Unlock Start
$button_AU.Add_Click({
    Try
    {

       Unlock-ADAccount -Identity $username_lastlogon.Text
       $textbox_result.text = "Account Unlocked"
        

    }
    Catch
    {
        $textbox_result.text = ""
        $adaccounts =  Get-ADUser -Filter { anr -eq $username_lastlogon.Text} -properties DisplayName, `
									Description,EmployeeNumber | Out-GridView -PassThru -Title "Select User" | `
                                     Select-Object -ExpandProperty SamAccountName
        
        $username_lastlogon.Text = $adaccounts
        #$Bindable_memberof = $adaccounts|  Sort-Object Name| Select-Object name, samaccountname

        #$listview_memberof.ItemsSource = $Bindable_memberof
        Unlock-ADAccount -Identity $adaccounts
        $textbox_result.text = "Account Unlocked"

    }


})

##################s####################################### Account Unlock Ends
########################################################## Tab 2 Active Directory Ends
$window.ShowDialog()
 

