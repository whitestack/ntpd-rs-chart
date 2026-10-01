# ntpd-rs Helm Chart

## Overview

Helm chart for [`ntpd-rs`](https://github.com/pendulum-project/ntpd-rs), an NTP
client to syncronize the clock of Kubernetes hosts.

## Prerequisites

Before you install this chart verify that there aren't any NTP clients running
on the hosts like `chrony` or `systemd-timesyncd`. To stop and disable
`systemd-timesyncd` run:

```shell
systemctl stop systemd-timesyncd
systemctl disable systemd-timesyncd
```

## Configuration

### Configuration file for `ntpd-rs`

A sample configuration is present in `.Values.config` that configures `ntpd-rs`
to use one server to syncronize the host's clock. You can check the full
reference for this file
[here](https://docs.ntpd-rs.pendulum-project.org/man/ntp.toml.5).

### Acting as an NTP server

Besides synchronizing the host's clock, `ntpd-rs` can serve time to other
clients. This is disabled by default. To enable it, set `server.enabled=true`
and uncomment the `[[server]]` section in `.Values.config`. The chart then
creates a `LoadBalancer` Service (`<release>-ntp`) exposing UDP port 123.
Configure it with `.Values.server`:

| Value | Default | Description |
|-------|---------|-------------|
| `enabled` | `false` | Create the Service |
| `type` | `LoadBalancer` | Service type |
| `port` | `123` | Service port (the pod port is fixed to 123) |
| `externalTrafficPolicy` | `Local` | `Local` preserves client source IPs |
| `loadBalancerIP` | `""` | Request a specific IP |
| `annotations` | `{}` | Cloud/MetalLB-specific annotations |

The `[[server]]` section in `.Values.config` must listen on port 123. Your
load balancer implementation must support UDP.
