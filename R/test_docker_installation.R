#' Tests whether docker is correctly installed and available
#'
#' This code is written by Robrecht Cannoodt (https://github.com/rcannood)
#'
#' @param detailed Whether top do a detailed check
#'
#' @importFrom crayon red green bold
#' @importFrom processx run
#'
#' @examples
#' test_docker_installation()
#'
#' if (test_docker_installation()) {
#'   test_docker_installation(detailed = TRUE)
#' }
#'
#' @export
test_docker_installation <- function(detailed = FALSE) {
  if (!detailed) {

    tryCatch({
      out <- processx::run("docker", c("info", "--format", "{{.OSType}}"), error_on_status = FALSE, stderr_callback = print_processx, timeout = 2)
      ostype <- out$stdout %>% trimws() # remove trailing ' (in windows)
      ostype <- gsub(pattern = "'", replacement = "", x = ostype)
      out$status == 0 && ostype == "linux"
    },
    error = function(e) {
      FALSE
    })
  } else {
    # test if docker command is found
    output <- tryCatch(
      processx::run("docker", "version", error_on_status = FALSE, stderr_callback = print_processx),
      error = function(e) {list(status = 1)}
    )
    if (output$status == 0) {
      message(crayon::green("\u2714 Docker is installed"))
    } else {
      installation_url <- switch(
        tolower(Sys.info()["sysname"]),
        windows = "https://docs.docker.com/docker-for-windows/install/ (for Windows 10) or https://docs.docker.com/toolbox/toolbox_install_windows/ (for older Windows installations)",
        darwin = "https://docs.docker.com/docker-for-mac/install/",
        "https://docs.docker.com/install/"
      )

      msg <- paste0(
        "\u274C An installation of docker is necessary to run this method. See ", installation_url, " for instructions."
      )
      stop(crayon::red())
    }

    # test if docker daemon is running
    output <- processx::run("docker", c("version", "--format", "{{.Client.APIVersion}}"), error_on_status = FALSE, stderr_callback = print_processx)
    if (output$status != 0) {
      stop(crayon::red(paste0(
        "\u274C Docker daemon does not seem to be running... \n",
        "- Try running ", crayon::bold('dockerd'), " in the command line \n",
        "- See https://docs.docker.com/config/daemon/"
      )))
    }
    message(crayon::green("\u2714 Docker daemon is running"))

    # test if docker version is recent enough
    version <- output$stdout %>% trimws() # remove trailing ' (in windows)
    version <- gsub(pattern = "'", replacement = "", x = version)
    if (utils::compareVersion("1.0", version) > 0) {
      stop(crayon::red("\u274C Docker API version is", version, ". Requires 1.0 or later"))
    }

    message(crayon::green(paste0("\u2714 Docker is at correct version (>1.0): ", version)))

    # test if docker format is linux
    output <- processx::run("docker", c("info", "--format", "{{.OSType}}"), error_on_status = FALSE, stderr_callback = print_processx)
    ostype <- output$stdout %>% trimws() # remove trailing ' (in windows)
    ostype <- gsub(pattern = "'", replacement = "", x = ostype)
    if (ostype != "linux") {
      stop(crayon::red(paste0(
        "\u274C Docker is not running in linux mode, but in ", ostype, " mode. \n",
        " Please switch to linux containers: https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers"
      )))
    }

    message(crayon::green("\u2714 Docker is in linux mode"))

    # test if docker images can be pulled
    output <- processx::run("docker", c("pull", "alpine:3.7"), error_on_status = FALSE, stderr_callback = print_processx, spinner = TRUE)
    if (output$status != 0) {
      stop(crayon::red("\u274C Unable to pull docker images."))
    }
    message(crayon::green("\u2714 Docker can pull images"))

    # test if docker can run images, will fail on windows if linux containers are not enabled
    output <- processx::run("docker", c("run", "alpine:3.7"), error_on_status = FALSE, stderr_callback = print_processx)
    if (output$status != 0) {
      stop(crayon::red("\u274C Unable to run an image"))
    }
    message(crayon::green("\u2714 Docker can run image"))

    # test if docker volume can be mounted
    volume_dir <- tempdir()
    output <- processx::run("docker", c("run", "-v", paste0(volume_dir, ":/mount"), "alpine:3.7"), error_on_status = FALSE, stderr_callback = print_processx)
    if (output$status != 0) {
      stop(crayon::red(paste0(
        "\u274C Unable to mount temporary directory: ", volume_dir, ". \n",
        "\tOn windows, you need to enable the shared drives (https://rominirani.com/docker-on-windows-mounting-host-directories-d96f3f056a2c)"
      )))
    }
    message(crayon::green("\u2714 Docker can mount temporary volumes"))

    message(crayon::green(crayon::bold(pad("\u2714 Docker test successful ", 90, side = "right", "-"))))

    TRUE
  }
}


print_processx <- function(x, proc) {
  cat(x)
}


pad <- function(string, width, side = c("left", "right", "both"), pad = " ") {
  side <- match.arg(side)
  strlen <- nchar(string)

  nchars <- width - strlen

  if (side == "left") {
    ncharsl <- nchars
    ncharsr <- 0
  } else if (side == "right") {
    ncharsl <- 0
    ncharsr <- nchars
  } else {
    ncharsl <- floor(nchars / 2)
    ncharsr <- ceiling(nchars / 2)
  }

  paste0(
    paste(rep(pad, ncharsl), collapse = ""),
    string,
    paste(rep(pad, ncharsr), collapse = "")
  )
}
