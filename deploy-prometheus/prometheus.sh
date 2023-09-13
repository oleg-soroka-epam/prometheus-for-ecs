##!/bin/bash
PROMETHEUS_URL=$(cat ~/.aws/prometheus_url)
sed -e s/PROMETHEUS_URL/$PROMETHEUS_URL/g \
< prometheus.yaml.template \
> prometheus.yaml
