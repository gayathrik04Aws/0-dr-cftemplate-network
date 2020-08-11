# Local Environment

The purpose of this environment is for development without
requiring a push to GitHub or having conflicts with other developers. Since
state is stored locally, you can manage resources separate from
everything else.

## Usage

```
> terraform init
> terraform plan -var 'account=543915692707
> terraform apply -var 'account=543915692707
```

## Notes

- Leave the backend as `local` and develop away!
- The local environment is ignored by Git, so none of the changes should make its way into the repo.
- Be sure to clean up resources when you're done. You should be able to remove them from the
.tf files and run `terraform apply`. If you forcefully wipe your state, you'll need to manually clean
up anything in AWS (or whatever provider you use).
