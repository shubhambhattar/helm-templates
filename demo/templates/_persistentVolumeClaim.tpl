{{/* General PersistentVolumeClaim Spec Template */}}
{{- define "persistentVolumeClaimSpec" -}}
storageClassName: {{ default nil .storageClassName | quote }}
volumeName: {{ default nil .volumeName | quote }}
volumeMode: {{ default nil .volumeMode | quote }}
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