{{/*
Expand the name of the chart.
*/}}
{{- define "flexiedge.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "flexiedge.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "flexiedge.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "flexiedge.labels" -}}
helm.sh/chart: {{ include "flexiedge.chart" . }}
{{ include "flexiedge.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "flexiedge.selectorLabels" -}}
app.kubernetes.io/name: {{ include "flexiedge.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "flexiedge.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "flexiedge.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/* Create CloudInit to use */}}
{{- define "flexiedge.CloudInit" -}}
networkData: |-
  network:
    version: 2
    ethernets:
    {{- $index := 0 | int }}
    {{- range $key, $val := .Values.ethernets }}
      {{- if eq .enabled true }}
       eth{{ $index }}:
      {{- $index = $index | int | add1 }}
      {{- if eq .dhcp true }}
         dhcp4: true
         {{- if eq .dhcproutes false }}
         dhcp4-overrides:
          use-routes: false
         {{- end }}
      {{- end }}
      {{- if eq .dhcp false }}
         dhcp4: false
         addresses: 
         -  {{ .address }} 
      {{- if .gateway }}
         gateway4: {{ .gateway }}
      {{- end }}
      {{- end }}
         nameservers:
           search: {{ .nameservers.search }}
           addresses: 
           {{- range $dkey, $dval := .nameservers.addresses }}
             - {{ $dval}}
           {{- end }}
        {{- if eq .type "bridge" }}
         routes:
        {{- if eq .dhcproutes false }}
          - to: 169.254.1.1
            scope: link
        {{- end }}
        {{- end }}
    {{- end }}
    {{- end }}
userData: |-
  #cloud-config
  write_files:
  {{- if .Values.flexiedge.token }}
   - path: /etc/flexiwan/agent/token.txt
     permissions: '0644'
     owner: root:root
     content: {{ .Values.flexiedge.token }}
  {{- end }}
  {{- if .Values.Proxy.address }}
   - path: /etc/environment
     permissions: '0644'
     owner: root:root
     append: true
     content: |  
       KubernetesAPI={{ .Values.KubernetesAPI }}
       NameSpace={{ .Release.Name }}
       HTTPS_PROXY="http://{{ .Values.Proxy.httpaddress }}"
       HTTP_PROXY="http://{{ .Values.Proxy.httspaddress }}"
       NO_PROXY="127.0.0.1,localhost"
   - path: /etc/apt/apt.conf.d/proxy.conf
     permissions: '0644'
     owner: root:root
     append: true
     content: |  
       Acquire::http::Proxy "http://{{ .Values.Proxy.httpaddress }}";
       Acquire::https::Proxy "http://{{ .Values.Proxy.httspaddress }}";
  {{- else }}
   - path: /etc/environment
     permissions: '0644'
     owner: root:root
     append: true
     content: |  
       KubernetesAPI={{ .Values.KubernetesAPI }}
       NameSpace={{ .Release.Name }}
  {{- end }}
  runcmd:
   - [ curl, -L, "https://helm.flexiwan.com/scripts/smartedge.sh", --output, /tmp/smartedge.sh ]
   - [ chmod, 775, /tmp/smartedge.sh ]
   - [ tmp/smartedge.sh ]
{{- end }}

{{/* Create Network Interfaces to use */}}
{{- define "flexiedge.interfaces" -}}
{{- range $key, $val := .Values.ethernets -}}
{{- if eq .enabled true }}
- name: {{ $key }}
  {{ .type }}: {}
{{- end }}
{{- end }}
{{- end }}

{{/* Create Networks  to use */}}
{{- define "flexiedge.networks" -}}
{{- range $key, $val := .Values.ethernets -}}
{{- if eq .enabled true }}
- name: {{ $key }}
{{- if eq .type "sriov" }}
  multus:
    networkName: {{ .sriov }}
{{- end }}
{{- if eq .type "bridge" }}
  pod: {}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

