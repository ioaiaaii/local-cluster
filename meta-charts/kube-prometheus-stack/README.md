# Meta chart for kube-prometheus-stack

In order to maintain the correct CRDs along with Prometheus operator versions, we need to manage them independently, since helm only installs CRDs in the first deployment.

Use the following script to update CRDs and move the to [crds](./crds/).
`prometheusOperator` version should match the `appVersion` from [Chart.yaml](./Chart.yaml)

```shell
prometheusOperator=v0.60.1

curl -O -L https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$prometheusOperator/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
curl -O -L https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/prometheusOperator/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
curl -O -L https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/prometheusOperator/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
curl -O -L https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/prometheusOperator/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
curl -O -L https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/prometheusOperator/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
curl -O -L https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/prometheusOperator/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
curl -O -L https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/prometheusOperator/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
curl -O -L https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/prometheusOperator/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
```