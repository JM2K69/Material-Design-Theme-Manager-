
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') |Out-Null
[System.Reflection.Assembly]::LoadFrom("assembly\System.Windows.Interactivity.dll") |Out-Null
[System.Reflection.Assembly]::LoadFrom("assembly\MaterialDesignThemes.Wpf.dll") |Out-Null
[System.Reflection.Assembly]::LoadFrom("assembly\MaterialDesignColors.dll") |Out-Null
[String]$ScriptDirectory = split-path $myinvocation.mycommand.path


function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("$ScriptDirectory\MonInterface.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$DataGrid_Machines = $form.FindName("DataGrid_Machines")
$DataGrid_Utilisateurs = $form.FindName("DataGrid_Utilisateurs")
$BTN1 = $form.FindName("BT1")
$Toggle = $form.FindName("Mode")
$CColors = $form.FindName("Color")
$CSecondarys = $form.FindName("Secondary")
$Googbye = $form.FindName("Goodbye")


$Toggle.add_Click( {

    $theme = [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::GetTheme($form.Resources)
   
    if ($Toggle.IsChecked -eq $true) {
      [MaterialDesignThemes.Wpf.ThemeExtensions]::SetBaseTheme($theme, [MaterialDesignThemes.Wpf.Theme]::Dark)
    }
    if ($Toggle.IsChecked -eq $False) {
      [MaterialDesignThemes.Wpf.ThemeExtensions]::SetBaseTheme($theme, [MaterialDesignThemes.Wpf.Theme]::Light)
    }
    [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::SetTheme($form.Resources, $theme)
  })

$Colors=@()
$Secondarys= @()
$Colors = [System.Enum]::GetNames([MaterialDesignColors.PrimaryColor])
$Secondarys=  [System.Enum]::GetNames([MaterialDesignColors.SecondaryColor])

foreach ($item in $Colors)
{
    $CColors.Items.Add($item)| Out-Null
}
foreach ($item in $Secondarys)
{
    $CSecondarys.Items.Add($item)| Out-Null
}

$CSecondarys.Add_SelectionChanged({

    $theme = [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::GetTheme($form.Resources)
    $SecondaryColors = [MaterialDesignColors.SwatchHelper]::Lookup[$CSecondarys.SelectedValue]
    [MaterialDesignThemes.Wpf.ThemeExtensions]::SetSecondaryColor($theme, $SecondaryColors)
    [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::SetTheme($form.Resources, $theme)
    
})
    
$CColors.Add_SelectionChanged({

$theme = [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::GetTheme($form.Resources)
$Primary = [MaterialDesignColors.SwatchHelper]::Lookup[$CColors.SelectedValue]
[MaterialDesignThemes.Wpf.ThemeExtensions]::SetPrimaryColor($theme, $Primary)
[MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::SetTheme($form.Resources, $theme)

})


$Googbye.Add_MouseEnter({

Exit

})
$Form.ShowDialog() | Out-Null

