## Background
This repository aims to provide you with Kubernetes resource templates that you can use in your chart with minimal changes. 

## Creating a Chart
​
The `demo`
 directory has templates for many common Kubernetes resource. 
To generate a new chart, run the following command with `charts` as base directory:
​
```
helm create <chart-name>
```
> It's best to have Chart name same as Component name.
​
This will generate a skeleton for chart. Identify what Kubernetes resources your 
application needs and replace those from templates directory with the ones in 
`demo`
directory. The templates in 
`demo` 
directory are designed to be generic and should serve all the use cases. In this 
way, we can have same templates in every chart across the org.
​
It's important to understand which templates are to be included while creating a 
chart. One Kubernetes Resource can create another Resource. 
​
```
A -> B -> C -> .. (read: A creates B which in turn creates C and so on..)
​
CronJob      Deployment     StatefulSet
   +             +              +
   |             |              |
   v             v              |
  Job        ReplicaSet         |
   +             +              |
   |             |              |
   |             v              |
   +----------> Pod <-----------+
                 +              |
                 |              |
                 v              v
              Container        PVC (_volumeClaimTemplate.tpl)
```
​
> **`_baseHelpers.tpl` has to be included in all the charts. Replace `demo` in this 
file with your chart name.**
​
The `_pod.tpl` and `_container.tpl` files are meant to be included if you want to 
create any Kubernetes Resource that creates Pods (which will in turn create 
containers).
​
> **TL;DR**: 
>   - If you're creating Deployment, CronJob, Job, StatefulSet or DaemonSet include 
`_pod.tpl` and `_container.tpl` in your templates. 
>   - If you're creating PVC, do include 
`_persistentVolumeClaimSpec.tpl` and `PersistentVolumeClaim.yaml` in your chart's 
templates.
​
> Many times, when you copy the files from base to your chart's `templates/`, IntelliJ messes 
up the indentation and then the chart won't work. VSCode doesn't mess with the indentation.
​
> You might need to delete `tests` directory in `<chart-name>/templates/` for the chart 
to properly work. None of the charts in this repository currently use it.
​
After this, we need to populate the `values.yaml` file. 
**It's expected that from this point forward, changes will only occur in `values.yaml` 
file.**
​
After the changes are done in `values.yaml` file, it's time to see how the final templates 
are rendered and if there are any errors. We can check how helm renders the files
by running the command:
​
```
helm template <chart-name/>
```
​
This will only report rendering errors not any syntactical errors. This doesn't validate 
the chart. To check those, run the command:
​
```
helm lint <chart-name/>
```
​
There is another command which does a strict checking on the chart:
​
```
helm install --debug --dry-run <path/to/chart-name/>
```
​
This command simulates an install by connecting to Tiller running on the server but doesn't 
actually install anything.
​
## Installing a chart
​
If you're installing a chart for the first time, you can run the following command:
​
```
helm install --namespace <namespace> <path/to/chart/>
```
> **Chart is installed only once**, and for any new changes the chart is either 
upgraded/rollback(d). If you run `helm install` of the chart multiple times, 
multiple instances will be installed which you probably don't want. **TL;DR**: Don't 
install multiple times unless you know what you're doing.
​
## Upgrading a chart
​
If the chart has been installed and you just want to upgrade it, you'll first have to get the 
release name of the installed chart. Suppose your application old chart name is `click`, then
run the following command:
​
```
helm list --namespace <namespace> | grep <old-chart-name>
```
​
This should bring the output as follows:
​
```
NAME              	REVISION	UPDATED                 	STATUS  	CHART           APP VERSION	NAMESPACE
agile-butterfly   	17      	Thu Aug 22 19:22:46 2019	DEPLOYED	abc-0.1.0       1.0        	n1
flippant-anaconda 	1       	Wed Jul 24 16:13:54 2019	DEPLOYED	def-0.1.0	    1.0        	n1
hissing-bear      	6       	Wed Sep 25 17:12:59 2019	DEPLOYED	ghi-0.1.0       1.0        	n1
```
​
The `CHART` column lists the chart name of this application. Figure out 
the correct name and for the corresponding entry(row), get the value in 
the column `NAME`. This is your release name.
​
**For ex**: If you want to upgrade the chart for click, run the command:
​
```
helm list --namespace <namespace> | grep click
```
​
The correct chart name in the output is `click-0.1.0` and hence the 
release name will be `hissing-bear`.
​
Once we have the release name, we can upgrade using the following command:
​
```
helm upgrade <release-name> <path/to/updated/chart/>
```
​
> If you simply ugrade a ConfigMap in chart's `values.yaml` file, the pod 
won't be restarted by itself. The general idea is only those Kubernetes 
Resources are restarted which actually changed in `values.yaml` file.
​
## Rolling back changes (Degrading to a previous version of the chart)
​
The `REVISION` column in the output of `helm list` gives the info about 
how many times a chart has been `upgraded`. Every time an `upgrade/rollback` 
happens, the REVISION count increases by 1.
​
If you know what revision you have to rollback to, issue the command:
​
```
helm rollback <release-name> <revision-no>
```
​
## Deleting a chart
​
If you want to delete a chart, get the release name of the chart and run the following:
​
```
helm delete --purge <release-name>
```
​
It's possible in some cases and running the delete command won't delete the PVCs 
created. The idea is since PVCs can have shared data that can be used across 
deployments/restarts of the pod. If you're sure you want to still delete the PVC, then
you need to delete them manually.
