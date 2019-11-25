{{/* General PersistentVolumeClaim Spec Template */}}
{{- define "persistentVolumeClaimSpec" -}}
storageClassName: {{ default nil .storageClassName | quote }}

{{- if .volumeName }}
volumeName: {{ .volumeName | quote }}
{{- end }}

{{- if .volumeMode }}
volumeMode: {{ .volumeMode | quote }}
{{- end }}

resources:
  requests:
    storage: {{ required "Storage size is required" .resources.requests.storage }}

{{- with .accessModes }}
accessModes:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .dataSource }}
dataSource:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}