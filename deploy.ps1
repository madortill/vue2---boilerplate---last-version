Param ($commitMessage = $(throw "commit message parameter is required."))
$ErrorActionPreference = "Stop"
$repoURL = git remote get-url --push origin
if($repoURL -eq $null -or $repoURL -eq "")
{
    $repoURL = Read-Host -Prompt "Repository URL not found. Please enter repository url to continue or ctrl + C to quit"
}

npm run build

# navigate into the build output directory
cd dist

# place .nojekyll to bypass Jekyll processing
echo "" > .nojekyll

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git checkout -B master
git add -A
git commit -m $commitMessage

# if you are deploying to https://<USERNAME>.github.io
git push -f $repoURL master:gh-pages

cd ..

write-host ""
write-host "deployed to github"
write-host ""
