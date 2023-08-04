# ACR Scripts
Here you can find some utility scripts deal to azure container registry, such as cleaning stale images.

## Cleaning
`acr-clean-image.sh` Allows to delete a specific image of a specific container registry. 
The default cleaning policy is to keep most 2 recent digests. Example:
```
./acr-clean-image.sh cstarucommonacr rtdmssenderauth true
```
The last parameter controls dry run: true will delete the images on container registry, while false perform a dry run which shows you what images will be deleted.

`acr-clean-domain.sh` Allows to delete images related to a specific domain (where name of image start with a domain name).
It use acr-clean-image.sh script. No arguments are supported you must edit the script and launch it. The given example
applies the acr-clean-image script to image which starts with "rtd".
```
DELETE=false
REGISTRY="cstarucommonacr"
DOMAIN="rtd"
```
