# ngfw-azure-101


```sh
az group create -n <rg-name> -l <region>
az deployment group create \
  -g <rg-name> \
  --template-file ./main.bicep \
  --parameters adminPassword='<StrongP@ssw0rd!>' \
               adminUsername='azureuser' \
               vmAName='ubuntu-a' \
               vmBName='ubuntu-b' \
               location='<region>'
```

## Set up Git SSH key

Generate a new SSH key and add it to your agent:

```sh
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519_git -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_git
```

Copy the public key to your clipboard and add it to your Git host (GitHub/GitLab/etc):

```sh
pbcopy < ~/.ssh/id_ed25519_git.pub   # macOS
# or: cat ~/.ssh/id_ed25519_git.pub  # if pbcopy is unavailable
```

Test SSH access (example for GitHub):

```sh
ssh -T git@github.com
```
