{{- define "base.labels" -}}
app.kubernetes.io/name: {{ include "demo.name" . }}
helm.sh/chart: {{ include "demo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}