# InSpec-VMware Example Profile

## Scope

This is an example of the `powercli_command` InSpec resource and a `TSM-SSH` control.

## Usage

### Setup

#### Via Vagrant

```shell
vagrant up
vagrant ssh
sudo pwsh -Command "& {Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:\\$False}"
inspec exec inspec-vmware-example -t vmware://USERNAME@VISERVER --password PASSWORD
```

#### Via Bundle

```shell
git clone https://github.com/jjasghar/inspec-vmware-example.git
cd inspec-vmware-example
bundle install
bundle exec inspec vendor
sudo pwsh -Command "& {Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:\\$False}"
bundle exec inspec exec . -t vmware://USERNAME@VISERVER --password PASSWORD
```

### Self-Signed Certs

If you have self signed certificates on your ESXi/vCenter instances you will need to run the following commands from the host you want to run InSpec from.

```powershell
$ pwsh
PS >  Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
```

If you don't the initial `Connect-VIserver` will fail with not being able to find PowerShell.

## License and Author

- Author::  JJ Asghar <jj@chef.io>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
