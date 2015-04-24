# PowerShell build framework
# Project-specific control file

Begin-BuildScript "WpfTaskDialog"

# Find revision format from the source code, require Git checkout
Set-VcsVersion "" "/require git"

Restore-NuGetTool
Restore-NuGetPackages "WpfTaskDialog.sln"

# Debug builds
if (IsSelected build-debug)
{
	Build-Solution "WpfTaskDialog.sln" "Debug" "Any CPU" 5
}

# Release builds
if (IsAnySelected build-release commit)
{
	Build-Solution "WpfTaskDialog.sln" "Release" "Any CPU" 5
	
	Create-NuGetPackage "WpfTaskDialog\Unclassified.WpfTaskDialog.nuspec" "WpfTaskDialog\bin"
}

# Commit to repository
if (IsSelected commit)
{
	Git-Commit
}

# Upload to NuGet
if (IsSelected transfer-nuget)
{
	Push-NuGetPackage "WpfTaskDialog\bin\Unclassified.WpfTaskDialog" $nuGetApiKey 45
}

End-BuildScript
