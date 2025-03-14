param([string]$widgetName)

# Print Current Directory for Debugging
Write-Host "Current Directory: $PWD"

# Ensure necessary folders exist
$folders = @("Entities", "ViewComponents", "ViewModels", "Views\Shared\Components\$widgetName")
foreach ($folder in $folders) {
    if (!(Test-Path -Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
    }
}

# Define file contents
$entityContent = @"
namespace WebApp.Entities
{
    public class ${widgetName}Entity
    {
        public string Message { get; set; }
    }
}
"@

$viewComponentContent = @"
using Microsoft.AspNetCore.Mvc;
using Progress.Sitefinity.AspNetCore.ViewComponents;
using WebApp.Entities;
using WebApp.ViewModels;

namespace WebApp.ViewComponents;

[SitefinityWidget(Title = "${widgetName}", Section = "", Category = WidgetCategory.Content)]
public class ${widgetName}ViewComponent() : ViewComponent
{
    public IViewComponentResult Invoke(IViewComponentContext<${widgetName}Entity> context)
    {
        ArgumentNullException.ThrowIfNull(context);

        var viewModel = new ${widgetName}ViewModel();

        return this.View(viewModel);
    }
}
"@

$viewModelContent = @"
using System.Collections.Generic;
using System.Linq;
using WebApp.ViewModels.Shared;

namespace WebApp.ViewModels;

public class ${widgetName}ViewModel
{  
    public ${widgetName}ViewModel()
    {
    
    }
}
"@

$razorView = @"
@using WebApp.ViewModels
@model ${widgetName}ViewModel

<h1>Hello! I'm a Placeholder for ${widgetName} widget</h1>
"@

# Write files with better error handling
try {
    $entityContent | Out-File -FilePath "Entities\${widgetName}Entity.cs" -Encoding utf8 -ErrorAction Stop
    $viewComponentContent | Out-File -FilePath "ViewComponents\${widgetName}ViewComponent.cs" -Encoding utf8 -ErrorAction Stop
    $viewModelContent | Out-File -FilePath "ViewModels\${widgetName}ViewModel.cs" -Encoding utf8 -ErrorAction Stop
    $razorView | Out-File -FilePath "Views\Shared\Components\${widgetName}\Default.cshtml" -Encoding utf8 -ErrorAction Stop

    Write-Host "Files created successfully!"
} catch {
    Write-Host "Error creating files: $_" -ForegroundColor Red
}
