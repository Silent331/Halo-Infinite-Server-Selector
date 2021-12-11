#Run as administrator

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}



Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Halo Infinite Server Selector'
$main_form.AutoSize = $true

#Load Hosts file

$hostsfile = Get-Content C:\Windows\System32\drivers\etc\hosts


#Server defining list

$serverblock = "0.0.0.0 "
$serverallow = "#0.0.0.0 "

$server = New-Object 'object[,]' 17,3

$server[0,0] = "pfmsqos.australiaeast.cloudapp.azure.com"
$server[0,1] = "Australia East"
$server[1,0] = "pfmsqos.australiasoutheast.cloudapp.azure.com"
$server[1,1] = "Australia South East"


$server[2,0] = "pfmsqos.southafricanorth.cloudapp.azure.com"
$server[2,1] = "South Africa North"

$server[3,0] = "pfmsqos.northeurope.cloudapp.azure.com"
$server[3,1] = "EU North"
$server[4,0] = "pfmsqos.westeurope.cloudapp.azure.com"
$server[4,1] = "EU West"

$server[5,0] = "pfmsqos.westus.cloudapp.azure.com"
$server[5,1] = "US West"
$server[6,0] = "pfmsqos.westus2.cloudapp.azure.com"
$server[6,1] = "US West 2"
$server[7,0] = "pfmsqos.southcentralus.cloudapp.azure.com"
$server[7,1] = "US South Central"
$server[8,0] = "pfmsqos.centralus.cloudapp.azure.com"
$server[8,1] = "US Central"
$server[9,0] = "pfmsqos.northcentralus.cloudapp.azure.com"
$server[9,1] = "US North Central"
$server[10,0] = "pfmsqos.eastus.cloudapp.azure.com"
$server[10,1] = "US East"
$server[11,0] = "pfmsqos.eastus2.cloudapp.azure.com"
$server[11,1] = "US East 2"


$server[12,0] = "pfmsqos.japaneast.cloudapp.azure.com"
$server[12,1] = "Japan East"
$server[13,0] = "pfmsqos.japanwest.cloudapp.azure.com"
$server[13,1] = "Japan West"



$server[14,0] = "pfmsqos.southeastasia.cloudapp.azure.com"
$server[14,1] = "South East Asia"
$server[15,0] = "pfmsqos.eastasia.cloudapp.azure.com"
$server[15,1] = "East Asia"


$server[16,0] = "pfmsqos.brazilsouth.cloudapp.azure.com"
$server[16,1] = "Brazil South"

#Top Labels

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Halo Infinite Server Selector"
$Label.Location  = New-Object System.Drawing.Point(40,10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Programmed by Silent331 / GT Silent33i"
$Label2.Location  = New-Object System.Drawing.Point(50,30)
$Label2.AutoSize = $true
$main_form.Controls.Add($Label2)

#Server selection check boxes creator

for ( ($i = 0); $server[$i,0] -ne $null; $i++)
{

Write-Host $i

$checked = $true

#Search for existing entry in hosts file and uncheck already blocked entries.

    for ( ($x = 0); $hostsfile[$x] -ne $null; $x++)
    {
        if($hostsfile[$x] -like ("*"+$server[$i,0]+"*"))
        {
            if($hostsfile[$x] -like ($serverblock+"*"))
            {
                $checked = $false 
            }
        }
    }

$server[$i,2] = new-object System.Windows.Forms.checkbox
$server[$i,2].Location = New-Object System.Drawing.Size(10,($i*20+50)) 
$server[$i,2].Size = New-Object System.Drawing.Size(500,20)
$server[$i,2].Text = $server[$i,1]
$server[$i,2].Checked = $checked
$box = $server[$i,2]
$main_form.Controls.Add( $box )  


}

#Save and Cancel Button

$OKButton = new-object System.Windows.Forms.Button
$OKButton.Location = new-object System.Drawing.Size(50,($server.Length*8))
$OKButton.Size = new-object System.Drawing.Size(100,40)
$OKButton.Text = "Save"
$OKButton.Add_Click({

Write-Host "Save Button Clicked"

#Search hosts file for existing entries and set them all to the necessary values
for ( ($i = 0); $server[$i,0] -ne $null; $i++)
{
    $found = $false

    for ( ($x = 0); $hostsfile[$x] -ne $null; $x++)
        {
            if($hostsfile[$x] -like ("*"+$server[$i,0]+"*"))
            {
                Write-host "Server found on line "  $x  " For server "  $server[$i,0]
                if( $server[$i,2].Checked )
                {
                    $hostsfile[$x] = $serverallow + $server[$i,0]
                }
                else
                {
                    $hostsfile[$x] = $serverblock + $server[$i,0]
                }
                $found = $true
                break
            }
        }

        if($found -eq $false)
        {
            for ( ($y = 1); $y -le 10; $y++)
            {
                try{
                    if( $server[$i,2].Checked )
                        {
                            Add-Content C:\Windows\System32\drivers\etc\hosts ($serverallow + $server[$i,0]) -ErrorAction Stop
                            $hostsfile = Get-Content C:\Windows\System32\drivers\etc\hosts
                        }
                        else
                        {
                            Add-Content C:\Windows\System32\drivers\etc\hosts ($serverblock + $server[$i,0]) -ErrorAction Stop
                            $hostsfile = Get-Content C:\Windows\System32\drivers\etc\hosts
                    
                        }
                        break
                    }
                catch{
                    Write-Host "File in use, Retrying up to 10 times, attempt " $y " for server " $server[$i,0]
                    Start-Sleep -s 1
                }
            }

        }

}

for ( ($y = 1); $y -le 10; $y++)
{
    try{
            $hostsfile | Out-File -FilePath C:\Windows\System32\drivers\etc\hosts 
    }
    catch{
        Write-Host "File in use, Retrying up to 10 times, attempt " $y
        Start-Sleep -s 1
    }
}

$main_form.Close()
})
$main_form.Controls.Add($OKButton)


$CancelButton = new-object System.Windows.Forms.Button
$CancelButton.Location = new-object System.Drawing.Size(170,($server.Length*8))
$CancelButton.Size = new-object System.Drawing.Size(100,40)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({

Write-Host "Cancel Button Clicked"
$main_form.Close() 

})

$main_form.Controls.Add($CancelButton)

#Show form

$main_form.ShowDialog()