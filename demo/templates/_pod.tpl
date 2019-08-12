{{/* General Pod Template */}}
{{- define "pod" -}}
terminationGracePeriodSeconds: {{ default 30 .terminationGracePeriodSeconds }}
dnsPolicy: {{ .dnsPolicy | default "ClusterFirst" | quote }}
hostIPC: {{ default false .hostIPC }}
hostNetwork: {{ default false .hostNetwork }}
hostPID: {{ default false .hostPID }}
restartPolicy: {{ .restartPolicy | default "Always" | quote }}
shareProcessNamespace: {{ default false .shareProcessNamespace }}
activeDeadlineSeconds: {{ default nil .activeDeadlineSeconds | quote }}
subdomain: {{ default nil .subdomain | quote }}
schedulerName: {{ default nil .schedulerName | quote }}
hostname: {{ default nil .hostname | quote }}
nodeName: {{ default nil .nodeName | quote }}
serviceAccountName: {{ default nil .serviceAccountName | quote }}
automountServiceAccountToken: {{ default nil .automountServiceAccountToken | quote }}
priority: {{ default nil .priority | quote }}
priorityClassName: {{ default nil .priorityClassName | quote }}

{{- with .nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .dnsConfig }}
dnsConfig:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .securityContext }}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .hostAliases }}
hostAliases:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .volumes }}
volumes:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .initContainers }}
initContainers:
{{- include "container" . | nindent 2 }}
{{- end }}

containers:
{{- include "container" .containers | nindent 2 }}

{{- end }}