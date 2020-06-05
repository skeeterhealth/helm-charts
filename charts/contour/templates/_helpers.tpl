{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "contour.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "contour.fullname" -}}
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
Give a name to Envoy resources
*/}}
{{- define "envoy.fullname" -}}
{{- printf "%s-%s" "envoy" (include "contour.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "contour.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for Contour
*/}}
{{- define "contour.labels" -}}
helm.sh/chart: {{ include "contour.chart" . }}
{{ include "contour.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ .Chart.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for Contour
*/}}
{{- define "contour.selectorLabels" -}}
app.kubernetes.io/name: {{ include "contour.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: control-plane
{{- end }}

{{/*
Common labels for Envoy
*/}}
{{- define "envoy.labels" -}}
helm.sh/chart: {{ include "contour.chart" . }}
{{ include "envoy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ .Chart.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for Envoy
*/}}
{{- define "envoy.selectorLabels" -}}
app.kubernetes.io/name: envoy
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: data-plane
{{- end }}

{{/*
Create the name of the service account to use for Contour
*/}}
{{- define "contour.serviceAccountName" -}}
{{- $name := ternary (default (include "contour.fullname" .) .Values.envoy.serviceAccount.name) (default "default" .Values.envoy.serviceAccount.name) .Values.envoy.serviceAccount.create }}
{{- printf "%s-%s" $name "contour"}}
{{- end }}

{{/*
Create the name of the service account to use for Envoy
*/}}
{{- define "envoy.serviceAccountName" -}}
{{- $name := ternary (default (include "contour.fullname" .) .Values.envoy.serviceAccount.name) (default "default" .Values.envoy.serviceAccount.name) .Values.envoy.serviceAccount.create }}
{{- printf "%s-%s" $name "envoy"}}
{{- end }}

{{/*
Create the name of the service account to use for the Certgen Job
*/}}
{{- define "certgen.serviceAccountName" -}}
{{- $name := ternary (default (include "contour.fullname" .) .Values.envoy.serviceAccount.name) (default "default" .Values.envoy.serviceAccount.name) .Values.envoy.serviceAccount.create }}
{{- printf "%s-%s" $name "certgen"}}
{{- end }}
