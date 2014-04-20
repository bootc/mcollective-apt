# Apt Agent

This APT agent permits you to manipulate APT and dpkg through MCollective.

It allows the user to collect information on pending upgrades (including the
number of packages to be upgraded, installed, removed or kept back) and the
total number of installed packages. You can also clean, update, upgrade or
dist-upgrade.

This agent is based on [Mark Stanislav](https://github.com/mstanislav)'s
[mCollective-Agents](https://github.com/mstanislav/mCollective-Agents)
[apt agent](https://github.com/mstanislav/mCollective-Agents/tree/master/apt).
Many changes have been made to his original code to bring it up to date and
improve its functionality, including writing an MCollective Application Plugin.

## Installation

Follow the [basic plugin install guide](http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/InstalingPlugins).

## Configuration

There are currently no configuration options for the apt plugin.

## Usage
```
$ mco apt upgrades -F location=other

 * [ ============================================================> ] 1 / 1

   ash.bootc.net:  No pending upgrades

Finished processing 1 / 1 hosts in 919.05 ms
```

```
$ mco apt distupgrade -F location=other

 * [ ============================================================> ] 1 / 1

   ash.bootc.net:  OK

Finished processing 1 / 1 hosts in 880.57 ms
```

