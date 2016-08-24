<#
A collection of git commands I use all the time when working with git in PowerShell.
Place in %SystemRoot%\users\<user>\Documents\WindowsPowerShell\Modules\<moduleName>
to have this auto-load.

See https://msdn.microsoft.com/en-us/library/dd878340(v=vs.85).aspx for more info on PS modules.
#>


<#
Shortcut for pruning local branches that have been removed upstream.
Default does a dry run, sending "run" prunes.
#>
function GitPrune($arg)
{
    if($arg -eq "run")
    {
        Write-Host "Pruning local branches that no longer exist on remote..." -ForegroundColor Green;
        git remote prune origin;
    }
    else
    {
        Write-Host "Use 'gitprune run' to execute the cleanup. Showing --dry-run results..." -ForegroundColor Green;
        git remote prune origin --dry-run;
    }
}
Set-Alias prune GitPrune;

<#
Shortcut to list all remote branches, local statuses, and where local branches push.
#>
function GitBranchStatus() 
{
    git remote show origin;
}
Set-Alias gbs GitBranchStatus;

<#
Shortcut for pulling a remote branch. Defaults to verbose mode.
#>
function GitPull($arg)
{
    if($arg -eq "-q")
    {
        git pull -q;
    }
    else
    {
        git pull -v;
    }
}
Set-Alias pull GitPull;

<#
A (very) destructive branch switching script.
This will forcibly switch from the current branch to whatever $branchName is, removing ANY AND ALL
local changes, and resetting to the remote head. It then pulls the latest branch code.
#>
function GitHardCheckout($branchName)
{
    if([string]::IsNullOrEmpty($branchName))
    {
        Write-Host "You must specify a branch to checkout." -ForegroundColor Red;
        return;
    }
    git checkout $branchName -f;
    git clean -fdx; #kiss your local files goodbye
    git reset --hard;
    git pull;
}
Set-Alias gitswitch GitHardCheckout;

<#
A function that will show all the local branch changes, add all those changes to the index, and then commit
with whatever message is added.
#>
function BulkCommit($msg)
{
    if([string]::IsNullOrEmpty($msg))
    {
        Write-Host "You need a commit message!" -ForegroundColor Red;
    }
    else
    {
        git status -s; #View what's modified/deleted/new
        git add -A :/; #Add everything in the branch that has been modified/deleted/added
        git commit -m $msg; #Do the commit
    }
}
Set-Alias giterdone BulkCommit;

<#
As simple as it gets. Really just an alias for "git push".
#>
function GitPush()
{
	git push;
}
Set-Alias push GitPush;

<#
Simple function to return current branch status. Really just an alias for "git status".
#>
function GitStatus() 
{
    git status;
}
Set-Alias gs GitStatus;

<#
Function for viewing the git log in a "pretty" format.
#>
function GitLogPretty()
{
    git log --graph --decorate --oneline --pretty='format:%C(dim white)%h%Creset - %C(bold green)(%cr)%Creset %C(bold yellow)%d%Creset%n    %C(white bold)%s%Creset%C(white dim) - %an%Creset';
}
Set-Alias glp GitLogPretty;




#Ensures the aliases are set
Export-ModuleMember -Alias * -Function *;