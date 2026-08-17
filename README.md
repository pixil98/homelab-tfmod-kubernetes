# homelab-tfmod-kubernetes

## Infrastructure gateway registration

Clusters can register their public domain and ingress endpoint with the shared
infrastructure Envoy Gateway:

```hcl
module "k8s_cluster" {
  # Existing cluster arguments...

  infrastructure_gateway_registration_enabled = true
}
```

The module derives the registration from the existing `flux_values_json`
document:

- `info.cluster.domain` supplies the apex domain. The generated certificate and
  Gateway also cover its wildcard.
- `infra.ingress.ipAddress` supplies the HTTPS backend endpoint.

When enabled, the GitHub token must have write access to the Flux repository.
The module commits the cluster-owned route resources and Flux registration to
the branch selected by `infrastructure_gateway_repository_branch`, which
defaults to `infrastructure`.

The infrastructure deployment must own the shared `routing`
namespace. Generated registrations place their resources in that namespace but
do not create or manage the namespace themselves.

The infrastructure deployment also owns the shared Envoy service and its
stable load-balancer address. Generated `Gateway` resources declare listeners
and routes without requesting an address of their own.

The registration uses TLS both at the infrastructure gateway and from Envoy to
the destination cluster. The base domain is used as the backend SNI and is
validated against the backend certificate using system certificate authorities.
The backend declares the `gateway.envoyproxy.io/wss` application protocol so
Envoy uses HTTP/1.1 for the upstream TLS connection, allowing WebSocket upgrades
to reach the destination ingress. The generated route selects the Envoy
`Backend` port explicitly, and the backend TLS policy targets the same port by
its numeric section name.

The generated catch-all route sets its request timeout to `0s`. This disables
Envoy's 15-second total request timeout for streaming and other long-running
services while retaining Envoy's stream idle timeout for stalled connections.
