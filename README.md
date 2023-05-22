# fake-idi

A reproduction of the Stats NZ Data Lab environment for R users to explore synthetic data and learn how to interract with the IDI in a non-restrictive environment.

## To run:

You might need to use `sudo ...` to run the docker commands if you are not in the `docker` group.

```shell
docker pull ghcr.io/terourou/fake-idi:main
docker run -it --rm \
    -p 8787:8787 \
    -e DISABLE_AUTH=true \
    -v ./.workspace:/home/rstudio/workspace \
    ghcr.io/terourou/fake-idi:main
```

Then go to `localhost:8787` in your browser.

The local `.workspace` folder is linked in the above command, and contains a basic script to get started. You can edit this script, or create your own in the `workspace` folder in RStudio and it will persist after you stop the container.
