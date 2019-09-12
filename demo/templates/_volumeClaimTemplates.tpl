{{/* General Volume Claim Template */}}
{{- define "volumeClaimTemplate" }}
{{- range $volumeClaimTemplate := . }}
{{- with $volumeClaimTemplate }}
- metadata:
    name: {{ required "volumeClaim name is required" .name | quote }}
    {{- with .annotations }}
    annotations:
      {{- toYaml . | nindent 4 }}
    {{- end }}
  spec:
    storageClassName: {{ default nil .storageClassName | quote }}
    volumeName: {{ default nil .volumeName | quote }}
    volumeMode: {{ default nil .volumeMode | quote }}
  
    resources:
      requests:
        storage: {{ required "Storage size is required" .resources.requests.storage }}

    {{- with .accessModes }}
    accessModes:
      {{- toYaml . | nindent 4 }}
    {{- end }}

    {{- with .dataSource }}
    dataSource:
      {{- toYaml . | nindent 4 }}
    {{- end }}

{{- end }}
{{- end }}

{{- end }}