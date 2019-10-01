## Background
This repository aims to provide you with Kubernetes Resource templates that you can use in you chart with minimal changes. 

# How this project helps?
To create a new skeleton chart, run the following command (which will provide you with a basic structured chart):

    helm create my-chart                             # helm create <chart-name>
    
Inside the `templates/` directory of the 'my-chart' is where all the Kubernetes Resource related templates (YAML files) go. You can copy paste the required Resource YAML files from the repository `demo/templates/` to `my-chart/templates/`.

> Note that while copy pasting the templates, the indentation should be preserved. I've done this in VS Code and it preserves the indentation. Messing with the indentation of templates might result in errors while trying to install the chart.

However, there are a few helper scripts that are common to multiple Kubernetes Resources. For ex, Deployment, Replica Set, CronJob and Job all the creates a Pod at runtime so instead of having the Pod spec in the YAML for all of these resources, I've created a `_pod.tpl` helper script that can be *injected* in these. This is also helpful, if at some later Kubernetes version, the spec for Pod changes because then we'll only need to change it in one tpl file (`_pod.tpl`) instead of multiple YAMl files - `Deployment.yaml`, `CronJob.yaml`, etc. 

> All problems in Computer Science can be solved by adding another layer of indirection -- David J.Wheeler [1](https://en.wikipedia.org/wiki/Fundamental_theorem_of_software_engineering)

Put simply, if you want to create a Deployment, you'll have to copy:
  - Deployment.yaml
  - _pod.tpl
  - _container.tpl
  
Also, I've tried to keep the Resource YAMLs complete and consistent with Kubernetes v1.15, i.e., all the properties that you might want to specify is available in the template. I've also filled in the default values for these properties, if you haven't overriden the value.

# Creating a new chart
After you've created a new template, you need to change the name from `demo` in those YAMLs to your application name. Use Find/Replace option of your Text Editor/IDE. And I've completely omitted the `tests/` directory, so you can delete it from your chart.

After this, you only need to populate `values.yaml` file. And your chart will be ready.

# Testing your chart
After creating your chart, you should do some inital testing before installing it in the cluster. To see how your charts are rendered, run the following command:

    helm template my-chart            # helm template <chart-name>
    
This will give you the YAML for each Resource in the format that Kubernetes understands. But it will only report rendering errors and not syntactical errors. This doesn't validate your chart. To do that, run:

    helm lint my-chart               # helm lint <chart-name>
    
There is one more command that does strict checking. It simulates an install by connecting to Tiller running on the cluster but doesn't actually install anything:

    helm install --debug --dry-run my-chart      # helm install --debug --dry-run <chart-name>
    
> I usually run all the three commands in the specified order before installing anything.
