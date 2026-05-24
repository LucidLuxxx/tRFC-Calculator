# =============================================
# RAM tRFC Calculator with Fine Slider Control
# =============================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "tRFC Calculator - Ticks to ns + tRFC2/tRFC4"
$form.Size = New-Object System.Drawing.Size(560, 380)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# MT/s Input
$lblMTs = New-Object System.Windows.Forms.Label
$lblMTs.Text = "RAM Speed (MT/s):"
$lblMTs.Location = New-Object System.Drawing.Point(20, 20)
$lblMTs.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($lblMTs)

$txtMTs = New-Object System.Windows.Forms.TextBox
$txtMTs.Text = "3733"
$txtMTs.Location = New-Object System.Drawing.Point(170, 18)
$txtMTs.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($txtMTs)

$btnApply = New-Object System.Windows.Forms.Button
$btnApply.Text = "Apply"
$btnApply.Location = New-Object System.Drawing.Point(280, 17)
$btnApply.Size = New-Object System.Drawing.Size(80, 23)
$form.Controls.Add($btnApply)

# Slider
$lblTicks = New-Object System.Windows.Forms.Label
$lblTicks.Text = "tRFC Ticks:"
$lblTicks.Location = New-Object System.Drawing.Point(20, 70)
$lblTicks.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($lblTicks)

$trackBar = New-Object System.Windows.Forms.TrackBar
$trackBar.Location = New-Object System.Drawing.Point(170, 65)
$trackBar.Size = New-Object System.Drawing.Size(350, 45)
$trackBar.Minimum = 100
$trackBar.Maximum = 1000
$trackBar.Value = 262

# Fine control settings
$trackBar.SmallChange = 1      # Keyboard arrows & small drag steps
$trackBar.LargeChange = 10     # Page Up / Page Down
$trackBar.TickFrequency = 10   # Visual ticks every 10 units

$form.Controls.Add($trackBar)

$lblTickValue = New-Object System.Windows.Forms.Label
$lblTickValue.Font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$lblTickValue.Location = New-Object System.Drawing.Point(20, 115)
$lblTickValue.Size = New-Object System.Drawing.Size(520, 25)
$lblTickValue.TextAlign = "MiddleCenter"
$form.Controls.Add($lblTickValue)

# Results
$lblResult = New-Object System.Windows.Forms.Label
$lblResult.Font = New-Object System.Drawing.Font("Consolas", 13, [System.Drawing.FontStyle]::Bold)
$lblResult.ForeColor = [System.Drawing.Color]::DarkGreen
$lblResult.Location = New-Object System.Drawing.Point(20, 155)
$lblResult.Size = New-Object System.Drawing.Size(520, 35)
$lblResult.TextAlign = "MiddleCenter"
$form.Controls.Add($lblResult)

$lblRFC2 = New-Object System.Windows.Forms.Label
$lblRFC2.Font = New-Object System.Drawing.Font("Consolas", 11)
$lblRFC2.Location = New-Object System.Drawing.Point(20, 200)
$lblRFC2.Size = New-Object System.Drawing.Size(520, 25)
$lblRFC2.TextAlign = "MiddleCenter"
$form.Controls.Add($lblRFC2)

$lblRFC4 = New-Object System.Windows.Forms.Label
$lblRFC4.Font = New-Object System.Drawing.Font("Consolas", 11)
$lblRFC4.Location = New-Object System.Drawing.Point(20, 230)
$lblRFC4.Size = New-Object System.Drawing.Size(520, 25)
$lblRFC4.TextAlign = "MiddleCenter"
$form.Controls.Add($lblRFC4)

function Update-Calculation {
    $mt = [double]$txtMTs.Text
    $ticks = $trackBar.Value
    
    if ($mt -le 0) {
        $lblResult.Text = "Please enter a valid MT/s value"
        return
    }
    
    $ns = ($ticks * 2000) / $mt
    $nsFormatted = "{0:N4}" -f $ns
    
    # Standard ratios used in DRAM tuning
    $rfc2 = [math]::Round($ticks / 1.346)
    $rfc4 = [math]::Round($rfc2 / 1.625)
    
    $lblTickValue.Text = "tRFC = $ticks ticks"
    $lblResult.Text = "$ticks ticks @ ${mt} MT/s = ${nsFormatted} ns"
    $lblRFC2.Text = "Recommended tRFC2 = $rfc2"
    $lblRFC4.Text = "Recommended tRFC4 = $rfc4"
}

# Event handlers
$trackBar.Add_ValueChanged({ Update-Calculation })
$txtMTs.Add_TextChanged({ Update-Calculation })
$btnApply.Add_Click({ Update-Calculation })

# Initial calculation
Update-Calculation

$form.ShowDialog() | Out-Null
