# InSpec-VMware Narrative

## Pre-Reqs (notes for setup)
- A machine that has PowerCLI installed that can reach ESXi
- An ESXi machine that can turn SSH on and off (root can), start with SSH turned on.

_Note:_ The original work is [here](https://www.youtube.com/watch?v=-WCGz_CjRYs).

## Introduction

Hi my name is _____. I’m here to demo the [InSpec-VMware](https://github.com/inspec/inspec-vmware)
plugin for the [InSpec](https://inspec.io). If you don’t know InSpec is a continual compliance automation
framework that allows you to write code to automate compliance validation and compliance tasks. Take for
instance your SDDC, you probably have some auditing you have to do at least every year, taking away from
the tasks you normally have to do.
Now imagine a way to automate that work, and have it continually run to make sure you are always at that
standard or policy. The InSpec-VMware plugin for InSpec is just that an extension to validate your SDDCs
via PowerCLI in a continuous manner.
That's what the demo is, let’s jump right in!

## Custom Resource for InSpec

Everything is built off something called a [Custom Resource](https://www.inspec.io/docs/reference/dsl_resource/).
You can go here <https://github.com/inspec/inspec-vmware> to check out the code. You can leverage the PowerCLI
resource just by adding a ‘depends’ line to your `inspec.yml` file and slurp the resource right in off Github.

## PowerCLI Installed

I’m going to assume you have PowerCLI already installed. As of this presentation VMware officially supports
PowerCLI on PowerShell running on Ubuntu 16.04. I've tested at it works on CentOS but as I said not officially
supported.
I’d like to deatour a little here, did you just hear what I said? Yes, PowerShell runs fine on Ubuntu and CentOS?
I have to say this is amazing, the ability to get PowerShell to run on Linux based operating systems opens up a
bridge between two ecosystems that have always been so walled off. Running PowerCLI now in this version of
PowerShell now allows tradition Linux engineers to work in side by side with traditional Windows engineers.
If you haven’t tried to install PowerShell or PowerCLI yet on a Linux machine we have some basic instructions
on the inspec-vmware github page, or we even have a [Chef cookbook](https://supermarket.chef.io/cookbooks/powercli_install)
that will run on both Windows and Linux to universally install PowerCLI for you automatically.

## SSH Demo

```
SSH into a machine that can reach both automate and ESXi (packer || demo_powercli_automate)
```

As you can see I’m logged into a Linux machine here.

```shell
cat /etc/redhat-release
```
As you can see this is specifically a CentOS 7 machine.

```shell
cat controls/1_tsm_ssh.rb
```

I have a simple control here that runs the PowerCLI command to verify that `TSM-SSH` is turned off. As you can see
it uses the typical describe block that InSpec controls use, and have two outputs to make sure the control is up to
what we expect. First `exit_status` makes sure that the actual PowerCLI command runs successfully and `exits 0`,
and the second expects that the output not to be empty, because we expect that the running state to be `$False`.
If the running state is set to `or`, $True on, then it will be empty and we will have a failing test.

```shell
bundle exec inspec exec . -t vmware://root@172.16.20.43 --password password
```

Let’s give this a shot and see if SSH is running on this remote ESXi host.

As this is running, let me explain the command. I’m running inspec exec this profile, or the ‘.’. It takes in all
the controls you’d write in this directory and any sub-directories. By the `depends` line in the `inspec.yml`
you gain the connector to your ESXi host, and the `--password` as you can imagine is your password ;).

As you can see with this completion, I have a failure. This is expected, I mean it is a demo right? I should say
that the `exit_status` was `0`, that means it successfully ran, but because it got something back and NOT empty
that means the whole control fails.

`Go to an ESXi console`: https://172.16.20.43

As you can see, on this ESXi hosf is SSH running. It even has a nice warning sign to say you shouldn’t have this
enabled unless you absolutely need to. I’m going to go ahead and and turn off SSH now.

```
Disable SSH via Actions - Services - Disable SSH
```

Good, now that’s it disabled I’m going to run it again.

```shell
bundle exec inspec exec . -t vmware://root@172.16.20.43 --password password
```

And there you go! The control comes back green because we have SSH turned off and everything passes as expected.
Now Imagine being able to run the arbitrary commands across your whole SDDC and continually verifying at least
that SSH is turned off across your fleet. Pretty powerful eh? But that’s not all!

## Automate Demo

Ok, so we can now run one off commands, and make sure that our fleet is is the state we expect. Leveraging Chef Automate
you can now have a single pane of glass view of the state of the fleet and if anything goes out of compliance pro
active notification on what’s happening.

```
Open up Automate
```

Taking from what we just learned you can now take the same inspec command and inject the output into Chef Automate.

```shell
cat esxi-41.json
```

As of right now, for each ESXi host you need to create these json files to declare the machines, they have a few
important distinctions, including `node_uuid` which much be unique, `node_name` to give it a human friendly name,
`token` that can talk to the Automate API, and finally the `url`a which is the automate API that you want to send
this data to. For fun I have stdout set to false because I plan on running this with a cron job and don’t want any output.

```shell
bundle exec inspec exec . -t vmware://root@172.16.20.43 --password password --json-config esxi-41.json
```

You run the exact same command but add on the `--json-config` with the file name to redirect the output to Automate!

```
Refresh automate
```

As you can see we have one node now, that it is passing. You can click on the node and drill down to see the actual
PowerCLI code from the control, and see if something is failing why it is.

## Conclusion

This is unbelievably powerful, you can now have confidence that your SDDCs are set up and continually set to your
expected compliance policies and have a single place to give your teams to verify this work.

Thanks for your time, and I look forward to seeing what people can create with this!
