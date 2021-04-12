# azure-terragrunt-examples

This repo contains examples of using Terragrunt with [azure-learning-terraform](https://github.com/breadwatcher/azure-learning-terraform)

## What is Terragrunt

Terragrunt is a wrapper around Terraform with the expressed intent of making your Terrform configurations DRY

## Requirements

* [Terraform](https://www.terraform.io/) - Developed with v 0.14.8
* [Terragrunt](https://terragrunt.gruntwork.io/) - Developed with v 0.28.1
* [Go](https://golang.org/) - Developed with go1.16.2

Both requirements can be installed via Homebrew

If you are going to use either Terragrunt or Go test in this repo, you need to set the environment variable `ARM_SUBSCRIPTION_ID` to the ID of your Azure subcription. This can be found by running:

```bash
az account show --query id
```

## Repo and code structure

**THIS IS SUBJECT TO CHANGE**

Currently, the repo is structured as follows:

```
azure-terragrunt-examples
├── env
│   └── provider
│       └── component
├── tests
│   └── config
│   └── helpers
│   └── test
```

Each level of a given directory can have its own `*.hcl` file containing variables for that configuration level

**Example:** at `dev/env.hcl`, a local var called `env` can be created and set to `dev`. This var can be called by any child Terrgrunt configs

## Using Terragrunt

### Applying the example Terragrunt configs in this repo

**Disclaimer**: *The code in this repo is for example use only and should not be used for anything beyond that*

* You can build any part of this infrastructure by `cd`-ing into a dir and running an apply command. For example, if I want to spin up what is defined in `dev/`:

```bash
cd dev/; terragrunt run-all apply
```

* You probably shouldn't run the `apply` command unless you absolutely know what you are doing
* Consider using the `plan` command first
* Unfortunately, as it is right now, `plan` doesn't work unless the given resource group already exists

## Tests

The `tests/` dir contains a framework for testing the infrastructure deployed by this project

### Structure

```
tests/
├── config
│   └── dev.yaml
├── dev_test.go
├── helpers
│   └── config.go
└── test
    ├── resource_group.go
    ├── virtual_network.go
    └── web_url.go
```

* the root of the project contains `*_test.go` files
  * `go test` will run these files as tests
  * this file needs to call `CreateTestConfig` in the `helpers` package to provide inputs to subsequent test functions
* `config/` dir contains yaml files which define a given environment's expected infrastructure/input/data
  * This yaml _must_ match the struct `Config` in `helpers/config.go`
* `helpers/` dir contains packages which are not tests but can be used to "help"
  * `config.go` decodes the yaml config file so its data can be used as input vars for tests
* `test/` dir contains tests/functions whose inputs come from the environment's yaml config

### Running tests
To run the suite of tests:

```bash
cd tests; go test
```

If all is well, you should receive a response like this:

```
PASS
ok      azure_terragrunt_examples_test  6.920s
```

If responds with `FAIL` instead of `PASS`, you have some work to do
