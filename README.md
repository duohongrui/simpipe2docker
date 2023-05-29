
# simpipe2docker links Docker containers and R environment and performs simulations for single-cell and spatial transcriptomics data.

## Installation

### simpipe2docker

You can install the development version of simpipe from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("duohongrui/simpipe2docker")
```

### Docker

Firstly, users should install the the Docker Desktop
(<https://www.docker.com/>).

After installing Docker Desktop and starting the service, please check
it by:

``` r
simpipe2docker::test_docker_installation(detailed = TRUE)
```

    ## ✔ Docker is installed

    ## ✔ Docker daemon is running

    ## ✔ Docker is at correct version (>1.0): 1.41

    ## ✔ Docker is in linux mode

    ## ✔ Docker can pull images

    ## ✔ Docker can run image

    ## ✔ Docker can mount temporary volumes

    ## ✔ Docker test successful -----------------------------------------------------------------

    ## [1] TRUE

Next, pull our Docker image called
[simpipe](https://hub.docker.com/repository/docker/duohongrui/simpipe/general):

Terminal command:

``` bash
docker pull duohongrui/simpipe:latest
```

Or you can run the command in R:

``` r
babelwhale::pull_container(container_id = "duohongrui/simpipe:latest")
```

Now, you have already installed Docker Desktop successfully!

## Usage

The documents of estimating parameters from real data and simulating new
datasets by **simpipe2docker** are all described on our
[simsite](http://www.ciblab.net/software/Simsite/).

## Contact

If you have any question, please email to Hongrui Duo
(<duohongrui@cqnu.edu.cn>) or raise an issue for that.
