
# Uniscript Depository
This is a script dedicated to creating and managing a repository.

This script has several features:
```
Owner functionality:
1.Sell
2. Duplicate key
3.Change lock
```
```
Police features:
1. Seizure
2. Released
3.Relist for sale
```
```
Last function:
1. Force lock
But there is the demand for the item
```
To change the purchase price of a deposit, just change the value on the line below in the config:
```
Config.InitialRentPrice = 60000
```

To change the job and job rank that can confiscate deposits, you need to change the job name on the first line and the job rank on the second line (always inside the config):
```
Config.ImpoundedJob = 'police'
Config.ImpoundedJobGrade = 1
```

To change the coordinates of the depots you need to change the values ​​inside this row (location):
```
Config.Containers = {

	["unionDep1"] = {
		location = vector3(5.09, -680.42, 16.12),
		openText = "~y~Press~r~[E] ~y~to open deposit 1"
	},    
```
**P.S: The owner does not need the key to open the deposit**

# uniscript_depository

Discord: https://discord.gg/aBJxtRxaBS

![Logo](https://cdn.discordapp.com/attachments/825475061670608926/1084149872619434086/logo_youtube.png)
