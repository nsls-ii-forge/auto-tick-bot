# auto-tick-bot
Host repository for operation of the auto-tick-bot to automatically update versions of packages at nsls-ii-forge.

# Job Configuration
To run version updates for feedstock packages at nsls-ii-forge, there are a couple of options.

## All feedstocks
You can check for and run updates for every feedstock at once.
```
# clone this repo
git clone https://github.com/nsls-ii-forge/auto-tick-bot.git
# create new branch
git branch [branch name]
git checkout [branch name]
# install utilities
pip install nsls2forge-utils
# place all feedstock names in names.txt
all-feedstocks -o nsls-ii-forge list -w
# add, commit, and push names.txt
git add .
git commit -m "Update names.txt"
git push origin [branch name]
```
You will have to submit a pull request https://github.com/nsls-ii-forge/auto-tick-bot/pulls.
Once the PR has been merged, the next run of the bot will check sources for every feedstock and see if they need a version update.

It will submit PRs at every feedstock that needs an update.

## Custom selection of feedstocks
You can check for and run updates for only feedstocks of your choosing.
Just edit the file `names.txt` with the feedstock packages that require new versions.
Submit a pull request with your changes. Once the changes have been approved and merged, the next run of the bot will try to update the packages in `names.txt`.

**Note: packages that do not require new versions will not be updated even if they are listed in `names.txt`.
