
{{/* 
  Generate full name for resources: 
  example: quote-app-backend
*/}}
{{- define "quote-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* 
  Short name for app (used in labels, optional)
*/}}
{{- define "quote-app.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{/* 
  Standard labels used across all resources 
*/}}
{{- define "quote-app.labels" -}}
app.kubernetes.io/name: {{ include "quote-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/* -------- redis helpers -------- */}}
{{- define "quote-app.redis.name" -}}redis{{- end }}

{{- define "quote-app.redis.fullname" -}}
{{- printf "%s-%s" (include "quote-app.fullname" .) (include "quote-app.redis.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "quote-app.redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quote-app.redis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* -------- redis pvc helpers (if you render a PVC) -------- */}}
{{- define "redis-pvc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "redis-pvc.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "redis-pvc.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end }}

{{- define "redis-pvc.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "redis-pvc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

#------- backend-hpa -----------
{{- define "quote-app.backend.name" -}}
backend
{{- end }}

{{- define "quote-app.backend.fullname" -}}
{{- printf "%s-%s" (include "quote-app.fullname" .) (include "quote-app.backend.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "quote-app.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quote-app.backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
