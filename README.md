# AAD-DisabledAccountMonitor
Simple disabled account monitor for AAD. Solution designed for people who only have read access to Active Directory, outputting a running CSV file which can be used for manual steps in staff offboarding

## Functionality
This script is designed to be run on a periodic basis for any manual steps that need to be completed. The included file includes a custom column output for a Microsoft Forms disabled user delegation page (more information [HERE](https://learn.microsoft.com/en-us/microsoft-forms/admin-information#form-ownership-transfer)), which can be modified simply as required for any other manual task (assuming requisite information is in the AAD output)

This script will only show users that have been disabled _since last run_, and keeps a list of all previously disabled users in a seperate file for monitoring, meaning that if you require a full dump of all disabled users, only part of this script is of any use and would need to be extracted as required (specifically the part that creates the disabledUsers.csv file)

_NOTE: the first run of this script will always ultimately show a blank output, as it caches the currently disabled users and then immediately re-runs to verify. Users disabled before first-run can be accessed through the disabledUsers.csv file at the point ONLY (before next run)_

## Prerequisites
- The 'AzureAD' module in PowerShell (this can be installed under the current user scope as required)

## Usage
This script can be run as a scheduled task or as a powershell shortcut on startup on any windows OS with . Note that this does allow for MFA but will show a prompt for the user to enter their password manually. This only allows for MFA in the sense of it gives the user a login prompt in a webview window. This is known functionality and will not be changed in this repo

