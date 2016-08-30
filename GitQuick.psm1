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
Function for merging branches without auto commit
#>
function SafeMerge($sourceBranch)
{
    if ([string]::IsNullOrEmpty($sourceBranch))
    {
        Write-Host "You must provide a source branch name." -ForegroundColor Red;
    }

    git merge --no-commit $sourceBranch;
}
Set-Alias merge SafeMerge;


<#
Function for creating a new branch from the active branch via checkout.
#>
function GitNewBranch($newBranchName)
{
    if ([string]::IsNullOrEmpty($newBranchName))
    {
        Write-Host "New branch name must be supplied!" -ForegroundColor Red;
        Exit;
    }

    git checkout -b $newBranchName;
}
Set-Alias nb GitNewBranch; 


<#
Shortcut for "git push".
#>
function GitPush()
{
	git push;
}
Set-Alias push GitPush;


<#
Shortcut for "git status".
#>
function GitStatus() 
{
    git status;
}
Set-Alias gs GitStatus;


<#
Shortcut for "git difftool"
#>
function GitDifftool($file) 
{
    git difftool $file;
}
Set-Alias gdt GitDifftool;


<#
Shortcut for cleaning merge artifacts post merge.
#>
function CleanMergeFiles() 
{
    git clean -f *.orig;
}
Set-Alias cmf CleanMergeFiles;


<#
Shortcut for pulling the latest branch code for $branch locally without switching the active branch.
Eg. development branch is active, "gitrefresh master" will pull (fast-forward merge) the remote copy of master into the local one without switching branches. Handy for merges without requiring origin.
Local and remote branch names MUST be equal.
#>
function GitRefresh($branch)
{
    git fetch origin $branch`:$branch;
}


<#
Shortcut for viewing the git log in a "pretty" format.
#>
function GitLogPretty()
{
    git log --graph --decorate --oneline --pretty='format:%C(dim white)%h%Creset - %C(bold green)(%cr)%Creset %C(bold yellow)%d%Creset%n    %C(white bold)%s%Creset%C(white dim) - %an%Creset';
}
Set-Alias glp GitLogPretty;





#Ensures the aliases are set
Export-ModuleMember -Alias * -Function *;